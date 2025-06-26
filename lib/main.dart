import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app/data/repositories/auth_repository.dart';
import 'package:mobile_app/data/services/api/model/iam/auth_service.dart';
import 'package:mobile_app/ui/core/themes/theme.dart';
import 'package:provider/provider.dart';
import 'routing/router.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);

  // Cargar las variables de entorno
  await dotenv.load(fileName: ".env");

  // Crear instancias de los servicios y repositorios
  final apiBaseUrl = dotenv.env['BASE_URL'];
  if (apiBaseUrl == null) {
    throw Exception("BASE_URL no fue encontrada en el archivo .env");
  }

  final authService = AuthService(baseUrl: apiBaseUrl);
  final authRepository = AuthRepository(authService);

  // Correr la app proveyendo el repositorio
  runApp(
    ChangeNotifierProvider.value(
      value: authRepository,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);

    return MaterialApp.router(
      title: 'Greenhouse',
      routerConfig: router(authRepository),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
