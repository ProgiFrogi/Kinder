class LikedCat {
  final String id;
  final String url;
  final String breed;
  final String description;
  final DateTime likedAt;

  LikedCat({
    required this.id,
    required this.url,
    required this.breed,
    required this.description,
    required this.likedAt,
  }) : super();

  factory LikedCat.fromCat(Map<String, dynamic> cat) {
    return LikedCat(
      id: cat['id'],
      url: cat['url'],
      breed: cat['breeds'][0]['name'],
      description: cat['breeds'][0]['description'],
      likedAt: DateTime.now(),
    );
  }
}
