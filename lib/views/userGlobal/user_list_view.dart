import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_pokedex/models/user.dart'; // Asegúrate de tener este modelo implementado
import 'package:pokemon_pokedex/services/user_service.dart';
import 'package:pokemon_pokedex/widgets/navigation_drawer_menu.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final UserService _userService = UserService();
  late Future<List<User>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _futureUsers = _userService.getUsers(); // Método para obtener usuarios
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
      ),
      drawer: const NavigationDrawerMenu(),
      body: FutureBuilder<List<User>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.firstName), // Cambia 'nombreUsuario' por 'firstName'
                  subtitle: Text(user.email), // Cambia 'correoInstitucional' por 'email'
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          print('Edit button pressed for user ID: ${user.id}');
                          context.go('/usuarios/edit/${user.id}'); // Redirigimos a la vista de edición de usuarios
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Eliminar Usuario'),
                                content: const Text('¿Estás seguro de que deseas eliminar este usuario?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        await _userService.deleteUser(user.id); // Método para eliminar usuario
                                        setState(() {
                                          _futureUsers = _userService.getUsers(); // Refrescamos la lista
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Usuario eliminado con éxito')),
                                        );
                                        Navigator.of(context).pop();
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error al eliminar el usuario: $e')),
                                        );
                                      }
                                    },
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/usuarios/create'); // Ruta para crear un nuevo usuario
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
