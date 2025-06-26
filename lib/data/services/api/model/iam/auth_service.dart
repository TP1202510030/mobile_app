import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/domain/models/iam/authenticated_user.dart';

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  Future<AuthenticatedUser> signIn(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/authentication/sign-in'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return AuthenticatedUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign in. Status: ${response.statusCode}');
    }
  }
}
