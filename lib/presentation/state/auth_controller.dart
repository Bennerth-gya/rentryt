import 'package:comfi/data/models/user_model.dart';
import 'package:comfi/data/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    return _guard(() async {
      _currentUser = await _authRepository.loginUser(
        email: email,
        password: password,
      );
      return null;
    });
  }

  Future<String?> signupUser({
    required String name,
    required String email,
    required String password,
  }) async {
    return _guard(() async {
      _currentUser = await _authRepository.signupUser(
        name: name,
        email: email,
        password: password,
      );
      return null;
    });
  }

  Future<String?> recoverPassword({
    required String email,
  }) async {
    return _guard(() async {
      await _authRepository.recoverPassword(email);
      return null;
    });
  }

  Future<void> logoutUser() async {
    _isLoading = true;
    notifyListeners();

    await _authRepository.logoutUser();
    _currentUser = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> _guard(Future<String?> Function() operation) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      return await operation();
    } catch (error) {
      _errorMessage = error.toString();
      return _errorMessage;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
