class Item {
  final String name;
  final int price;
  final int qty;

  Item({
    required this.name,
    required this.price,
    required this.qty,
  });

  // Tambahkan ini supaya aman dari null JSON
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'] ?? "",
      price: map['price'] ?? 0,
      qty: map['qty'] ?? 0,
    );
  }
}
