// ignore_for_file: non_constant_identifier_names

class Habilidades {
  final int idHabilidades;
  final String nombreHabilidad;
  final String descripcion;

  Habilidades({
    required this.idHabilidades,
    required this.nombreHabilidad,
    required this.descripcion,
  });

  // Factory constructor para crear un objeto User desde JSON
  factory Habilidades.fromJson(Map<String, dynamic> json) {
    return Habilidades(
      idHabilidades: json['idHabilidades'] ??
          0, // Proporciona un valor por defecto o lanza una excepción
      nombreHabilidad: json['nombreHabilidad'] ?? '',
      descripcion: json['descripcion'] ?? '',
    );
  }

  // Método para convertir un objeto User a JSON
  Map<String, dynamic> toJson() {
    return {
      'idHabilidades': idHabilidades,
      'nombreHabilidad': nombreHabilidad,
      'descripcion': descripcion,
    };
  }
}
