import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_pokedex/widgets/navigation_drawer_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  int? id;
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '******'; // Muestra la contraseña enmascarada por defecto

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData(); // Recarga los datos cuando cambia el contexto
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('id');
      firstName = prefs.getString('firstName') ?? '';
      lastName = prefs.getString('lastName') ?? '';
      email = prefs.getString('email') ?? '';
      password = '******';
    });
  }

  Future<void> _showEditConfirmationDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Edición'),
          content: const Text('¿Deseas editar la información del usuario?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
    if (confirm == true && id != null) {
      context.go('/usuarios/edit/$id');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
      ),
      drawer: const NavigationDrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: $id', style: const TextStyle(fontSize: 18)),
            Text('Nombre: $firstName', style: const TextStyle(fontSize: 18)),
            Text('Apellido: $lastName', style: const TextStyle(fontSize: 18)),
            Text('Email: $email', style: const TextStyle(fontSize: 18)),
            Text('Password: $password', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20), // Espacio entre los textos y el botón
            ElevatedButton(
              onPressed: _showEditConfirmationDialog,
              child: const Text('Editar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
