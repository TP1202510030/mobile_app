enum ClientType { web, mobile }

extension ClientTypeExtension on ClientType {
  String get value {
    switch (this) {
      case ClientType.web:
        return 'WEB';
      case ClientType.mobile:
        return 'MOBILE';
    }
  }
}

class SignInRequest {
  final String username;
  final String password;
  final ClientType clientType;

  SignInRequest({
    required this.username,
    required this.password,
    this.clientType = ClientType.mobile,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'clientType': clientType.value,
      };
}
