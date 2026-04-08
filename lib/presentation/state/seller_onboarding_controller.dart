import 'package:comfi/data/repositories/seller_repository.dart';
import 'package:comfi/data/services/seller_service.dart';
import 'package:flutter/foundation.dart';

class SellerOnboardingController extends ChangeNotifier {
  SellerOnboardingController({
    required SellerRepository sellerRepository,
  }) : _sellerRepository = sellerRepository;

  final SellerRepository _sellerRepository;

  bool isSubmittingApplication = false;
  bool isSendingOtp = false;
  bool isVerifyingOtp = false;
  bool isSubmittingVerification = false;
  String? lastSubmittedPhoneNumber;
  String? errorMessage;

  Future<String?> submitApplication({
    required String shopName,
    required String phoneNumber,
    required String location,
    required String description,
  }) async {
    return _run(
      updateLoading: (value) => isSubmittingApplication = value,
      operation: () async {
        final draft = await _sellerRepository.submitApplication(
          shopName: shopName,
          phoneNumber: phoneNumber,
          location: location,
          description: description,
        );
        lastSubmittedPhoneNumber = draft.phoneNumber;
        return null;
      },
    );
  }

  Future<String?> sendOtp(String phoneNumber) {
    return _run(
      updateLoading: (value) => isSendingOtp = value,
      operation: () async {
        await _sellerRepository.sendOtp(phoneNumber);
        lastSubmittedPhoneNumber = phoneNumber;
        return null;
      },
    );
  }

  Future<String?> verifyOtp({
    required String phoneNumber,
    required String code,
  }) {
    return _run(
      updateLoading: (value) => isVerifyingOtp = value,
      operation: () async {
        final isValid = await _sellerRepository.verifyOtp(
          phoneNumber: phoneNumber,
          code: code,
        );
        if (!isValid) {
          return 'The verification code is invalid.';
        }
        return null;
      },
    );
  }

  Future<String?> submitVerification({
    required String phoneNumber,
    required String idNumber,
    required String idExpiry,
    required int selectedTier,
  }) {
    return _run(
      updateLoading: (value) => isSubmittingVerification = value,
      operation: () async {
        await _sellerRepository.submitVerification(
          SellerVerificationPayload(
            phoneNumber: phoneNumber,
            idNumber: idNumber,
            idExpiry: idExpiry,
            selectedTier: selectedTier,
          ),
        );
        return null;
      },
    );
  }

  Future<String?> _run({
    required void Function(bool value) updateLoading,
    required Future<String?> Function() operation,
  }) async {
    updateLoading(true);
    errorMessage = null;
    notifyListeners();

    try {
      final message = await operation();
      errorMessage = message;
      return message;
    } catch (error) {
      errorMessage = error.toString();
      return errorMessage;
    } finally {
      updateLoading(false);
      notifyListeners();
    }
  }
}
