import 'package:flutter/material.dart';
import 'package:pokemon_pokedex/models/pokemon.dart';
import 'package:pokemon_pokedex/services/pokemon_comparator_service.dart';
import 'package:pokemon_pokedex/widgets/navigation_drawer_menu.dart';

class PokemonComparatorView extends StatelessWidget {
  const PokemonComparatorView({Key? key}) : super(key: key);

  Widget _buildPokemonInfo(Pokemon? pokemon) {
    if (pokemon == null) {
      return const Text('Selecciona un Pokémon');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(pokemon.imageUrl),
        Text(
          '#${pokemon.pokedexNumber} ${pokemon.name}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text('Tipos: ${pokemon.types.join(', ')}'),
        Text('Resistencias: ${pokemon.resistances.join(', ')}'),
        Text('Debilidades: ${pokemon.weaknesses.join(', ')}'),
        Text('Habilidades: ${pokemon.abilities.keys.join(', ')}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usar el servicio compartido para obtener los Pokémon seleccionados
    final comparatorService = PokemonComparatorService();
    final pokemon1 = comparatorService.pokemon1;
    final pokemon2 = comparatorService.pokemon2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparador de Pokémon'),
      ),
      drawer: NavigationDrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildPokemonInfo(pokemon1),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPokemonInfo(pokemon2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
