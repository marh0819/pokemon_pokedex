import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_pokedex/models/pokemon.dart';

class PokemonService {
  final String _baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> getPokemons(
      {required int page, required int limit}) async {
    final offset = (page - 1) * limit;

    // Calcula el offset relativo a la tercera generación
    final thirdGenStart =
        251; // 252 es el primer Pokémon de la tercera generación
    final url =
        '$_baseUrl/pokemon?offset=${thirdGenStart + offset}&limit=$limit';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      // Cargar detalles adicionales de cada Pokémon (imagen, tipos, etc.)
      List<Pokemon> pokemons = [];
      for (var result in results) {
        final pokemonDetailResponse = await http.get(Uri.parse(result['url']));
        if (pokemonDetailResponse.statusCode == 200) {
          final detailData = jsonDecode(pokemonDetailResponse.body);
          final pokemon = Pokemon.fromJson(detailData);

          // Filtrar solo los Pokémon dentro del rango de la tercera generación (252-386)
          if (pokemon.pokedexNumber >= 252 && pokemon.pokedexNumber <= 386) {
            pokemons.add(pokemon);
          }
        }
      }
      return pokemons;
    } else {
      throw Exception('Error al cargar los Pokémon');
    }
  }
}
