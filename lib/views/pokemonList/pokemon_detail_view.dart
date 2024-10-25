import 'package:flutter/material.dart';
import 'package:pokemon_pokedex/models/pokemon.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(pokemon.imageUrl),
            Text('#${pokemon.pokedexNumber} ${pokemon.name}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Tipos: ${pokemon.types.join(', ')}'),
            Text('Resistencias: ${pokemon.resistances.join(', ')}'),
            Text('Debilidades: ${pokemon.weaknesses.join(', ')}'),
            Text('Descripción: ${pokemon.description}'),
            const SizedBox(height: 10),
            Text('Habilidades:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...pokemon.abilities.entries.map((entry) => GestureDetector(
                  onTap: () =>
                      _showAbilityDescription(context, entry.key, entry.value),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      entry.key,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
