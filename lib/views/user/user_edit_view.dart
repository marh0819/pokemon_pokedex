// lib/views/users/user_edit_view.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_pokedex/models/user.dart'; // Asegúrate de tener este modelo implementado
import 'package:pokemon_pokedex/services/user_service.dart';
import 'package:pokemon_pokedex/widgets/navigation_drawer_menu.dart';

/// Vista para editar un usuario existente.
/// Permite al usuario modificar los datos del usuario seleccionado.
class UserEdit extends StatefulWidget {
  final String idusuario; // ID del usuario a editar.

  const UserEdit({super.key, required this.idusuario});

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserService _userService = UserService();
  late Future<User> _futureUser; // Futuro que contendrá el usuario a editar

  @override
  void initState() {
    super.initState();
    print('Editing user with ID: ${widget.idusuario}');
    // Al iniciar, obtenemos los datos del usuario por su ID
    _futureUser = _userService.getUserById(int.parse(widget.idusuario));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Método para manejar la acción de actualizar el usuario.
  /// Valida el formulario y envía los datos actualizados al servicio.
  void _updateUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Llamamos al método del servicio para actualizar el usuario
        await _userService.updateUser(
          int.parse(widget.idusuario),
          _firstNameController.text,
          _lastNameController.text,
          _emailController.text,
          _passwordController.text,
        );

        // Mostramos un mensaje de éxito.
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario actualizado con éxito')),
        );
        context.go('/'); // Regresar a la lista de usuarios
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el usuario: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Usuario')),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: FutureBuilder<User>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            // Asignamos los valores actuales del usuario a los controladores.
            _firstNameController.text = user.firstName;
            _lastNameController.text = user.lastName;
            _emailController.text = user.email;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              // Formulario para editar los datos del usuario.
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo de texto para el primer nombre del usuario.
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'Primer Nombre',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa el primer nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Campo de texto para el apellido del usuario.
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Apellido',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa el apellido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Campo de texto para el correo electrónico.
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Correo Electrónico',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa el correo electrónico';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Campo de texto para la contraseña.
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      obscureText: true, // Ocultamos la contraseña
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa la contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Botón para enviar el formulario y actualizar el usuario
                    ElevatedButton(
                      onPressed: _updateUser,
                      child: const Text('Actualizar'),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // En caso de error al obtener los datos, mostramos un mensaje
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Mientras se cargan los datos, mostramos un indicador de progreso.
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
