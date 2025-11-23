class Rating {
  final int id;
  final String menuName;
  final int rating;

  Rating({
    required this.id,
    required this.menuName,
    required this.rating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: int.parse(json['id'].toString()),
      menuName: json['menu_name'],
      rating: int.parse(json['rating'].toString()),
    );
  }
}
