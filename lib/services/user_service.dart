import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pokemon_pokedex/models/user.dart'; // Asegúrate de importar correctamente el archivo user.dart

class UserService {
  final String apiUrl = "http://192.168.18.26:8080";

  // Obtener la lista de usuarios
  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$apiUrl/user/all'));
    if (response.statusCode == 200) {
      final List usersJson = json.decode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener usuarios');
    }
  }

  // Crear un nuevo usuario
  Future<void> createUser(
      String firstName, String lastName, String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/user/save'),
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear el usuario');
    }
  }

  // Actualizar un usuario existente
  Future<void> updateUser(int userId, String firstName, String lastName,
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/user/$userId'),
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password':
            password, // Asegúrate de incluir la contraseña si la API lo requiere
      }),
      headers: {'Content-Type': 'application/json'},
    );

    // Manejo de errores
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Error al actualizar el usuario: ${response.statusCode} - ${response.body}');
    }
  }

  // Obtener un usuario por su ID
  Future<User> getUserById(int userId) async {
    final response = await http.get(Uri.parse('$apiUrl/user/$userId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Error al obtener el usuario');
    }
  }

  // Eliminar un usuario por ID
  Future<void> deleteUser(int userId) async {
    final response = await http.delete(Uri.parse('$apiUrl/user/$userId'));
    if (response.statusCode != 204) {
      //throw Exception('Error al eliminar el usuario');
      throw Exception('url: $apiUrl/user/$userId');
    }
  }
}
