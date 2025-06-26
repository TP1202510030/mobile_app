class AuthenticatedUser {
  final int id;
  final String username;
  final String token;

  AuthenticatedUser({
    required this.id,
    required this.username,
    required this.token,
  });

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUser(
      id: json['id'],
      username: json['username'],
      token: json['token'],
    );
  }
}
