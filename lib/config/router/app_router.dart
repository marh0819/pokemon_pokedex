import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart'; // Asegúrate de importar los paquetes necesarios
import 'package:pokemon_pokedex/views/user/user_create_view.dart';
import 'package:pokemon_pokedex/views/user/user_delete_view.dart';
import 'package:pokemon_pokedex/views/user/user_list_view.dart';
import 'package:pokemon_pokedex/views/user/user_edit_view.dart';
import 'package:pokemon_pokedex/views/login/LoginView.dart'; // Importa la vista de Login

final router = GoRouter(
  routes: [
    // Ruta para el login (ruta inicial)
    GoRoute(
      path: '/',
      builder: (context, state) => LoginView(), // Aquí está la vista de Login
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
        return UserDelete(
            userId: int.parse(userId)); // Cambia idusuario a userId
      },
    ),
  ],
);
