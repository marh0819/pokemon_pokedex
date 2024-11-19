import 'package:flutter/material.dart';
import 'package:pokemon_pokedex/widgets/navigation_drawer_menu.dart';

class HoennMapView extends StatelessWidget {
  HoennMapView({Key? key}) : super(key: key);

  // Lista de ciudades de Hoenn y sus imágenes
  final List<Map<String, String>> cities = [
    {"name": "Pueblo Raíz", "image": "lib/assets/cities/littleroot.png"},
    {"name": "Pueblo Escaso", "image": "lib/assets/cities/oldale.png"},
    {"name": "Ciudad Petalia", "image": "lib/assets/cities/petalburg.png"},
    {"name": "Ciudad Férrica", "image": "lib/assets/cities/rustboro.png"},
    {"name": "Pueblo Azuliza", "image": "lib/assets/cities/dewford.png"},
    {"name": "Ciudad Portual", "image": "lib/assets/cities/slateport.png"},
    {"name": "Ciudad Malvalona", "image": "lib/assets/cities/mauville.png"},
    {"name": "Pueblo Verdegal", "image": "lib/assets/cities/verdanturf.png"},
    {"name": "Pueblo Pardal", "image": "lib/assets/cities/fallarbor.png"},
    {"name": "Pueblo Lavacalda", "image": "lib/assets/cities/lavaridge.png"},
    {"name": "Ciudad Arborada", "image": "lib/assets/cities/fortree.png"},
    {"name": "Ciudad Calagua", "image": "lib/assets/cities/lilycove.png"},
    {"name": "Ciudad Algaria", "image": "lib/assets/cities/mossdeep.png"},
    {"name": "Ciudad Arrecípolis", "image": "lib/assets/cities/sootopolis.png"},
    {"name": "Pueblo Oromar", "image": "lib/assets/cities/pacifidlog.png"},
    {"name": "Ciudad Colosalia", "image": "lib/assets/cities/ever_grande.png"}
  ];

  // Función para mostrar el AlertDialog con la imagen de la ciudad seleccionada
  void _showCityDialog(
      BuildContext context, String cityName, String cityImage) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(cityName),
        content: Image.asset(
          cityImage,
          fit: BoxFit.cover,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Hoenn'),
      ),
      drawer: NavigationDrawerMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Imagen de fondo del mapa
            Image.asset(
              'lib/assets/hoen_map.png', // Ruta del mapa de Hoenn
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            // Grid de ciudades con 2 columnas
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:4, // Dos columnas por fila
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 3, // Ajusta el ancho y alto de cada tarjeta
                ),
                itemCount: cities.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final city = cities[index];
                  return GestureDetector(
                    onTap: () =>
                        _showCityDialog(context, city["name"]!, city["image"]!),
                    child: Card(
                      elevation: 2,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            city["name"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
