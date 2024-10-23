class Pokemon {
  final int pokedexNumber;
  final String name;
  final String imageUrl;
  final List<String> types;

  Pokemon({
    required this.pokedexNumber,
    required this.name,
    required this.imageUrl,
    required this.types,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final List<String> types = (json['types'] as List)
        .map((type) => type['type']['name'] as String)
        .toList();

    return Pokemon(
      pokedexNumber: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['front_default'],
      types: types,
    );
  }
}
