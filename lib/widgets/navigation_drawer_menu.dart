import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawerMenu extends StatefulWidget {
  const NavigationDrawerMenu({super.key});

  @override
  _NavigationDrawerMenuState createState() => _NavigationDrawerMenuState();
}

class _NavigationDrawerMenuState extends State<NavigationDrawerMenu> {
  String _firstName = 'Invitado'; // Valor por defecto

  @override
  void initState() {
    super.initState();
    _loadFirstName(); // Cargar el nombre del usuario cuando se inicializa el widget
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFirstName(); // Recarga el nombre cuando cambia el contexto
  }

  // Método para cargar el nombre del usuario desde SharedPreferences
  Future<void> _loadFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('firstName') ?? 'Invitado';
    });
  }

  // Método para confirmar el cierre de sesión
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmar Logout',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: const Text(
            '¿Estás seguro de que quieres cerrar sesión?',
            style: TextStyle(color: Colors.black87),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.teal),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                _logout(context); // Llama a la función de logout
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // Método para hacer logout
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('firstName'); // Elimina el nombre del usuario
    context.go('/'); // Redirige a la página de Login (ruta '/')
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.redAccent.shade700, // Fondo temático rojo
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.redAccent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Bienvenido, $_firstName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildMenuItem(
              context,
              icon: Icons.person,
              label: 'Usuarios',
              route: '/usuarios',
            ),
            _buildMenuItem(
              context,
              icon: Icons.catching_pokemon,
              label: 'Pokémon',
              route: '/pokemon',
            ),
            _buildMenuItem(
              context,
              icon: Icons.compare,
              label: 'Comparador',
              route: '/comparador',
            ),
            _buildMenuItem(
              context,
              icon: Icons.group,
              label: 'Mi Equipo',
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                final teamId = prefs.getInt('id'); // Recupera el teamId

                if (teamId != null) {
                  context.go('/team/$teamId'); // Pasa el teamId a la ruta
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'No se ha encontrado el equipo del usuario',
                      ),
                    ),
                  );
                }
                Navigator.of(context).pop(); // Cierra el Drawer
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.map,
              label: 'Mapa Hoen',
              route: '/mapa',
            ),
            _buildMenuItem(
              context,
              icon: Icons.quiz,
              label: 'Trivia',
              route: '/trivia',
            ),
            _buildMenuItem(
              context,
              icon: Icons.account_circle,
              label: 'Perfil',
              route: '/perfil',
            ),
            const Divider(color: Colors.white70),
            _buildMenuItem(
              context,
              icon: Icons.logout,
              label: 'Logout',
              onTap: () => _confirmLogout(context),
              iconColor: const Color.fromARGB(255, 255, 255, 255),
              textColor: const Color.fromARGB(255, 255, 255, 255),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? route,
    VoidCallback? onTap,
    Color iconColor = Colors.white,
    Color textColor = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap ??
          () {
            if (route != null) {
              context.go(route); // Navega a la ruta proporcionada
            }
            Navigator.of(context).pop(); // Cierra el Drawer
          },
    );
  }
}
