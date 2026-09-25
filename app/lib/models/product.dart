class Product {
  final int id;
  final String name;
  final String category;
  final int price; // tetap int
  final int stock;
  final int sold;
  final String? image;     // nullable
  final String createdAt;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.sold,
    this.image,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"] as int,
      name: json["name"] ?? '',
      category: json["category"] ?? '',
      price: json["price"] as int,
      stock: json["stock"] as int,
      sold: json["sold"] ?? 0,
      image: json["image"],                // ini harus ada di json
      createdAt: json["created_at"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.toString(),
      "name": name,
      "category": category,
      "price": price.toString(),
      "stock": stock.toString(),
      "sold": sold.toString(),
      "image": image ?? '',
      "created_at": createdAt,
    };
  }

  Product copyWith({
    int? id,
    String? name,
    String? category,
    int? price,
    int? stock,
    int? sold,
    String? image,
    String? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      sold: sold ?? this.sold,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
