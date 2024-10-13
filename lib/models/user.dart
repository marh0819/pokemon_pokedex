// ignore_for_file: non_constant_identifier_names

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.password});

  // Factory constructor para crear un objeto User desde JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ??
          0, // Proporciona un valor por defecto o lanza una excepción
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  // Método para convertir un objeto User a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password
    };
  }
}
