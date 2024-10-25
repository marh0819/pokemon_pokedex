import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_pokedex/models/pokemon.dart';

class PokemonService {
  final String _baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> getPokemons(
      {required int page, required int limit}) async {
    final offset = (page - 1) * limit;
    final thirdGenStart = 251;
    final url = '$_baseUrl/pokemon?offset=${thirdGenStart + offset}&limit=$limit';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      List<Pokemon> pokemons = [];
      for (var result in results) {
        final pokemonDetailResponse = await http.get(Uri.parse(result['url']));
        if (pokemonDetailResponse.statusCode == 200) {
          final detailData = jsonDecode(pokemonDetailResponse.body);
          final pokemon = await Pokemon.fromJsonWithDetails(detailData); // Usa el nuevo método

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

  Future<Map<String, List<String>>> getDamageRelations(List<String> types) async {
    final damageRelations = {
      'double_damage_from': <String>[],
      'half_damage_from': <String>[],
      'no_damage_from': <String>[],
    };

    for (String type in types) {
      final response = await http.get(Uri.parse('$_baseUrl/type/$type'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        for (String relation in damageRelations.keys) {
          damageRelations[relation]!.addAll(
            (data['damage_relations'][relation] as List)
                .map((entry) => entry['name'] as String),
          );
        }
      } else {
        throw Exception('Error al cargar las relaciones de daño para el tipo $type');
      }
    }

    return damageRelations;
  }

  Future<String> getAbilityDescription(String abilityUrl) async {
    final response = await http.get(Uri.parse(abilityUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['effect_entries']
          .firstWhere((entry) => entry['language']['name'] == 'en')['effect'];
    } else {
      throw Exception('Error al cargar la descripción de la habilidad');
    }
  }
}
