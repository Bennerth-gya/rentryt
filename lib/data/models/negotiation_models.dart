import 'package:comfi/data/models/order_model.dart';
import 'package:comfi/data/models/product_model.dart';
import 'package:comfi/data/models/user_model.dart';

enum NegotiationMessageType { text, offer, system }

enum OfferStatus { pending, accepted, rejected, countered, expired }

enum OfferAction { accept, reject, counter }

enum MessageDeliveryState { sending, sent, delivered, seen, failed }

enum ChatConnectionState { connected, syncing, offline }

class NegotiationChatModel {
  const NegotiationChatModel({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.productId,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
    this.activeOfferId,
    this.latestOfferId,
    this.agreedOfferId,
    this.lockedPrice,
    this.lockedOrderId,
    this.lastMessagePreview,
    this.lastMessageSenderId,
    this.lastMessageAt,
  });

  final String id;
  final String buyerId;
  final String sellerId;
  final String productId;
  final String currency;
  final String? activeOfferId;
  final String? latestOfferId;
  final String? agreedOfferId;
  final double? lockedPrice;
  final String? lockedOrderId;
  final String? lastMessagePreview;
  final String? lastMessageSenderId;
  final DateTime? lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get hasLockedPrice => lockedPrice != null && lockedOrderId != null;

  NegotiationChatModel copyWith({
    String? id,
    String? buyerId,
    String? sellerId,
    String? productId,
    String? currency,
    Object? activeOfferId = _sentinel,
    Object? latestOfferId = _sentinel,
    Object? agreedOfferId = _sentinel,
    Object? lockedPrice = _sentinel,
    Object? lockedOrderId = _sentinel,
    Object? lastMessagePreview = _sentinel,
    Object? lastMessageSenderId = _sentinel,
    Object? lastMessageAt = _sentinel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NegotiationChatModel(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      productId: productId ?? this.productId,
      currency: currency ?? this.currency,
      activeOfferId: identical(activeOfferId, _sentinel)
          ? this.activeOfferId
          : activeOfferId as String?,
      latestOfferId: identical(latestOfferId, _sentinel)
          ? this.latestOfferId
          : latestOfferId as String?,
      agreedOfferId: identical(agreedOfferId, _sentinel)
          ? this.agreedOfferId
          : agreedOfferId as String?,
      lockedPrice: identical(lockedPrice, _sentinel)
          ? this.lockedPrice
          : lockedPrice as double?,
      lockedOrderId: identical(lockedOrderId, _sentinel)
          ? this.lockedOrderId
          : lockedOrderId as String?,
      lastMessagePreview: identical(lastMessagePreview, _sentinel)
          ? this.lastMessagePreview
          : lastMessagePreview as String?,
      lastMessageSenderId: identical(lastMessageSenderId, _sentinel)
          ? this.lastMessageSenderId
          : lastMessageSenderId as String?,
      lastMessageAt: identical(lastMessageAt, _sentinel)
          ? this.lastMessageAt
          : lastMessageAt as DateTime?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory NegotiationChatModel.fromJson(Map<String, dynamic> json) {
    return NegotiationChatModel(
      id: json['id'] as String,
      buyerId: json['buyerId'] as String,
      sellerId: json['sellerId'] as String,
      productId: json['productId'] as String,
      currency: (json['currency'] as String?) ?? 'GHS',
      activeOfferId: json['activeOfferId'] as String?,
      latestOfferId: json['latestOfferId'] as String?,
      agreedOfferId: json['agreedOfferId'] as String?,
      lockedPrice: (json['lockedPrice'] as num?)?.toDouble(),
      lockedOrderId: json['lockedOrderId'] as String?,
      lastMessagePreview: json['lastMessagePreview'] as String?,
      lastMessageSenderId: json['lastMessageSenderId'] as String?,
      lastMessageAt: _readDateTime(json['lastMessageAt']),
      createdAt: _readDateTime(json['createdAt']) ?? DateTime.now(),
      updatedAt: _readDateTime(json['updatedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'productId': productId,
      'currency': currency,
      'activeOfferId': activeOfferId,
      'latestOfferId': latestOfferId,
      'agreedOfferId': agreedOfferId,
      'lockedPrice': lockedPrice,
      'lockedOrderId': lockedOrderId,
      'lastMessagePreview': lastMessagePreview,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class NegotiationOfferModel {
  const NegotiationOfferModel({
    required this.id,
    required this.chatId,
    required this.productId,
    required this.buyerId,
    required this.sellerId,
    required this.createdById,
    required this.offeredPrice,
    required this.currency,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
    this.respondedAt,
    this.respondedById,
    this.previousOfferId,
    this.lockedOrderId,
  });

  final String id;
  final String chatId;
  final String productId;
  final String buyerId;
  final String sellerId;
  final String createdById;
  final double offeredPrice;
  final String currency;
  final OfferStatus status;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime? respondedAt;
  final String? respondedById;
  final String? previousOfferId;
  final String? lockedOrderId;

  bool get isPending => status == OfferStatus.pending;
  bool get isResolved => !isPending;
  bool get isCounterOffer => previousOfferId != null;

  NegotiationOfferModel copyWith({
    String? id,
    String? chatId,
    String? productId,
    String? buyerId,
    String? sellerId,
    String? createdById,
    double? offeredPrice,
    String? currency,
    OfferStatus? status,
    DateTime? createdAt,
    DateTime? expiresAt,
    Object? respondedAt = _sentinel,
    Object? respondedById = _sentinel,
    Object? previousOfferId = _sentinel,
    Object? lockedOrderId = _sentinel,
  }) {
    return NegotiationOfferModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      productId: productId ?? this.productId,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      createdById: createdById ?? this.createdById,
      offeredPrice: offeredPrice ?? this.offeredPrice,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      respondedAt: identical(respondedAt, _sentinel)
          ? this.respondedAt
          : respondedAt as DateTime?,
      respondedById: identical(respondedById, _sentinel)
          ? this.respondedById
          : respondedById as String?,
      previousOfferId: identical(previousOfferId, _sentinel)
          ? this.previousOfferId
          : previousOfferId as String?,
      lockedOrderId: identical(lockedOrderId, _sentinel)
          ? this.lockedOrderId
          : lockedOrderId as String?,
    );
  }

  factory NegotiationOfferModel.fromJson(Map<String, dynamic> json) {
    return NegotiationOfferModel(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      productId: json['productId'] as String,
      buyerId: json['buyerId'] as String,
      sellerId: json['sellerId'] as String,
      createdById: json['createdById'] as String,
      offeredPrice: (json['offeredPrice'] as num).toDouble(),
      currency: (json['currency'] as String?) ?? 'GHS',
      status: OfferStatus.values.firstWhere(
        (value) => value.name == json['status'],
        orElse: () => OfferStatus.pending,
      ),
      createdAt: _readDateTime(json['createdAt']) ?? DateTime.now(),
      expiresAt: _readDateTime(json['expiresAt']) ?? DateTime.now(),
      respondedAt: _readDateTime(json['respondedAt']),
      respondedById: json['respondedById'] as String?,
      previousOfferId: json['previousOfferId'] as String?,
      lockedOrderId: json['lockedOrderId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'productId': productId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'createdById': createdById,
      'offeredPrice': offeredPrice,
      'currency': currency,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
      'respondedById': respondedById,
      'previousOfferId': previousOfferId,
      'lockedOrderId': lockedOrderId,
    };
  }
}

class NegotiationMessageModel {
  const NegotiationMessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.type,
    required this.content,
    required this.timestamp,
    this.clientMessageId,
    this.offerId,
    this.deliveryState = MessageDeliveryState.sent,
    List<String>? seenByUserIds,
  }) : seenByUserIds = seenByUserIds ?? const <String>[];

  final String id;
  final String chatId;
  final String senderId;
  final NegotiationMessageType type;
  final String content;
  final DateTime timestamp;
  final String? clientMessageId;
  final String? offerId;
  final MessageDeliveryState deliveryState;
  final List<String> seenByUserIds;

  bool isSeenBy(String userId) => seenByUserIds.contains(userId);

  NegotiationMessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    NegotiationMessageType? type,
    String? content,
    DateTime? timestamp,
    Object? clientMessageId = _sentinel,
    Object? offerId = _sentinel,
    MessageDeliveryState? deliveryState,
    List<String>? seenByUserIds,
  }) {
    return NegotiationMessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      clientMessageId: identical(clientMessageId, _sentinel)
          ? this.clientMessageId
          : clientMessageId as String?,
      offerId: identical(offerId, _sentinel)
          ? this.offerId
          : offerId as String?,
      deliveryState: deliveryState ?? this.deliveryState,
      seenByUserIds: seenByUserIds ?? this.seenByUserIds,
    );
  }

  factory NegotiationMessageModel.fromJson(Map<String, dynamic> json) {
    return NegotiationMessageModel(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      type: NegotiationMessageType.values.firstWhere(
        (value) => value.name == json['type'],
        orElse: () => NegotiationMessageType.text,
      ),
      content: json['content'] as String? ?? '',
      timestamp: _readDateTime(json['timestamp']) ?? DateTime.now(),
      clientMessageId: json['clientMessageId'] as String?,
      offerId: json['offerId'] as String?,
      deliveryState: MessageDeliveryState.values.firstWhere(
        (value) => value.name == json['deliveryState'],
        orElse: () => MessageDeliveryState.sent,
      ),
      seenByUserIds: _readStringList(json['seenByUserIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'type': type.name,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'clientMessageId': clientMessageId,
      'offerId': offerId,
      'deliveryState': deliveryState.name,
      'seenByUserIds': seenByUserIds,
    };
  }
}

class NegotiationThreadSnapshot {
  const NegotiationThreadSnapshot({
    required this.chat,
    required this.product,
    required this.buyer,
    required this.seller,
    required this.messages,
    required this.offers,
    required this.connectionState,
    required this.isRemoteUserOnline,
    List<String>? typingUserIds,
    this.lockedOrder,
  }) : typingUserIds = typingUserIds ?? const <String>[];

  final NegotiationChatModel chat;
  final ProductModel product;
  final UserModel buyer;
  final UserModel seller;
  final List<NegotiationMessageModel> messages;
  final List<NegotiationOfferModel> offers;
  final OrderModel? lockedOrder;
  final List<String> typingUserIds;
  final ChatConnectionState connectionState;
  final bool isRemoteUserOnline;

  NegotiationOfferModel? get activeOffer {
    final activeId = chat.activeOfferId;
    if (activeId == null) {
      return null;
    }

    for (final offer in offers) {
      if (offer.id == activeId) {
        return offer;
      }
    }
    return null;
  }

  NegotiationOfferModel? get latestOffer {
    final latestId = chat.latestOfferId;
    if (latestId != null) {
      for (final offer in offers) {
        if (offer.id == latestId) {
          return offer;
        }
      }
    }

    if (offers.isEmpty) {
      return null;
    }
    return offers.last;
  }

  UserModel participantFor(String userId) {
    return buyer.id == userId ? buyer : seller;
  }

  UserModel otherParticipant(String userId) {
    return buyer.id == userId ? seller : buyer;
  }

  bool isTyping(String userId) => typingUserIds.contains(userId);

  NegotiationThreadSnapshot copyWith({
    NegotiationChatModel? chat,
    ProductModel? product,
    UserModel? buyer,
    UserModel? seller,
    List<NegotiationMessageModel>? messages,
    List<NegotiationOfferModel>? offers,
    Object? lockedOrder = _sentinel,
    List<String>? typingUserIds,
    ChatConnectionState? connectionState,
    bool? isRemoteUserOnline,
  }) {
    return NegotiationThreadSnapshot(
      chat: chat ?? this.chat,
      product: product ?? this.product,
      buyer: buyer ?? this.buyer,
      seller: seller ?? this.seller,
      messages: messages ?? this.messages,
      offers: offers ?? this.offers,
      lockedOrder: identical(lockedOrder, _sentinel)
          ? this.lockedOrder
          : lockedOrder as OrderModel?,
      typingUserIds: typingUserIds ?? this.typingUserIds,
      connectionState: connectionState ?? this.connectionState,
      isRemoteUserOnline: isRemoteUserOnline ?? this.isRemoteUserOnline,
    );
  }
}

class NegotiationChatRouteData {
  const NegotiationChatRouteData({
    required this.product,
    this.currentUser,
    this.seller,
    this.viewerRole,
  });

  final ProductModel product;
  final UserModel? currentUser;
  final UserModel? seller;
  final UserRole? viewerRole;

  factory NegotiationChatRouteData.fromRouteArguments(Object? arguments) {
    if (arguments is NegotiationChatRouteData) {
      return arguments;
    }
    if (arguments is ProductModel) {
      return NegotiationChatRouteData(product: arguments);
    }
    throw ArgumentError('NegotiationChatRouteData requires a product.');
  }
}

const Object _sentinel = Object();

DateTime? _readDateTime(Object? raw) {
  if (raw == null) {
    return null;
  }
  if (raw is DateTime) {
    return raw;
  }
  if (raw is String && raw.isNotEmpty) {
    return DateTime.tryParse(raw);
  }
  if (raw is int) {
    return DateTime.fromMillisecondsSinceEpoch(raw);
  }
  return null;
}

List<String> _readStringList(Object? raw) {
  if (raw is! List<dynamic>) {
    return const <String>[];
  }
  return raw.map((entry) => entry.toString()).toList();
}
