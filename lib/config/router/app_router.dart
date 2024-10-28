import 'package:go_router/go_router.dart';
// Importa las vistas necesarias
import 'package:pokemon_pokedex/views/login/LoginView.dart';
import 'package:pokemon_pokedex/views/login/RegisterView.dart';
import 'package:pokemon_pokedex/views/pokemonList/pokemon_list_view.dart';
import 'package:pokemon_pokedex/views/teamView/teamView.dart';
import 'package:pokemon_pokedex/views/userGlobal/user_create_view.dart';
import 'package:pokemon_pokedex/views/userGlobal/user_delete_view.dart';
import 'package:pokemon_pokedex/views/userGlobal/user_edit_view.dart';
import 'package:pokemon_pokedex/views/userGlobal/user_list_view.dart';
import 'package:pokemon_pokedex/views/userPersonal/user_profile_view.dart'; // Importa la vista de listar Pokémon

final router = GoRouter(
  routes: [
    // Ruta para el login (ruta inicial)
    GoRoute(
      path: '/',
      builder: (context, state) => LoginView(),
    ),
    // Ruta para listar usuarios
    GoRoute(
      path: '/usuarios',
      builder: (context, state) => const UserList(),
    ),
    // Ruta para crear un nuevo usuario
    GoRoute(
      path: '/usuarios/create',
      builder: (context, state) => const UserCreate(),
    ),
    // Ruta para editar un usuario existente
    GoRoute(
      path: '/usuarios/edit/:id',
      builder: (context, state) {
        final idusuario = state.params['id']!;
        return UserEdit(idusuario: idusuario);
      },
    ),
    // Ruta para eliminar un usuario
    GoRoute(
      path: '/usuarios/delete/:id',
      builder: (context, state) {
        final userId = state.params['id']!;
        return UserDelete(userId: int.parse(userId));
      },
    ),
    // Ruta para listar Pokémon
    GoRoute(
      path: '/pokemon',
      builder: (context, state) =>
          const PokemonList(), // Vista para listar Pokémon
    ),
    GoRoute(
      path: '/perfil',
      builder: (context, state) => const UserProfileView(),
    ),
    GoRoute(
      path: '/createUser',
      builder: (context, state) => const UserRegister(), // Pasa el ID del equipo aquí
    ),
    GoRoute(
      path: '/team/:teamId', // Include teamId as a route parameter
      builder: (context, state) {
        final teamId = int.parse(state.params['teamId']!); // Parse teamId from route
        return TeamView(teamId: teamId);
      },
    ),
  ],
);
