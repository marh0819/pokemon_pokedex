import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_pokedex/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserService _userService = UserService();
  final _emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  Future<void> _saveFirstName(String firstName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstName); // Guardar el nombre
  }

  Future<void> _saveLastName(String lastName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastName', lastName);
  }

  Future<void> _saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  Future<void> _saveId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', id);
  }

  // Función para realizar el login
  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (!RegExp(_emailPattern).hasMatch(email)) {
      _showSnackBar('Formato de correo incorrecto');
      return;
    }

    try {
      // Intentar hacer login con el servicio
      Map<String, String>? loginResponse =
          await _userService.login(email, password);

      if (loginResponse != null) {
        await _saveFirstName(
            loginResponse['firstName']!); // Guardar nombre en SharedPreferences
        await _saveLastName(
            loginResponse['lastName']!); //Guardar apellido en SharedPreferences
        await _saveEmail(
            loginResponse['email']!); //Guardar apellido en SharedPreferences
        await _saveId(
            int.parse(loginResponse['id']!)); //Guardar apellido en SharedPreferences
        
        context.go('/pokemon');
      } else {
        _showSnackBar('Correo o Password incorrecta');
      }
    } catch (e) {
      _showSnackBar('Error al iniciar sesión: $e');
    }
  }

  // Función para mostrar SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
