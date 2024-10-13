import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pokemon_pokedex/config/router/app_router.dart';
import 'package:pokemon_pokedex/config/router/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Carga las variables de entorno
  const String apiUrl = "http://192.168.18.26:8080"; // Cambia esta URL a la que necesites
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CRUD de Categorías',
      theme: AppTheme.lightTheme, // Aplicamos el tema claro
      darkTheme: AppTheme.darkTheme, // Aplicamos el tema oscuro (opcional)
      themeMode: ThemeMode.system, // El tema se adapta al modo del sistema
      routerConfig: router,
    );
  }
}
