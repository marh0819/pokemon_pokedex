// lib/services/pokemon_comparator_service.dart

import 'package:pokemon_pokedex/models/pokemon.dart';

class PokemonComparatorService {
  static final PokemonComparatorService _instance =
      PokemonComparatorService._internal();

  Pokemon? _pokemon1;
  Pokemon? _pokemon2;

  factory PokemonComparatorService() {
    return _instance;
  }

  PokemonComparatorService._internal();

  void setPokemon1(Pokemon pokemon) {
    _pokemon1 = pokemon;
  }

  void setPokemon2(Pokemon pokemon) {
    _pokemon2 = pokemon;
  }

  Pokemon? get pokemon1 => _pokemon1;
  Pokemon? get pokemon2 => _pokemon2;

  void clear() {
    _pokemon1 = null;
    _pokemon2 = null;
  }
}
