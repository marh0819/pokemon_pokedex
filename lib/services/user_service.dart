import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_pokedex/models/user.dart';
import 'package:pokemon_pokedex/views/login/LoginDTO.dart'; // Asegúrate de importar correctamente el archivo user.dart

class UserService {
  final String apiUrl = "http://192.168.56.1:8080";

  // Método para realizar el login
  // Método para realizar el login
  Future<Map<String, String>?> login(String email, String password) async {
    final loginDTO = LoginDTO(email: email, password: password);

    final response = await http.post(
      Uri.parse('$apiUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginDTO.toJson()),
    );

    if (response.statusCode == 202) {
      // La respuesta incluye el JWT y el nombre del usuario
      final Map<String, dynamic> responseBody = json.decode(response.body);
      return {
        'jwt': responseBody['jwt'], // Devuelve el token JWT si es exitoso
        'firstName':
            responseBody['firstName'], // Devuelve el firstName del usuario
        'lastName':
            responseBody['lastName'], // Devuelve el lastName del usuario
        'email':
            responseBody['email'], // Devuelve el email del usuario
        'id':
            responseBody['id'], // Devuelve el id del usuario
      };
    } else if (response.statusCode == 401) {
      return null; // Si las credenciales son incorrectas
    } else {
      throw Exception('Error en el login: ${response.statusCode}');
    }
  }

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
      Uri.parse('$apiUrl/auth/register'),
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
