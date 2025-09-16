import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_app/core/locator.dart';
import 'package:mobile_app/domain/repositories/auth_repository.dart';
import 'package:mobile_app/routing/router.dart';
import 'package:mobile_app/ui/core/themes/theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('es_ES', null);
  await dotenv.load(fileName: ".env");

  await setupLocator();
  final authRepository = locator<AuthRepository>();
  await authRepository.initialize();

  final appRouter = AppRouter(authRepository: authRepository);

  runApp(MyApp(
    routerConfig: appRouter.router,
    authRepository: authRepository,
  ));
}

class MyApp extends StatelessWidget {
  final RouterConfig<Object> routerConfig;
  final AuthRepository authRepository;
  const MyApp({
    super.key,
    required this.routerConfig,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthRepository>.value(
      value: authRepository,
      child: MaterialApp.router(
        title: 'Greenhouse',
        routerConfig: routerConfig,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
