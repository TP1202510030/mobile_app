/// Represents an authenticated user in the system.
/// Contains user details such as ID, username, authentication token, and company ID.
class AuthenticatedUser {
  final int id;
  final String username;
  final String token;
  final int companyId;

  AuthenticatedUser({
    required this.id,
    required this.username,
    required this.token,
    required this.companyId,
  });

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) {
    final companyId = json['companyId'];
    if (companyId == null) {
      throw FormatException(
        "companyId is missing in the JSON data",
        json,
      );
    }

    return AuthenticatedUser(
      id: json['id'] as int,
      username: json['username'] as String,
      token: json['token'] as String,
      companyId: companyId as int,
    );
  }
}
