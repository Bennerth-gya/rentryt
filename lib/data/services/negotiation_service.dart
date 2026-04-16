import 'dart:async';

import 'package:comfi/data/models/negotiation_models.dart';
import 'package:comfi/data/models/order_model.dart';
import 'package:comfi/data/models/product_model.dart';
import 'package:comfi/data/models/user_model.dart';
import 'package:comfi/data/services/order_service.dart';

abstract class NegotiationService {
  Future<NegotiationThreadSnapshot> createOrGetThread({
    required ProductModel product,
    required UserModel buyer,
    required UserModel seller,
    String currency = 'GHS',
  });

  Stream<NegotiationThreadSnapshot> watchThread(String chatId);

  Future<void> sendTextMessage({
    required String chatId,
    required String senderId,
    required String content,
    required String clientMessageId,
  });

  Future<void> sendOffer({
    required String chatId,
    required String buyerId,
    required double offeredPrice,
    required String clientMessageId,
  });

  Future<void> respondToOffer({
    required String chatId,
    required String offerId,
    required String actorId,
    required OfferAction action,
    required String clientMessageId,
    double? counterPrice,
  });

  Future<void> setTyping({
    required String chatId,
    required String userId,
    required bool isTyping,
  });

  Future<void> markSeen({required String chatId, required String userId});

  Future<OrderModel?> getLockedOrder(String chatId);
}

class InMemoryNegotiationService implements NegotiationService {
  InMemoryNegotiationService({required OrderService orderService})
    : _orderService = orderService;

  final OrderService _orderService;
  final Map<String, _NegotiationRoom> _roomsById = <String, _NegotiationRoom>{};

  @override
  Future<NegotiationThreadSnapshot> createOrGetThread({
    required ProductModel product,
    required UserModel buyer,
    required UserModel seller,
    String currency = 'GHS',
  }) async {
    final chatId = _buildChatId(
      productId: product.id,
      buyerId: buyer.id,
      sellerId: seller.id,
    );
    final existingRoom = _roomsById[chatId];
    if (existingRoom != null) {
      existingRoom.isRemoteUserOnline = true;
      _scheduleOfferExpiration(existingRoom);
      return _snapshot(existingRoom);
    }

    final now = DateTime.now();
    final room = _NegotiationRoom(
      product: product,
      buyer: buyer,
      seller: seller,
      chat: NegotiationChatModel(
        id: chatId,
        buyerId: buyer.id,
        sellerId: seller.id,
        productId: product.id,
        currency: currency,
        createdAt: now,
        updatedAt: now,
      ),
    );

    room.messages.addAll(<NegotiationMessageModel>[
      _systemMessage(
        room,
        content:
            'Negotiation started for ${product.name}. Offers stay active for 24 hours.',
        createdAt: now,
      ),
      _textMessage(
        room,
        senderId: seller.id,
        content:
            'Hi ${buyer.name.split(' ').first}, I can answer questions or review your best offer.',
        createdAt: now.add(const Duration(seconds: 1)),
      ),
    ]);
    room.chat = _refreshChatSummary(
      room.chat,
      room.messages.last,
      updatedAt: room.messages.last.timestamp,
    );

    _roomsById[chatId] = room;
    _emit(room);
    return _snapshot(room);
  }

  @override
  Stream<NegotiationThreadSnapshot> watchThread(String chatId) {
    final room = _requireRoom(chatId);
    return Stream<NegotiationThreadSnapshot>.multi((controller) {
      controller.add(_snapshot(room));
      final subscription = room.controller.stream.listen(
        controller.add,
        onError: controller.addError,
        onDone: controller.close,
      );
      controller.onCancel = subscription.cancel;
    }, isBroadcast: true);
  }

  @override
  Future<void> sendTextMessage({
    required String chatId,
    required String senderId,
    required String content,
    required String clientMessageId,
  }) async {
    final trimmedContent = content.trim();
    if (trimmedContent.isEmpty) {
      return;
    }

    final room = _requireRoom(chatId);
    _expireOffersIfNeeded(room);
    if (!_trackClientMessage(room, clientMessageId)) {
      return;
    }

    room.connectionState = ChatConnectionState.syncing;
    _emit(room);
    await Future<void>.delayed(const Duration(milliseconds: 120));

    final message = _textMessage(
      room,
      senderId: senderId,
      content: trimmedContent,
      clientMessageId: clientMessageId,
      createdAt: DateTime.now(),
    );
    room.messages.add(message);
    room.typingUserIds.remove(senderId);
    room.connectionState = ChatConnectionState.connected;
    room.chat = _refreshChatSummary(
      room.chat,
      message,
      updatedAt: message.timestamp,
    );
    _emit(room);
  }

  @override
  Future<void> sendOffer({
    required String chatId,
    required String buyerId,
    required double offeredPrice,
    required String clientMessageId,
  }) async {
    final room = _requireRoom(chatId);
    _expireOffersIfNeeded(room);

    if (!_trackClientMessage(room, clientMessageId)) {
      return;
    }
    if (buyerId != room.buyer.id) {
      throw StateError('Only the buyer can start a new offer.');
    }
    if (offeredPrice <= 0) {
      throw StateError('Offer amount must be greater than zero.');
    }
    if (room.chat.lockedOrderId != null) {
      throw StateError('This negotiation is already locked to an order.');
    }
    if (room.chat.activeOfferId != null) {
      throw StateError('Resolve the current offer before sending another one.');
    }

    final now = DateTime.now();
    final offer = NegotiationOfferModel(
      id: _nextId('offer'),
      chatId: room.chat.id,
      productId: room.product.id,
      buyerId: room.buyer.id,
      sellerId: room.seller.id,
      createdById: buyerId,
      offeredPrice: offeredPrice,
      currency: room.chat.currency,
      status: OfferStatus.pending,
      createdAt: now,
      expiresAt: now.add(const Duration(hours: 24)),
    );
    room.offers.add(offer);

    final message = NegotiationMessageModel(
      id: _nextId('msg'),
      chatId: room.chat.id,
      senderId: buyerId,
      type: NegotiationMessageType.offer,
      content: 'Offer ${room.chat.currency} ${offeredPrice.toStringAsFixed(2)}',
      timestamp: now,
      clientMessageId: clientMessageId,
      offerId: offer.id,
      deliveryState: MessageDeliveryState.delivered,
      seenByUserIds: <String>[buyerId],
    );
    room.messages.add(message);
    room.typingUserIds.remove(buyerId);
    room.chat = _refreshChatSummary(
      room.chat.copyWith(activeOfferId: offer.id, latestOfferId: offer.id),
      message,
      updatedAt: now,
    );
    _scheduleOfferExpiration(room);
    _emit(room);
  }

  @override
  Future<void> respondToOffer({
    required String chatId,
    required String offerId,
    required String actorId,
    required OfferAction action,
    required String clientMessageId,
    double? counterPrice,
  }) async {
    final room = _requireRoom(chatId);
    _expireOffersIfNeeded(room);

    if (!_trackClientMessage(room, clientMessageId)) {
      return;
    }

    final offerIndex = room.offers.indexWhere((entry) => entry.id == offerId);
    if (offerIndex == -1) {
      throw StateError('The selected offer no longer exists.');
    }

    final currentOffer = room.offers[offerIndex];
    if (!currentOffer.isPending) {
      throw StateError('This offer is no longer active.');
    }
    if (actorId == currentOffer.createdById) {
      throw StateError('You cannot respond to your own offer.');
    }

    final now = DateTime.now();
    switch (action) {
      case OfferAction.accept:
        if (room.chat.lockedOrderId != null) {
          throw StateError('Another offer has already been accepted.');
        }
        final order = await _orderService.createNegotiatedOrder(
          chatId: room.chat.id,
          offerId: currentOffer.id,
          productId: room.product.id,
          productName: room.product.name,
          buyerId: room.buyer.id,
          sellerId: room.seller.id,
          customerName: room.buyer.name,
          amount: currentOffer.offeredPrice,
          currency: room.chat.currency,
        );
        room.offers[offerIndex] = currentOffer.copyWith(
          status: OfferStatus.accepted,
          respondedAt: now,
          respondedById: actorId,
          lockedOrderId: order.id,
        );
        room.lockedOrder = order;
        room.chat = room.chat.copyWith(
          activeOfferId: null,
          latestOfferId: currentOffer.id,
          agreedOfferId: currentOffer.id,
          lockedPrice: currentOffer.offeredPrice,
          lockedOrderId: order.id,
          updatedAt: now,
        );
        final acceptedMessage = _systemMessage(
          room,
          content:
              '${room.participantName(actorId)} accepted ${room.chat.currency} ${currentOffer.offeredPrice.toStringAsFixed(2)}. Order ${order.id} is ready for mobile money checkout.',
          createdAt: now,
        );
        room.messages.add(acceptedMessage);
        room.chat = _refreshChatSummary(
          room.chat,
          acceptedMessage,
          updatedAt: now,
        );
        break;
      case OfferAction.reject:
        room.offers[offerIndex] = currentOffer.copyWith(
          status: OfferStatus.rejected,
          respondedAt: now,
          respondedById: actorId,
        );
        room.chat = room.chat.copyWith(
          activeOfferId: null,
          latestOfferId: currentOffer.id,
          updatedAt: now,
        );
        final rejectedMessage = _systemMessage(
          room,
          content:
              '${room.participantName(actorId)} rejected the offer of ${room.chat.currency} ${currentOffer.offeredPrice.toStringAsFixed(2)}.',
          createdAt: now,
        );
        room.messages.add(rejectedMessage);
        room.chat = _refreshChatSummary(
          room.chat,
          rejectedMessage,
          updatedAt: now,
        );
        break;
      case OfferAction.counter:
        if (actorId != room.seller.id) {
          throw StateError(
            'Only the seller can counter an active buyer offer.',
          );
        }
        if (counterPrice == null || counterPrice <= 0) {
          throw StateError('Enter a valid counter offer amount.');
        }

        room.offers[offerIndex] = currentOffer.copyWith(
          status: OfferStatus.countered,
          respondedAt: now,
          respondedById: actorId,
        );

        final counterOffer = NegotiationOfferModel(
          id: _nextId('offer'),
          chatId: room.chat.id,
          productId: room.product.id,
          buyerId: room.buyer.id,
          sellerId: room.seller.id,
          createdById: actorId,
          offeredPrice: counterPrice,
          currency: room.chat.currency,
          status: OfferStatus.pending,
          createdAt: now,
          expiresAt: now.add(const Duration(hours: 24)),
          previousOfferId: currentOffer.id,
        );
        room.offers.add(counterOffer);

        final counterMessage = NegotiationMessageModel(
          id: _nextId('msg'),
          chatId: room.chat.id,
          senderId: actorId,
          type: NegotiationMessageType.offer,
          content:
              'Counter offer ${room.chat.currency} ${counterPrice.toStringAsFixed(2)}',
          timestamp: now,
          clientMessageId: clientMessageId,
          offerId: counterOffer.id,
          deliveryState: MessageDeliveryState.delivered,
          seenByUserIds: <String>[actorId],
        );
        room.messages.add(counterMessage);
        room.chat = _refreshChatSummary(
          room.chat.copyWith(
            activeOfferId: counterOffer.id,
            latestOfferId: counterOffer.id,
          ),
          counterMessage,
          updatedAt: now,
        );
        break;
    }

    room.typingUserIds.remove(actorId);
    _scheduleOfferExpiration(room);
    _emit(room);
  }

  @override
  Future<void> setTyping({
    required String chatId,
    required String userId,
    required bool isTyping,
  }) async {
    final room = _requireRoom(chatId);
    if (isTyping) {
      if (!room.typingUserIds.contains(userId)) {
        room.typingUserIds.add(userId);
      }
    } else {
      room.typingUserIds.remove(userId);
    }
    _emit(room);
  }

  @override
  Future<void> markSeen({
    required String chatId,
    required String userId,
  }) async {
    final room = _requireRoom(chatId);
    var changed = false;

    for (var index = 0; index < room.messages.length; index++) {
      final message = room.messages[index];
      if (message.senderId == userId || message.isSeenBy(userId)) {
        continue;
      }

      final seenBy = <String>{...message.seenByUserIds, userId}.toList();
      room.messages[index] = message.copyWith(
        seenByUserIds: seenBy,
        deliveryState: MessageDeliveryState.seen,
      );
      changed = true;
    }

    if (!changed) {
      return;
    }

    room.chat = room.chat.copyWith(updatedAt: DateTime.now());
    _emit(room);
  }

  @override
  Future<OrderModel?> getLockedOrder(String chatId) async {
    final room = _requireRoom(chatId);
    return room.lockedOrder;
  }

  _NegotiationRoom _requireRoom(String chatId) {
    final room = _roomsById[chatId];
    if (room == null) {
      throw StateError('Negotiation chat was not found.');
    }
    return room;
  }

  void _emit(_NegotiationRoom room) {
    _expireOffersIfNeeded(room);
    room.controller.add(_snapshot(room));
  }

  NegotiationThreadSnapshot _snapshot(_NegotiationRoom room) {
    return NegotiationThreadSnapshot(
      chat: room.chat,
      product: room.product,
      buyer: room.buyer,
      seller: room.seller,
      messages: List<NegotiationMessageModel>.unmodifiable(room.messages),
      offers: List<NegotiationOfferModel>.unmodifiable(room.offers),
      lockedOrder: room.lockedOrder,
      typingUserIds: List<String>.unmodifiable(room.typingUserIds),
      connectionState: room.connectionState,
      isRemoteUserOnline: room.isRemoteUserOnline,
    );
  }

  bool _trackClientMessage(_NegotiationRoom room, String clientMessageId) {
    if (room.processedClientMessageIds.contains(clientMessageId)) {
      return false;
    }
    room.processedClientMessageIds.add(clientMessageId);
    return true;
  }

  NegotiationChatModel _refreshChatSummary(
    NegotiationChatModel chat,
    NegotiationMessageModel message, {
    required DateTime updatedAt,
  }) {
    return chat.copyWith(
      lastMessagePreview: message.content,
      lastMessageSenderId: message.senderId,
      lastMessageAt: message.timestamp,
      updatedAt: updatedAt,
    );
  }

  NegotiationMessageModel _systemMessage(
    _NegotiationRoom room, {
    required String content,
    required DateTime createdAt,
  }) {
    return NegotiationMessageModel(
      id: _nextId('msg'),
      chatId: room.chat.id,
      senderId: 'system',
      type: NegotiationMessageType.system,
      content: content,
      timestamp: createdAt,
      deliveryState: MessageDeliveryState.seen,
      seenByUserIds: <String>[room.buyer.id, room.seller.id],
    );
  }

  NegotiationMessageModel _textMessage(
    _NegotiationRoom room, {
    required String senderId,
    required String content,
    String? clientMessageId,
    required DateTime createdAt,
  }) {
    return NegotiationMessageModel(
      id: _nextId('msg'),
      chatId: room.chat.id,
      senderId: senderId,
      type: NegotiationMessageType.text,
      content: content,
      timestamp: createdAt,
      clientMessageId: clientMessageId,
      deliveryState: MessageDeliveryState.delivered,
      seenByUserIds: <String>[senderId],
    );
  }

  void _expireOffersIfNeeded(_NegotiationRoom room) {
    final activeOfferId = room.chat.activeOfferId;
    if (activeOfferId == null) {
      return;
    }

    final offerIndex = room.offers.indexWhere(
      (offer) => offer.id == activeOfferId,
    );
    if (offerIndex == -1) {
      room.chat = room.chat.copyWith(
        activeOfferId: null,
        updatedAt: DateTime.now(),
      );
      return;
    }

    final offer = room.offers[offerIndex];
    if (!offer.isPending || DateTime.now().isBefore(offer.expiresAt)) {
      return;
    }

    final now = DateTime.now();
    room.offers[offerIndex] = offer.copyWith(
      status: OfferStatus.expired,
      respondedAt: now,
    );
    room.chat = room.chat.copyWith(
      activeOfferId: null,
      latestOfferId: offer.id,
      updatedAt: now,
    );
    room.messages.add(
      _systemMessage(
        room,
        content:
            'Offer ${room.chat.currency} ${offer.offeredPrice.toStringAsFixed(2)} expired after 24 hours.',
        createdAt: now,
      ),
    );
    room.chat = _refreshChatSummary(
      room.chat,
      room.messages.last,
      updatedAt: now,
    );
    _scheduleOfferExpiration(room);
  }

  void _scheduleOfferExpiration(_NegotiationRoom room) {
    room.expirationTimer?.cancel();
    final activeOffer = room.offers.cast<NegotiationOfferModel?>().firstWhere(
      (offer) => offer?.id == room.chat.activeOfferId,
      orElse: () => null,
    );
    if (activeOffer == null || !activeOffer.isPending) {
      return;
    }

    final duration = activeOffer.expiresAt.difference(DateTime.now());
    if (duration.isNegative || duration == Duration.zero) {
      _expireOffersIfNeeded(room);
      _emit(room);
      return;
    }

    room.expirationTimer = Timer(duration, () {
      _expireOffersIfNeeded(room);
      _emit(room);
    });
  }

  static String _buildChatId({
    required String productId,
    required String buyerId,
    required String sellerId,
  }) {
    final raw = 'chat-$productId-$buyerId-$sellerId'
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    return raw;
  }

  String _nextId(String prefix) {
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}';
  }
}

class _NegotiationRoom {
  _NegotiationRoom({
    required this.product,
    required this.buyer,
    required this.seller,
    required this.chat,
  });

  final ProductModel product;
  final UserModel buyer;
  final UserModel seller;
  final StreamController<NegotiationThreadSnapshot> controller =
      StreamController<NegotiationThreadSnapshot>.broadcast();
  final List<NegotiationMessageModel> messages = <NegotiationMessageModel>[];
  final List<NegotiationOfferModel> offers = <NegotiationOfferModel>[];
  final List<String> typingUserIds = <String>[];
  final Set<String> processedClientMessageIds = <String>{};
  NegotiationChatModel chat;
  OrderModel? lockedOrder;
  ChatConnectionState connectionState = ChatConnectionState.connected;
  bool isRemoteUserOnline = true;
  Timer? expirationTimer;

  String participantName(String userId) {
    if (userId == buyer.id) {
      return buyer.name;
    }
    if (userId == seller.id) {
      return seller.name;
    }
    return 'System';
  }
}
