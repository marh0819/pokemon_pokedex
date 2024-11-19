import 'package:flutter/material.dart';
import 'package:pokemon_pokedex/widgets/navigation_drawer_menu.dart';

class HoennMapView extends StatelessWidget {
  HoennMapView({super.key});

  // Lista de ciudades de Hoenn con sus imágenes, colores personalizados y orden de visita
  final List<Map<String, dynamic>> cities = [
    {
      "name": "Pueblo Raíz",
      "image": "lib/assets/cities/littleroot.png",
      "color": Colors.green.shade700,
    },
    {
      "name": "Pueblo Escaso",
      "image": "lib/assets/cities/oldale.png",
      "color": Colors.blueGrey.shade400,
    },
    {
      "name": "Ciudad Petalia",
      "image": "lib/assets/cities/petalburg.png",
      "color": Colors.teal.shade700,
    },
    {
      "name": "Ciudad Férrica",
      "image": "lib/assets/cities/rustboro.png",
      "color": Colors.brown.shade700,
    },
    {
      "name": "Pueblo Azuliza",
      "image": "lib/assets/cities/dewford.png",
      "color": Colors.blue.shade800,
    },
    {
      "name": "Ciudad Portual",
      "image": "lib/assets/cities/slateport.png",
      "color": Colors.lightBlue.shade600,
    },
    {
      "name": "Ciudad Malvalona",
      "image": "lib/assets/cities/mauville.png",
      "color": Colors.yellow.shade700,
    },
    {
      "name": "Pueblo Verdegal",
      "image": "lib/assets/cities/verdanturf.png",
      "color": Colors.greenAccent.shade400,
    },
    {
      "name": "Pueblo Pardal",
      "image": "lib/assets/cities/fallarbor.png",
      "color": Colors.orange.shade600,
    },
    {
      "name": "Pueblo Lavacalda",
      "image": "lib/assets/cities/lavaridge.png",
      "color": Colors.red.shade600,
    },
    {
      "name": "Ciudad Arborada",
      "image": "lib/assets/cities/fortree.png",
      "color": Colors.green.shade800,
    },
    {
      "name": "Ciudad Calagua",
      "image": "lib/assets/cities/lilycove.png",
      "color": Colors.blue.shade500,
    },
    {
      "name": "Ciudad Algaria",
      "image": "lib/assets/cities/mossdeep.png",
      "color": Colors.deepPurple.shade600,
    },
    {
      "name": "Ciudad Arrecípolis",
      "image": "lib/assets/cities/sootopolis.png",
      "color": Colors.lightBlueAccent.shade400,
    },
    {
      "name": "Pueblo Oromar",
      "image": "lib/assets/cities/pacifidlog.png",
      "color": Colors.cyan.shade700,
    },
    {
      "name": "Ciudad Colosalia",
      "image": "lib/assets/cities/ever_grande.png",
      "color": Colors.purple.shade800,
    },
  ];

  // Función para mostrar un ModalBottomSheet con la imagen de la ciudad seleccionada
  void _showCityImage(BuildContext context, String cityName, String cityImage) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que el modal ocupe más espacio
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cityName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Image.asset(
                  cityImage,
                  fit: BoxFit.contain, // Ajusta la imagen al contenedor
                  width: double.infinity, // Ocupa todo el ancho disponible
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade800,
        title: const Row(
          children: [
            Icon(Icons.map, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Mapa de Hoenn',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
      ),
      drawer: const NavigationDrawerMenu(),
      body: Column(
        children: [
          // Mapa de Hoenn con marco negro
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2), // Marco negro
              borderRadius: BorderRadius.circular(8), // Bordes redondeados
            ),
            child: Image.asset(
              'lib/assets/hoen_map.png', // Ruta del mapa de Hoenn
              fit: BoxFit.contain,
              width: double.infinity,
              height: 250, // Altura fija para el mapa
            ),
          ),
          const SizedBox(height: 8),
          // Lista de botones estilizados
          Expanded(
            child: ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _showCityImage(context,
                        '${index + 1}. ${city["name"]!}', city["image"]!),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 6, // Sombra al botón
                      backgroundColor: city["color"], // Color personalizado
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    child: Text(
                      '${index + 1}. ${city["name"]!}', // Agrega el número al nombre
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
