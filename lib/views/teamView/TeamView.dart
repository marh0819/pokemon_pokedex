import 'package:flutter/material.dart';
import 'package:pokemon_pokedex/models/pokemon.dart';
import 'package:pokemon_pokedex/services/pokemon_service.dart';
import 'package:pokemon_pokedex/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pokemon_pokedex/widgets/navigation_drawer_menu.dart';

class TeamView extends StatefulWidget {
  final int teamId;

  const TeamView({super.key, required this.teamId});

  @override
  State<TeamView> createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
  final UserService _userService = UserService();
  final PokemonService _pokemonService = PokemonService();
  late Future<List<Pokemon>> _teamPokemonDetails;
  String _firstName = 'Invitado';

  @override
  void initState() {
    super.initState();
    _teamPokemonDetails = _loadTeamPokemonDetails();
    _loadFirstName();
  }

  Future<void> _loadFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('firstName') ?? 'Invitado';
    });
  }

  Future<List<Pokemon>> _loadTeamPokemonDetails() async {
    final pokedexNumbers = await _userService.getTeamPokemonIds(widget.teamId);
    return await _pokemonService.getPokemonDetails(pokedexNumbers);
  }

  Future<void> _removePokemon(int index) async {
    try {
      final pokemonToRemove = (await _teamPokemonDetails)[index];
      await _userService.removePokemonFromTeam(
          widget.teamId, pokemonToRemove.pokedexNumber);

      setState(() {
        _teamPokemonDetails = _loadTeamPokemonDetails();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${pokemonToRemove.name} eliminado del equipo',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al eliminar el Pokémon: $e',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // Altura aumentada
        child: AppBar(
          backgroundColor: const Color(0xFF001F3F), // Azul oscuro profundo
          elevation: 4,
          shadowColor: Colors.amberAccent,
          centerTitle: true,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.amber, size: 28),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'HALL',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    letterSpacing: 4.0,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 4),
                        blurRadius: 7,
                        color: Colors.amberAccent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.amber,
                        Colors.orangeAccent,
                        Colors.transparent,
                      ],
                      stops: [0.4, 0.8, 1],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'FAME',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    letterSpacing: 4.0,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 4),
                        blurRadius: 7,
                        color: Colors.amberAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const NavigationDrawerMenu(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF001F3F), Color(0xFF003366)], // Azul profundo
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Pokemon>>(
          future: _teamPokemonDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              final team = snapshot.data!;
              if (team.isEmpty) {
                return const Center(
                  child: Text(
                    '¡No hay Pokémon en el equipo!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                );
              }
              return ListView.builder(
                itemCount: team.length,
                itemBuilder: (context, index) {
                  final pokemon = team[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.amber.shade700, width: 2),
                    ),
                    color: const Color(0xFF002F5F), // Azul oscuro más claro
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(pokemon.imageUrl),
                        radius: 30,
                        backgroundColor: Colors.amber.shade100,
                      ),
                      title: Text(
                        '#${pokemon.pokedexNumber} ${pokemon.name}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'Tipos: ${pokemon.types.join(', ')}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removePokemon(index),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'Error al cargar el equipo',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
