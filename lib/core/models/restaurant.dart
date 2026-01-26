class Restaurant {
  final String id;
  String name;
  String cuisine;
  String image;
  double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.image,
    required this.rating,
  });

  // Convert to Map for easy serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cuisine': cuisine,
      'image': image,
      'rating': rating,
    };
  }

  // Create from Map
  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'] as String,
      name: map['name'] as String,
      cuisine: map['cuisine'] as String,
      image: map['image'] as String,
      rating: (map['rating'] as num).toDouble(),
    );
  }
}
