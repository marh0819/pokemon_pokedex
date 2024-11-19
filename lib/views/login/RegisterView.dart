import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_pokedex/services/user_service.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  // Clave global para el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Instancia del servicio
  final UserService _userService = UserService();

  @override
  void dispose() {
    // Liberar los controladores cuando ya no sean necesarios
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Método para manejar la creación del usuario
  // Método para manejar la creación del usuario
  void _createUser() async {
  if (_formKey.currentState!.validate()) {
    try {
      await _userService.createUser(
        _firstNameController.text,
        _lastNameController.text,
        _emailController.text,
        _passwordController.text,
      );

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario creado con éxito')),
      );

      // Esperar un segundo antes de navegar
      await Future.delayed(const Duration(seconds: 1));

      // Regresar a la lista de usuarios
      context.go('/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear el usuario: $e')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo para el nombre
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el nombre';
                  } else if (value.length < 3) {
                    return 'El nombre debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo para el apellido
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el apellido';
                  } else if (value.length < 3) {
                    return 'El apellido debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo para el correo
              TextFormField(
                controller: _emailController,
                decoration:
                    const InputDecoration(labelText: 'Correo Electrónico'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el correo electrónico';
                  }
                  // Validación de formato de correo electrónico
                  String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return 'Por favor, ingresa un correo válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo para la contraseña
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una contraseña';
                  } else if (value.length < 8) {
                    return 'La contraseña debe tener al menos 8 caracteres';
                  } else if (!RegExp(
                          r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,16}$')
                      .hasMatch(value)) {
                    return 'La contraseña debe tener entre 8 y 16 caracteres, incluir al menos un número y una letra mayúscula';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Botón para crear el usuario
              ElevatedButton(
                onPressed: _createUser,
                child: const Text('Crear Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
