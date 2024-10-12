// lib/config/theme.dart

import 'package:flutter/material.dart';

// Definimos una clase para manejar los temas de la aplicación
class AppTheme {
  // Tema claro personalizado
  static final ThemeData lightTheme = ThemeData(
    // Color primario de la aplicación
    primarySwatch: Colors.orange,
    // Brillo del tema (claro)
    brightness: Brightness.light,
    // Estilo de la AppBar
    appBarTheme: const AppBarTheme(
      color: Colors.cyan, // Color de fondo de la AppBar
      elevation: 8, // Eliminamos la sombra de la AppBar
      titleTextStyle: TextStyle(
        color: Colors.white, // Color del texto del título
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    // Estilo de los botones elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Color de fondo del botón
        foregroundColor: Colors.white, // Color del texto del botón
      ),
    ),
    // Estilo de los campos de texto
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(), // Borde de los campos de texto
      filled: true,
      fillColor: Colors.white70, // Color de fondo de los campos de texto
    ),
    // Configuracion del FloatingActionButton
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor:
          Color.fromARGB(255, 243, 110, 33), // Color de fondo del botón
      foregroundColor: Colors.white, // Color del icono y texto
      elevation: 4, // Elevación del botón
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(16.0)), // Esquinas redondeadas
      ),
    ),
    // Estilos de texto actualizados
    textTheme: const TextTheme(
      // Reemplazamos headline6 por titleLarge
      titleLarge: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      // bodyText2 es ahora bodyMedium en las versiones más recientes
      bodyMedium: TextStyle(
        fontSize: 16.0,
        color: Colors.black87,
      ),
    ),
  );

  // Tema oscuro personalizado
  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      color: Colors.black87,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.black54,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.0,
        color: Colors.white70,
      ),
    ),
  );
}
