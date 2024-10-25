import 'package:pokemon_pokedex/services/pokemon_service.dart';
import 'dart:convert'; // Import para jsonDecode
import 'package:http/http.dart' as http; // Import para http

class Pokemon {
  final int pokedexNumber;
  final String name;
  final String imageUrl;
  final List<String> types;
  final Map<String, String> abilities; // Habilidad y descripción
  final String description;
  final List<String> weaknesses;
  final List<String> resistances;

  Pokemon({
    required this.pokedexNumber,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.abilities,
    required this.description,
    required this.weaknesses,
    required this.resistances,
  });

  static Future<Pokemon> fromJsonWithDetails(Map<String, dynamic> json) async {
    final List<String> types = (json['types'] as List)
        .map((type) => type['type']['name'] as String)
        .toList();

    final description = await _fetchPokedexDescription(json['species']['url']);
    final damageRelations = await PokemonService().getDamageRelations(types);

    final weaknesses = _calculateWeaknesses(damageRelations);
    final resistances = _calculateResistances(damageRelations);

    final Map<String, String> abilities = {};
    for (var abilityInfo in json['abilities']) {
      final abilityName = abilityInfo['ability']['name'];
      final abilityUrl = abilityInfo['ability']['url'];
      abilities[abilityName] =
          await PokemonService().getAbilityDescription(abilityUrl);
    }

    return Pokemon(
      pokedexNumber: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['front_default'],
      types: types,
      abilities: abilities,
      description: description,
      weaknesses: weaknesses,
      resistances: resistances,
    );
  }

  static List<String> _calculateWeaknesses(
      Map<String, List<String>> damageRelations) {
    final List<String> weaknesses = [];
    for (var type in damageRelations['double_damage_from']!) {
      if (!damageRelations['half_damage_from']!.contains(type) &&
          !damageRelations['no_damage_from']!.contains(type)) {
        weaknesses.add(type);
      }
    }
    return weaknesses.toSet().toList(); // Remueve duplicados
  }

  static List<String> _calculateResistances(
      Map<String, List<String>> damageRelations) {
    final List<String> resistances = [];
    for (var type in damageRelations['half_damage_from']!) {
      if (!damageRelations['double_damage_from']!.contains(type) &&
          !damageRelations['no_damage_from']!.contains(type)) {
        resistances.add(type);
      }
    }
    for (var type in damageRelations['no_damage_from']!) {
      resistances.add(type);
    }
    return resistances.toSet().toList(); // Remueve duplicados
  }

  static Future<String> _fetchPokedexDescription(String speciesUrl) async {
    final response = await http.get(Uri.parse(speciesUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['flavor_text_entries'].firstWhere(
          (entry) => entry['language']['name'] == 'en')['flavor_text'];
    } else {
      throw Exception('Error al cargar la descripción de la Pokédex');
    }
  }
}
