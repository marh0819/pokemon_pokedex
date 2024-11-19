import 'package:flutter/material.dart';
import 'package:pokemon_pokedex/models/pokemon.dart';
import 'package:pokemon_pokedex/services/user_service.dart';
import 'package:pokemon_pokedex/services/pokemon_comparator_service.dart';
import 'package:pokemon_pokedex/widgets/navigation_drawer_menu.dart';
import 'package:pokemon_pokedex/type_colors.dart'; // Importa el archivo de colores

class PokemonDetailView extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailView({super.key, required this.pokemon});

  void _showAbilityDescription(
      BuildContext context, String ability, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            ability,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Cerrar",
                style: TextStyle(fontSize: 16),
              ),
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

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = typeColors[pokemon.types.first]?.withOpacity(0.5) ??
        Colors.grey.withOpacity(0.5);

    final Color? baseTitleColor = typeColors[pokemon.types.first];
    final Color titleColor = baseTitleColor != null
        ? darkenColor(baseTitleColor, 0.2)
        : Colors.black;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.redAccent,
          elevation: 5,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Pokédex',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'PokemonClassic',
                    ),
                  ),
                ],
              ),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const NavigationDrawerMenu(),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '#${pokemon.pokedexNumber}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      capitalize(pokemon.name),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          pokemon.imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: pokemon.types.map((type) {
                      final typeColor = typeColors[type] ?? Colors.grey;
                      return Chip(
                        label: Text(
                          type,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: typeColor,
                        elevation: 4,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  title: 'Descripción',
                  titleColor: titleColor,
                  child: Text(
                    pokemon.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  title: 'Habilidades',
                  titleColor: titleColor,
                  child: Column(
                    children: pokemon.abilities.entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _showAbilityDescription(
                            context, entry.key, entry.value),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white, // Fondo blanco sólido
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                            border: Border.all(
                              color: typeColors[pokemon.types.first]
                                      ?.withOpacity(0.6) ??
                                  Colors.grey,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: TextStyle(
                                  color: typeColors[pokemon.types.first]
                                          ?.withOpacity(0.8) ??
                                      Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.info_outline,
                                color: typeColors[pokemon.types.first]
                                        ?.withOpacity(0.8) ??
                                    Colors.black,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  title: 'Resistencias',
                  titleColor: titleColor,
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: pokemon.resistances.map((resistance) {
                      final resistanceColor =
                          typeColors[resistance]?.withOpacity(1) ?? Colors.grey;
                      return Chip(
                        label: Text(
                          resistance,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: resistanceColor,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  title: 'Debilidades',
                  titleColor: titleColor,
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: pokemon.weaknesses.map((weakness) {
                      final weaknessColor =
                          typeColors[weakness]?.withOpacity(1) ?? Colors.grey;
                      return Chip(
                        label: Text(
                          weakness,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: weaknessColor,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _addToTeam(context),
                        icon: const Icon(Icons.group_add),
                        label: const Text('Añadir al Equipo'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          backgroundColor: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => _addToComparator(context, 1),
                        icon: const Icon(Icons.compare_arrows),
                        label: const Text('Seleccionar para Comparar 1'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => _addToComparator(context, 2),
                        icon: const Icon(Icons.compare_arrows_outlined),
                        label: const Text('Seleccionar para Comparar 2'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Color titleColor,
    required Widget child,
  }) {
    return Column(
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }

  Color darkenColor(Color color, double amount) {
    final int red = (color.red * (1 - amount)).clamp(0, 255).toInt();
    final int green = (color.green * (1 - amount)).clamp(0, 255).toInt();
    final int blue = (color.blue * (1 - amount)).clamp(0, 255).toInt();
    return Color.fromARGB(color.alpha, red, green, blue);
  }
}
