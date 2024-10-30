import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_pokedex/models/trivia_question.dart';
import 'package:pokemon_pokedex/models/user.dart';
import 'package:pokemon_pokedex/models/pokemon.dart';
import 'package:pokemon_pokedex/views/login/LoginDTO.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String apiUrl = "http://192.168.56.1:8080";

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
        'jwt': responseBody['jwt'],
        'firstName': responseBody['firstName'],
        'lastName': responseBody['lastName'],
        'email': responseBody['email'],
        'id': responseBody['id'],
      };
    } else if (response.statusCode == 401) {
      return null; // Credenciales incorrectas
    } else {
      throw Exception('Error en el login: ${response.statusCode}');
    }
  }

  // Método para obtener todos los usuarios
  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$apiUrl/user/all'));
    if (response.statusCode == 200) {
      final List usersJson = json.decode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener usuarios');
    }
  }

  // Crear un nuevo usuario y su equipo Pokémon
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

    if (response.statusCode == 200 || response.statusCode == 201) {
      final userData = json.decode(response.body);
      final userId = userData['id'];

      // Segunda petición para crear el equipo de Pokémon usando el userId
      final teamResponse = await http.post(
        Uri.parse('$apiUrl/teams/create/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (teamResponse.statusCode != 200 && teamResponse.statusCode != 201) {
        throw Exception('Error al crear el equipo Pokémon');
      }
    } else {
      throw Exception('Error al crear el usuario');
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

  // Actualizar un usuario existente
  Future<void> updateUser(int userId, String firstName, String lastName,
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/user/$userId'),
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Error al actualizar el usuario: ${response.statusCode} - ${response.body}');
    }
  }

  // Eliminar un usuario por ID
  Future<void> deleteUser(int userId) async {
    final response = await http.delete(Uri.parse('$apiUrl/user/$userId'));
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el usuario');
    }
  }

  // Obtener el equipo del usuario
  Future<List<Pokemon>> getTeam(int teamId) async {
    final response = await http.get(Uri.parse('$apiUrl/teams/$teamId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List pokemons = data['pokemons'];
      return pokemons.map((json) => Pokemon.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener el equipo');
    }
  }

  // Añadir un Pokémon al equipo
  Future<void> addPokemonToTeam(int pokedexNumber, String name) async {
    // Llamar a _getTeamId con el userId
    final teamId = await _getTeamId();
    if (teamId == null) throw Exception('No se encontró el equipo del usuario');

    final response = await http.post(
      Uri.parse('$apiUrl/teams/$teamId/addPokemon'),
      body: jsonEncode({'pokedexNumber': pokedexNumber, 'name': name}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al añadir Pokémon al equipo');
    }
  }

  // Método auxiliar para obtener el teamId del usuario actual
  Future<int?> _getTeamId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id'); // Recupera el userId almacenado
  }

  Future<List<int>> getTeamPokemonIds(int teamId) async {
    final response = await http.get(Uri.parse('$apiUrl/teams/$teamId'));

    if (response.statusCode == 200) {
      final teamData = jsonDecode(response.body);
      final List<int> pokemonIds = (teamData['pokemons'] as List)
          .map<int>(
              (pokemon) => pokemon['pokedexNumber'] as int) // Especifica `int`
          .toList();

      print(
          "Pokémon IDs obtenidos para el equipo $teamId: $pokemonIds"); // Imprime los IDs

      return pokemonIds;
    } else {
      throw Exception('Error al cargar el equipo');
    }
  }

  // Obtener preguntas de trivia
  Future<List<TriviaQuestion>> fetchTriviaQuestions() async {
    final response = await http.get(Uri.parse('$apiUrl/trivia/questions'));

    if (response.statusCode == 200) {
      final List questionsJson = json.decode(utf8.decode(response.bodyBytes));
      return questionsJson
          .map((json) => TriviaQuestion.fromJson(json))
          .toList();
    } else {
      throw Exception('Error al cargar preguntas de trivia');
    }
  }
}
