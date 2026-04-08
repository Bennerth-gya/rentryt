import 'package:comfi/data/services/seller_service.dart';

class SellerRepository {
  SellerRepository(this._service);

  final SellerService _service;

  Future<SellerApplicationDraft> submitApplication({
    required String shopName,
    required String phoneNumber,
    required String location,
    required String description,
  }) {
    return _service.submitApplication(
      shopName: shopName,
      phoneNumber: phoneNumber,
      location: location,
      description: description,
    );
  }

  Future<void> sendOtp(String phoneNumber) => _service.sendOtp(phoneNumber);

  Future<bool> verifyOtp({
    required String phoneNumber,
    required String code,
  }) {
    return _service.verifyOtp(phoneNumber: phoneNumber, code: code);
  }

  Future<void> submitVerification(SellerVerificationPayload payload) {
    return _service.submitVerification(payload);
  }
}
