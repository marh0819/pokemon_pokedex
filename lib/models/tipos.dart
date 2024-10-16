// ignore_for_file: non_constant_identifier_names

class Tipos {
  final int idTipo;
  final String nombreTipo;

  Tipos({required this.idTipo, required this.nombreTipo});

  // Factory constructor para crear un objeto User desde JSON
  factory Tipos.fromJson(Map<String, dynamic> json) {
    return Tipos(
      idTipo: json['idTipo'] ??
          0, // Proporciona un valor por defecto o lanza una excepción
      nombreTipo: json['nombreTipo'] ?? '',
    );
  }

  // Método para convertir un objeto User a JSON
  Map<String, dynamic> toJson() {
    return {
      'idTipo': idTipo,
      'nombreTipo': nombreTipo,
    };
  }
}
