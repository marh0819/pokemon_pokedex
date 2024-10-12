import 'package:go_router/go_router.dart';
import 'package:memesv2/views/categories/category_create_view.dart';
import 'package:memesv2/views/categories/category_edit_view.dart';
import 'package:memesv2/views/categories/category_list_view.dart';
import 'package:memesv2/views/memes/meme_create.dart';
import 'package:memesv2/views/memes/meme_edit.dart';
import 'package:memesv2/views/memes/meme_list.dart';
import 'package:memesv2/views/roles/roles_create_view.dart';
import 'package:memesv2/views/roles/roles_delete_view.dart';
import 'package:memesv2/views/roles/roles_edit_view.dart';
import 'package:memesv2/views/roles/roles_list_view.dart';
import 'package:memesv2/views/entidad/entidad_create_view.dart';
import 'package:memesv2/views/entidad/entidad_edit_view.dart';
import 'package:memesv2/views/entidad/entidad_delete_view.dart';
import 'package:memesv2/views/entidad/entidad_list_view.dart';
import 'package:memesv2/views/user/user_create_view.dart';
import 'package:memesv2/views/user/user_delete_view.dart';
import 'package:memesv2/views/user/user_edit_view.dart';
import 'package:memesv2/views/user/user_list_view.dart';



final router = GoRouter(
  routes: [
    // Ruta para listar categorías
    GoRoute(
      path: '/',
      builder: (context, state) => const CategoryList(),
    ),
    // Ruta para crear una nueva categoría
    GoRoute(
      path: '/create',
      builder: (context, state) => const CategoryCreate(),
    ),
    // Ruta para editar una categoría existente
    GoRoute(
      path: '/edit/:id',
      builder: (context, state) {
        final id = state.params['id']!;
        return CategoryEdit(id: id);
      },
    ),
    // Ruta para listar memes
    GoRoute(
      path: '/memes',
      builder: (context, state) => const MemeList(),
    ),
    // Ruta para crear un nuevo meme
    GoRoute(
      path: '/memes/create',
      builder: (context, state) => const MemeCreate(),
    ),
    // Ruta para editar un meme existente
    GoRoute(
      path: '/memes/edit/:id',
      builder: (context, state) {
        final id = state.params['id']!;
        return MemeEdit(id: id);
      },
    ),

    // Rutas para Roles
    GoRoute(
      path: '/roles',
      builder: (context, state) => const RoleList(),
    ),
    GoRoute(
      path: '/roles/create',
      builder: (context, state) => const RoleCreate(),
    ),
    GoRoute(
      path: '/roles/edit/:id',
      builder: (context, state) {
        final idrol = state.params['id']!;
        return RoleEdit(idrol: idrol);
      },
    ),
    GoRoute(
  path: '/roles/delete/:id',
  builder: (context, state) {
    final idrol = state.params['id']!;
    return RoleDelete(idrol: idrol);
  },
),

// Rutas para Entidades
    GoRoute(
      path: '/entidades',
      builder: (context, state) => const EntidadList(),
    ),
    GoRoute(
      path: '/entidades/create',
      builder: (context, state) => const EntidadCreate(),
    ),
    GoRoute(
      path: '/entidades/edit/:id',
      builder: (context, state) {
        final identidad = state.params['id']!;
        return EntidadEdit(identidad: identidad);
      },
    ),

    GoRoute(
  path: '/entidades/delete/:id',
  builder: (context, state) {
    final identidad = state.params['id']!;
    return EntidadDelete(identidad: identidad);
  },
),

 // Rutas para Usuarios
    GoRoute(
      path: '/usuarios',
      builder: (context, state) => const UserList(),
    ),
    GoRoute(
      path: '/usuarios/create',
      builder: (context, state) => const UserCreate(),
    ),
    GoRoute(
      path: '/usuarios/edit/:id',
      builder: (context, state) {
        final idusuario = state.params['id']!;
        return UserEdit(idusuario: idusuario);
      },
    ),

    GoRoute(
      path: '/usuarios/delete/:id',
      builder: (context, state) {
        final idusuario = state.params['id']!;
        return UserDelete(idusuario: idusuario);
      },
    ),

  ],
);
