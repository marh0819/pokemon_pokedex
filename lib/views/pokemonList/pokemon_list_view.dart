import 'package:flutter/material.dart';
import 'package:pokemon_pokedex/models/pokemon.dart';
import 'package:pokemon_pokedex/services/pokemon_service.dart';
import 'package:pokemon_pokedex/views/pokemonList/pokemon_detail_view.dart';
import 'package:pokemon_pokedex/widgets/navigation_drawer_menu.dart'; // Importa el NavigationDrawerMenu

class PokemonList extends StatefulWidget {
  const PokemonList({Key? key}) : super(key: key);

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  final PokemonService _pokemonService = PokemonService();
  int _currentPage = 1; // Página actual
  static const int _limit = 10; // Límite de Pokémon por página
  late Future<List<Pokemon>> _futurePokemons;
  bool _isLoading = false; // Nueva variable para el estado de carga

  @override
  void initState() {
    super.initState();
    _loadPokemons();
  }

  void _loadPokemons() {
    setState(() {
      _isLoading = true; // Muestra el loading
    });

    _futurePokemons =
        _pokemonService.getPokemons(page: _currentPage, limit: _limit);

    _futurePokemons.then((_) {
      setState(() {
        _isLoading = false; // Oculta el loading cuando se completen los datos
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false; // Oculta el loading si hay un error
      });
      // Maneja el error, por ejemplo, mostrando un mensaje
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pokémon (3ra Generación)'),
      ),
      drawer: NavigationDrawerMenu(), // Incluye el NavigationDrawerMenu
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Loading Indicator
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
                            return ListTile(
                              leading: Image.network(pokemon.imageUrl),
                              title: Text(
                                  '#${pokemon.pokedexNumber} ${pokemon.name}'),
                              subtitle:
                                  Text('Tipo: ${pokemon.types.join(', ')}'),
                              onTap: () {
                                // Navega a la vista de detalles al hacer clic en el Pokémon
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PokemonDetailView(pokemon: pokemon),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _currentPage > 1
                                ? _previousPage
                                : null, // Deshabilitar si estamos en la primera página
                            child: const Text('Anterior'),
                          ),
                          ElevatedButton(
                            onPressed: pokemons.length == _limit
                                ? _nextPage
                                : null, // Deshabilitar si no hay más Pokémon
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
