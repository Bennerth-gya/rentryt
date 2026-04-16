import 'package:comfi/data/models/negotiation_models.dart';
import 'package:comfi/data/models/order_model.dart';
import 'package:comfi/data/models/product_model.dart';
import 'package:comfi/data/models/user_model.dart';
import 'package:comfi/data/services/negotiation_service.dart';

class NegotiationRepository {
  NegotiationRepository(this._service);

  final NegotiationService _service;

  Future<NegotiationThreadSnapshot> createOrGetThread({
    required ProductModel product,
    required UserModel buyer,
    required UserModel seller,
    String currency = 'GHS',
  }) {
    return _service.createOrGetThread(
      product: product,
      buyer: buyer,
      seller: seller,
      currency: currency,
    );
  }

  Stream<NegotiationThreadSnapshot> watchThread(String chatId) =>
      _service.watchThread(chatId);

  Future<void> sendTextMessage({
    required String chatId,
    required String senderId,
    required String content,
    required String clientMessageId,
  }) {
    return _service.sendTextMessage(
      chatId: chatId,
      senderId: senderId,
      content: content,
      clientMessageId: clientMessageId,
    );
  }

  Future<void> sendOffer({
    required String chatId,
    required String buyerId,
    required double offeredPrice,
    required String clientMessageId,
  }) {
    return _service.sendOffer(
      chatId: chatId,
      buyerId: buyerId,
      offeredPrice: offeredPrice,
      clientMessageId: clientMessageId,
    );
  }

  Future<void> respondToOffer({
    required String chatId,
    required String offerId,
    required String actorId,
    required OfferAction action,
    required String clientMessageId,
    double? counterPrice,
  }) {
    return _service.respondToOffer(
      chatId: chatId,
      offerId: offerId,
      actorId: actorId,
      action: action,
      clientMessageId: clientMessageId,
      counterPrice: counterPrice,
    );
  }

  Future<void> setTyping({
    required String chatId,
    required String userId,
    required bool isTyping,
  }) {
    return _service.setTyping(
      chatId: chatId,
      userId: userId,
      isTyping: isTyping,
    );
  }

  Future<void> markSeen({required String chatId, required String userId}) {
    return _service.markSeen(chatId: chatId, userId: userId);
  }

  Future<OrderModel?> getLockedOrder(String chatId) =>
      _service.getLockedOrder(chatId);
}
