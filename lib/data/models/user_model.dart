class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.role = UserRole.buyer,
  });

  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final UserRole role;

  bool get isSeller => role == UserRole.seller;

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    UserRole? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      role: UserRole.values.firstWhere(
        (value) => value.name == json['role'],
        orElse: () => UserRole.buyer,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role.name,
    };
  }
}

enum UserRole {
  buyer,
  seller,
}
