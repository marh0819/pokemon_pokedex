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
    final Map<String, String> typesMap =
        await _fetchTypesInSpanish(json['types']);

    final List<String> typesInSpanish = typesMap.values.toList();
    final List<String> typesInEnglish = typesMap.keys.toList();

    final description = await _fetchPokedexDescription(json['species']['url']);
    final damageRelations =
        await PokemonService().getDamageRelations(typesInEnglish);

    final weaknesses =
        await _translateTypes(_calculateWeaknesses(damageRelations));
    final resistances =
        await _translateTypes(_calculateResistances(damageRelations));

    final Map<String, String> abilities = {};
    for (var abilityInfo in json['abilities']) {
      final abilityUrl = abilityInfo['ability']['url'];
      final abilityData =
          await PokemonService().getAbilityDescription(abilityUrl);

      // Asegúrate de que no haya valores nulos
      final abilityName = abilityData['name'] ?? 'Nombre desconocido';
      final abilityEffect =
          abilityData['effect'] ?? 'Descripción no disponible';

      abilities[abilityName] = abilityEffect;
    }

    return Pokemon(
      pokedexNumber: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['front_default'],
      types: typesInSpanish, // Muestra los tipos en español
      abilities: abilities,
      description: description,
      weaknesses: weaknesses,
      resistances: resistances,
    );
  }

  static Future<Map<String, String>> _fetchTypesInSpanish(
      List<dynamic> typesJson) async {
    Map<String, String> typesMap = {};
    for (var typeInfo in typesJson) {
      final typeUrl = typeInfo['type']['url'];
      final response = await http.get(Uri.parse(typeUrl));
      if (response.statusCode == 200) {
        final typeData = jsonDecode(response.body);
        final nameInSpanish = typeData['names']
            .firstWhere((entry) => entry['language']['name'] == 'es')['name'];
        final nameInEnglish = typeData['name'];
        typesMap[nameInEnglish] = nameInSpanish;
      } else {
        print('Error al cargar el tipo en español para URL: $typeUrl');
        throw Exception('Error al cargar el tipo en español');
      }
    }
    return typesMap;
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
    return weaknesses.toSet().toList();
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
    return resistances.toSet().toList();
  }

  static Future<List<String>> _translateTypes(
      List<String> typesInEnglish) async {
    final List<String> translatedTypes = [];
    for (var type in typesInEnglish) {
      final typeUrl = 'https://pokeapi.co/api/v2/type/$type';
      final response = await http.get(Uri.parse(typeUrl));
      if (response.statusCode == 200) {
        final typeData = jsonDecode(response.body);
        final nameInSpanish = typeData['names']
            .firstWhere((entry) => entry['language']['name'] == 'es')['name'];
        translatedTypes.add(nameInSpanish);
      } else {
        print('Error al cargar el tipo en español para URL: $typeUrl');
        throw Exception('Error al cargar el tipo en español');
      }
    }
    return translatedTypes;
  }

  static Future<String> _fetchPokedexDescription(String speciesUrl) async {
    final response = await http.get(Uri.parse(speciesUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final descriptionInSpanish = data['flavor_text_entries'].firstWhere(
          (entry) => entry['language']['name'] == 'es')['flavor_text'];
      return descriptionInSpanish;
    } else {
      throw Exception('Error al cargar la descripción de la Pokédex');
    }
  }
}
