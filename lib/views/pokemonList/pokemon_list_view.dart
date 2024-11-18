import 'package:flutter/material.dart';
import 'package:pokemon_pokedex/models/pokemon.dart';
import 'package:pokemon_pokedex/services/pokemon_service.dart';
import 'package:pokemon_pokedex/type_colors.dart';
import 'package:pokemon_pokedex/views/pokemonList/pokemon_detail_view.dart';
import 'package:pokemon_pokedex/widgets/navigation_drawer_menu.dart';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  final PokemonService _pokemonService = PokemonService();
  int _currentPage = 1;
  static const int _limit = 10;
  late Future<List<Pokemon>> _futurePokemons;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPokemons();
  }

  void _loadPokemons() {
    setState(() {
      _isLoading = true;
    });

    _futurePokemons =
        _pokemonService.getPokemons(page: _currentPage, limit: _limit);

    _futurePokemons.then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  void _nextPage() {
    setState(() {
      _currentPage++;
      _loadPokemons();
    });
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
        _loadPokemons();
      });
    }
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Color darkenColor(Color color, [double amount = .2]) {
    final hsl = HSLColor.fromColor(color);
    final darkened =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkened.toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 252, 57, 57),
          elevation: 0,
          flexibleSpace: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.redAccent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              const Positioned(
                top:
                    40, // Ajuste para que los círculos no interfieran con la hora
                left: 10,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(width: 8),
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.yellow,
                    ),
                    SizedBox(width: 8),
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.green,
                    ),
                  ],
                ),
              ),
              const Positioned(
                top: 60, // Bajé el título para mejor alineación
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.catching_pokemon,
                      color: Colors.white,
                      size: 28,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Pokédex',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const NavigationDrawerMenu(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Pokemon>>(
              future: _futurePokemons,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final pokemons = snapshot.data!;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: pokemons.length,
                          itemBuilder: (context, index) {
                            final pokemon = pokemons[index];
                            final typeColor =
                                typeColors[pokemon.types.first] ?? Colors.grey;
                            final darkenedColor = darkenColor(typeColor);

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 8.0),
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: typeColor.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  leading: Container(
                                    margin: const EdgeInsets.only(top: 4.0),
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        pokemon.imageUrl,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.none,
                                      ),
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        '#${pokemon.pokedexNumber}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18.0,
                                          color: darkenedColor,
                                        ),
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        capitalize(pokemon.name),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          color: darkenedColor.withOpacity(0.8),
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: pokemon.types.map((type) {
                                          final color =
                                              typeColors[type] ?? Colors.grey;

                                          return Container(
                                            margin: const EdgeInsets.only(
                                                left: 2.5, top: 4.0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6.0, vertical: 2.0),
                                            decoration: BoxDecoration(
                                              color: color,
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                            ),
                                            child: Text(
                                              type,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PokemonDetailView(pokemon: pokemon),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _currentPage > 1 ? _previousPage : null,
                            child: const Text('Anterior'),
                          ),
                          ElevatedButton(
                            onPressed:
                                pokemons.length == _limit ? _nextPage : null,
                            child: const Text('Siguiente'),
                          ),
                        ],
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
    );
  }
}
