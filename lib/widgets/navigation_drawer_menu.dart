import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationDrawerMenu extends StatelessWidget {
  const NavigationDrawerMenu({super.key});

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
              context.go('/');
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
