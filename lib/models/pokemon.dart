// ignore_for_file: non_constant_identifier_names

class Pokemon {
  final int idPokemon;
  final String nombre;
  final String tipoPrimario;
  final String tipoSecundario;

  Pokemon(
      {required this.idPokemon,
      required this.nombre,
      required this.tipoPrimario,
      required this.tipoSecundario});

  // Factory constructor para crear un objeto User desde JSON
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      idPokemon: json['idPokemon'] ??
          0, // Proporciona un valor por defecto o lanza una excepción
      nombre: json['nombre'] ?? '',
      tipoPrimario: json['tipoPrimario'] ?? '',
      tipoSecundario: json['tipoSecundario'] ?? '',
    );
  }

  // Método para convertir un objeto User a JSON
  Map<String, dynamic> toJson() {
    return {
      'idPokemon': idPokemon,
      'nombre': nombre,
      'tipoPrimario': tipoPrimario,
      'tipoSecundario': tipoSecundario
    };
  }
}
