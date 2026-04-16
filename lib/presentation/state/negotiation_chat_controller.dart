import 'dart:async';

import 'package:comfi/data/models/negotiation_models.dart';
import 'package:comfi/data/models/product_model.dart';
import 'package:comfi/data/models/user_model.dart';
import 'package:comfi/data/repositories/negotiation_repository.dart';
import 'package:flutter/material.dart';

class NegotiationChatController extends ChangeNotifier {
  NegotiationChatController({
    required NegotiationRepository negotiationRepository,
    required ProductModel product,
    required UserModel currentUser,
    required UserModel buyer,
    required UserModel seller,
  }) : _negotiationRepository = negotiationRepository,
       _product = product,
       _currentUser = currentUser,
       _buyer = buyer,
       _seller = seller;

  final NegotiationRepository _negotiationRepository;
  final ProductModel _product;
  final UserModel _currentUser;
  final UserModel _buyer;
  final UserModel _seller;

  final TextEditingController messageController = TextEditingController();

  StreamSubscription<NegotiationThreadSnapshot>? _subscription;
  Timer? _typingDebounce;

  NegotiationThreadSnapshot? _thread;
  bool _isInitializing = false;
  bool _isSendingMessage = false;
  bool _isSendingOffer = false;
  String? _errorMessage;
  int _visibleMessageCount = 18;

  ProductModel get product => _product;
  UserModel get currentUser => _currentUser;
  UserModel get buyer => _buyer;
  UserModel get seller => _seller;
  UserModel get otherParticipant => isBuyerView ? _seller : _buyer;
  NegotiationThreadSnapshot? get thread => _thread;
  bool get isInitializing => _isInitializing;
  bool get isSendingMessage => _isSendingMessage;
  bool get isSendingOffer => _isSendingOffer;
  String? get errorMessage => _errorMessage;
  bool get hasThread => _thread != null;
  bool get isBuyerView => _currentUser.id == _buyer.id;
  bool get isSellerView => _currentUser.id == _seller.id;
  bool get isConnected =>
      _thread?.connectionState == ChatConnectionState.connected;

  List<NegotiationMessageModel> get visibleMessages {
    final messages = _thread?.messages ?? const <NegotiationMessageModel>[];
    if (messages.length <= _visibleMessageCount) {
      return messages;
    }
    return messages.sublist(messages.length - _visibleMessageCount);
  }

  bool get hasMoreMessages {
    final totalMessages = _thread?.messages.length ?? 0;
    return totalMessages > visibleMessages.length;
  }

  NegotiationOfferModel? get activeOffer => _thread?.activeOffer;
  NegotiationOfferModel? get latestOffer => _thread?.latestOffer;
  bool get hasLockedPrice => _thread?.chat.hasLockedPrice ?? false;
  String? get lockedOrderId => _thread?.chat.lockedOrderId;
  double? get lockedPrice => _thread?.chat.lockedPrice;

  bool get showTypingIndicator {
    final remoteUserId = otherParticipant.id;
    return _thread?.isTyping(remoteUserId) ?? false;
  }

  String get offerButtonLabel {
    if (isSellerView && canCounterCurrentOffer) {
      return 'Counter';
    }
    return 'Make Offer';
  }

  bool get canCounterCurrentOffer {
    final offer = activeOffer;
    return isSellerView &&
        offer != null &&
        offer.isPending &&
        offer.createdById == buyer.id &&
        offer.createdById != currentUser.id;
  }

  bool get canLaunchOfferComposer {
    if (_thread == null || hasLockedPrice) {
      return false;
    }
    if (isBuyerView) {
      return activeOffer == null;
    }
    return canCounterCurrentOffer;
  }

  bool get canSendText {
    return !_isInitializing && !_isSendingMessage;
  }

  Future<void> initialize() async {
    if (_isInitializing || _thread != null) {
      return;
    }

    _isInitializing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _negotiationRepository.createOrGetThread(
        product: _product,
        buyer: _buyer,
        seller: _seller,
      );
      _thread = snapshot;
      _subscription = _negotiationRepository
          .watchThread(snapshot.chat.id)
          .listen(
            (updatedSnapshot) {
              _thread = updatedSnapshot;
              notifyListeners();
              unawaited(markSeen());
            },
            onError: (Object error) {
              _errorMessage = error.toString();
              notifyListeners();
            },
          );
      unawaited(markSeen());
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<void> loadOlderMessages() async {
    if (!hasMoreMessages) {
      return;
    }
    _visibleMessageCount += 12;
    notifyListeners();
  }

  NegotiationOfferModel? offerForMessage(NegotiationMessageModel message) {
    final offerId = message.offerId;
    if (offerId == null) {
      return null;
    }
    final offers = _thread?.offers ?? const <NegotiationOfferModel>[];
    for (final offer in offers) {
      if (offer.id == offerId) {
        return offer;
      }
    }
    return null;
  }

  bool canRespondToOffer(NegotiationOfferModel offer) {
    return offer.isPending && offer.createdById != currentUser.id;
  }

  bool canCounterOffer(NegotiationOfferModel offer) {
    return isSellerView &&
        offer.isPending &&
        offer.createdById == buyer.id &&
        offer.createdById != currentUser.id;
  }

  bool isLatestOffer(String offerId) => latestOffer?.id == offerId;

  Future<String?> sendTextMessage() async {
    final chatId = _thread?.chat.id;
    if (chatId == null) {
      return 'Chat is still loading.';
    }

    final content = messageController.text.trim();
    if (content.isEmpty) {
      return null;
    }

    _isSendingMessage = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _negotiationRepository.sendTextMessage(
        chatId: chatId,
        senderId: currentUser.id,
        content: content,
        clientMessageId: _clientMessageId('text'),
      );
      messageController.clear();
      await _setTyping(false);
      return null;
    } catch (error) {
      _errorMessage = error.toString();
      return _errorMessage;
    } finally {
      _isSendingMessage = false;
      notifyListeners();
    }
  }

  Future<String?> submitOffer(double offeredPrice) async {
    final chatId = _thread?.chat.id;
    if (chatId == null) {
      return 'Chat is still loading.';
    }

    _isSendingOffer = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (isBuyerView) {
        await _negotiationRepository.sendOffer(
          chatId: chatId,
          buyerId: currentUser.id,
          offeredPrice: offeredPrice,
          clientMessageId: _clientMessageId('offer'),
        );
      } else if (canCounterCurrentOffer) {
        final pendingOffer = activeOffer;
        if (pendingOffer == null) {
          throw StateError('There is no active offer to counter right now.');
        }
        await _negotiationRepository.respondToOffer(
          chatId: chatId,
          offerId: pendingOffer.id,
          actorId: currentUser.id,
          action: OfferAction.counter,
          counterPrice: offeredPrice,
          clientMessageId: _clientMessageId('counter'),
        );
      } else {
        throw StateError('You cannot create a new offer at this stage.');
      }
      await _setTyping(false);
      return null;
    } catch (error) {
      _errorMessage = error.toString();
      return _errorMessage;
    } finally {
      _isSendingOffer = false;
      notifyListeners();
    }
  }

  Future<String?> acceptOffer(NegotiationOfferModel offer) async {
    return _respondToOffer(offer, OfferAction.accept);
  }

  Future<String?> rejectOffer(NegotiationOfferModel offer) async {
    return _respondToOffer(offer, OfferAction.reject);
  }

  Future<void> onComposerChanged(String value) async {
    if (_thread == null) {
      return;
    }
    final hasContent = value.trim().isNotEmpty;
    await _setTyping(hasContent);
    _typingDebounce?.cancel();
    if (hasContent) {
      _typingDebounce = Timer(const Duration(milliseconds: 1200), () {
        unawaited(_setTyping(false));
      });
    }
  }

  Future<void> markSeen() async {
    final chatId = _thread?.chat.id;
    if (chatId == null) {
      return;
    }

    try {
      await _negotiationRepository.markSeen(
        chatId: chatId,
        userId: currentUser.id,
      );
    } catch (_) {
      // Seen updates should never block the user.
    }
  }

  Future<String?> _respondToOffer(
    NegotiationOfferModel offer,
    OfferAction action,
  ) async {
    final chatId = _thread?.chat.id;
    if (chatId == null) {
      return 'Chat is still loading.';
    }

    _isSendingOffer = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _negotiationRepository.respondToOffer(
        chatId: chatId,
        offerId: offer.id,
        actorId: currentUser.id,
        action: action,
        clientMessageId: _clientMessageId(action.name),
      );
      return null;
    } catch (error) {
      _errorMessage = error.toString();
      return _errorMessage;
    } finally {
      _isSendingOffer = false;
      notifyListeners();
    }
  }

  Future<void> _setTyping(bool isTyping) async {
    final chatId = _thread?.chat.id;
    if (chatId == null) {
      return;
    }
    try {
      await _negotiationRepository.setTyping(
        chatId: chatId,
        userId: currentUser.id,
        isTyping: isTyping,
      );
    } catch (_) {
      // Typing state is best-effort only.
    }
  }

  String _clientMessageId(String prefix) {
    return '$prefix-${currentUser.id}-${DateTime.now().microsecondsSinceEpoch}';
  }

  @override
  void dispose() {
    _typingDebounce?.cancel();
    _subscription?.cancel();
    messageController.dispose();
    super.dispose();
  }
}
