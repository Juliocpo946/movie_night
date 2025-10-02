class AuthUser{
  final int? id;
  final String name;
  final String email;

  const AuthUser({
    this.id,
    required this.name,
    required this.email,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AuthUser &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              email == other.email;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ email.hashCode;

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email}';
  }
}