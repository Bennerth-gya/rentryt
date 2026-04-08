import 'package:comfi/data/models/user_model.dart';
import 'package:comfi/data/services/in_memory_seed_data.dart';

abstract class AuthService {
  Future<UserModel> loginUser({
    required String email,
    required String password,
  });

  Future<UserModel> signupUser({
    required String name,
    required String email,
    required String password,
  });

  Future<void> recoverPassword(String email);
  Future<void> logoutUser();
}

class InMemoryAuthService implements AuthService {
  UserModel? _currentUser;

  @override
  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().isEmpty ? 'guest@comfi.app' : email.trim();
    final name = normalizedEmail.split('@').first;

    _currentUser = InMemorySeedData.demoBuyer().copyWith(
      email: normalizedEmail,
      name: _formatDisplayName(name),
    );

    return _currentUser!;
  }

  @override
  Future<UserModel> signupUser({
    required String name,
    required String email,
    required String password,
  }) async {
    _currentUser = UserModel(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim().isEmpty ? 'Comfi User' : name.trim(),
      email: email.trim(),
      role: UserRole.buyer,
    );
    return _currentUser!;
  }

  @override
  Future<void> recoverPassword(String email) async {}

  @override
  Future<void> logoutUser() async {
    _currentUser = null;
  }

  String _formatDisplayName(String raw) {
    if (raw.isEmpty) {
      return 'Comfi User';
    }

    final normalized = raw.replaceAll(RegExp(r'[^a-zA-Z0-9]+'), ' ').trim();
    if (normalized.isEmpty) {
      return 'Comfi User';
    }

    return normalized
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}')
        .join(' ');
  }
}
