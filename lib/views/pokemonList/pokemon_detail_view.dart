import 'package:flutter/material.dart';
import 'package:pokemon_pokedex/models/pokemon.dart';
import 'package:pokemon_pokedex/services/user_service.dart';
import 'package:pokemon_pokedex/services/pokemon_comparator_service.dart';
import 'package:pokemon_pokedex/widgets/navigation_drawer_menu.dart';

class PokemonDetailView extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailView({Key? key, required this.pokemon}) : super(key: key);

  void _showAbilityDescription(
      BuildContext context, String ability, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(ability),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              child: const Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addToTeam(BuildContext context) async {
    try {
      await UserService().addPokemonToTeam(pokemon.pokedexNumber, pokemon.name);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pokémon añadido al equipo')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al añadir al equipo: $e')),
      );
    }
  }

  void _addToComparator(BuildContext context, int slot) {
    final comparatorService = PokemonComparatorService();
    if (slot == 1) {
      comparatorService.setPokemon1(pokemon);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pokémon seleccionado como 1')),
      );
    } else if (slot == 2) {
      comparatorService.setPokemon2(pokemon);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pokémon seleccionado como 2')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: NavigationDrawerMenu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(pokemon.imageUrl),
              Text(
                '#${pokemon.pokedexNumber} ${pokemon.name}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text('Tipos: ${pokemon.types.join(', ')}'),
              Text('Resistencias: ${pokemon.resistances.join(', ')}'),
              Text('Debilidades: ${pokemon.weaknesses.join(', ')}'),
              Text('Descripción: ${pokemon.description}'),
              const SizedBox(height: 10),
              Text(
                'Habilidades:',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...pokemon.abilities.entries.map((entry) => GestureDetector(
                    onTap: () => _showAbilityDescription(
                        context, entry.key, entry.value),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        entry.key,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _addToTeam(context),
                child: const Text('Añadir al Equipo'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _addToComparator(context, 1),
                child: const Text('Seleccionar para Comparar 1'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _addToComparator(context, 2),
                child: const Text('Seleccionar para Comparar 2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
