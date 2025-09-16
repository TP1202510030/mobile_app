import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/domain/repositories/auth_repository.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/utils/result.dart';

class FakeAuthRepository extends ChangeNotifier implements AuthRepository {
  bool _isAuthenticated = false;
  bool _isInitialized = true;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  bool get isInitialized => _isInitialized;

  @override
  int? get companyId => _isAuthenticated ? 1 : null;

  @override
  Future<void> initialize() async {
    _isInitialized = true;
    notifyListeners();
  }

  @override
  Future<String?> getToken() async => _isAuthenticated ? 'fake_token' : null;

  @override
  Future<Result<void>> signIn(
      {required String username, required String password}) async {
    _isAuthenticated = true;
    notifyListeners();
    return const Result.success(null);
  }

  @override
  Future<Result<void>> signOut() async {
    _isAuthenticated = false;
    notifyListeners();
    return const Result.success(null);
  }
}

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    final fakeAuthRepository = FakeAuthRepository();

    final testRouter = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Test Home')),
          ),
        ),
      ],
    );

    await tester.pumpWidget(MyApp(
      authRepository: fakeAuthRepository,
      routerConfig: testRouter,
    ));

    expect(find.text('Test Home'), findsOneWidget);
  });
}
