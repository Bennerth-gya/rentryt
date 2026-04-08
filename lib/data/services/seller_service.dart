import 'package:comfi/core/network/app_exception.dart';

class SellerApplicationDraft {
  const SellerApplicationDraft({
    required this.shopName,
    required this.phoneNumber,
    required this.location,
    required this.description,
  });

  final String shopName;
  final String phoneNumber;
  final String location;
  final String description;
}

class SellerVerificationPayload {
  const SellerVerificationPayload({
    required this.phoneNumber,
    required this.idNumber,
    required this.idExpiry,
    required this.selectedTier,
  });

  final String phoneNumber;
  final String idNumber;
  final String idExpiry;
  final int selectedTier;
}

abstract class SellerService {
  Future<SellerApplicationDraft> submitApplication({
    required String shopName,
    required String phoneNumber,
    required String location,
    required String description,
  });

  Future<void> sendOtp(String phoneNumber);
  Future<bool> verifyOtp({
    required String phoneNumber,
    required String code,
  });

  Future<void> submitVerification(SellerVerificationPayload payload);
}

class InMemorySellerService implements SellerService {
  final Map<String, String> _otpCodes = <String, String>{};

  @override
  Future<SellerApplicationDraft> submitApplication({
    required String shopName,
    required String phoneNumber,
    required String location,
    required String description,
  }) async {
    if (shopName.trim().isEmpty) {
      throw const ValidationException('Shop name is required');
    }
    if (phoneNumber.trim().isEmpty) {
      throw const ValidationException('Phone number is required');
    }

    return SellerApplicationDraft(
      shopName: shopName,
      phoneNumber: phoneNumber,
      location: location,
      description: description,
    );
  }

  @override
  Future<void> sendOtp(String phoneNumber) async {
    if (phoneNumber.trim().isEmpty) {
      throw const ValidationException('Phone number is required');
    }
    _otpCodes[phoneNumber] = '123456';
  }

  @override
  Future<bool> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    final expectedCode = _otpCodes[phoneNumber];
    return expectedCode != null && expectedCode == code;
  }

  @override
  Future<void> submitVerification(SellerVerificationPayload payload) async {
    if (payload.idNumber.trim().isEmpty) {
      throw const ValidationException('ID number is required');
    }
  }
}
