import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationDrawerMenu extends StatelessWidget {
  const NavigationDrawerMenu({super.key});

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Logout'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                context.go('/'); // Redirige a la página de Login (ruta '/')
                Navigator.of(context).pop(); // Cierra el Drawer
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menú de Navegación',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.black),
            title: const Text(
              'Usuarios',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              context.go('/usuarios');
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.catching_pokemon, color: Colors.black),
            title: const Text(
              'Pokémon',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              context.go('/pokemon');
              Navigator.of(context).pop();
            },
          ),
          const Divider(), // Línea divisoria
          ListTile(
            leading:
                const Icon(Icons.logout, color: Colors.red), // Icono en rojo
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red), // Texto en rojo
            ),
            onTap: () {
              _confirmLogout(context); // Muestra el diálogo de confirmación
            },
          ),
        ],
      ),
    );
  }
}
