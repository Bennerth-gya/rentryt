import 'package:comfi/data/models/user_model.dart';
import 'package:comfi/data/services/auth_service.dart';

class AuthRepository {
  AuthRepository(this._service);

  final AuthService _service;

  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) {
    return _service.loginUser(email: email, password: password);
  }

  Future<UserModel> signupUser({
    required String name,
    required String email,
    required String password,
  }) {
    return _service.signupUser(name: name, email: email, password: password);
  }

  Future<void> recoverPassword(String email) => _service.recoverPassword(email);

  Future<void> logoutUser() => _service.logoutUser();
}
