import 'package:flutter/material.dart';
import 'package:pokemon_pokedex/models/pokemon.dart';
import 'package:pokemon_pokedex/services/pokemon_service.dart';
import 'package:pokemon_pokedex/services/user_service.dart';
import 'package:pokemon_pokedex/widgets/navigation_drawer_menu.dart';

class TeamView extends StatefulWidget {
  final int teamId;

  const TeamView({Key? key, required this.teamId}) : super(key: key);

  @override
  _TeamViewState createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
  final UserService _userService = UserService();
  final PokemonService _pokemonService = PokemonService();
  late Future<List<Pokemon>> _teamPokemonDetails;

  @override
  void initState() {
    super.initState();
    _teamPokemonDetails = _loadTeamPokemonDetails();
  }

  Future<List<Pokemon>> _loadTeamPokemonDetails() async {
    final pokedexNumbers = await _userService.getTeamPokemonIds(widget.teamId);
    return await _pokemonService.getPokemonDetails(pokedexNumbers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Equipo'),
      ),
      drawer: NavigationDrawerMenu(), // Incluye el NavigationDrawerMenu
      body: FutureBuilder<List<Pokemon>>(
        future: _teamPokemonDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final team = snapshot.data!;
            return ListView.builder(
              itemCount: team.length,
              itemBuilder: (context, index) {
                final pokemon = team[index];
                return ListTile(
                  leading: Image.network(pokemon.imageUrl),
                  title: Text('#${pokemon.pokedexNumber} ${pokemon.name}'),
                  subtitle: Text('Tipos: ${pokemon.types.join(', ')}'),
                );
              },
            );
          } else if (snapshot.hasError) {
            // Muestra el error detallado
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: Text('Error al cargar el equipo'));
          }
        },
      ),
    );
  }
}
