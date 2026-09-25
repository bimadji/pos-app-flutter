import 'item.dart';

class TableOrder {
  final int tableNumber;
  final String customerEmail;
  List<Item> items;
  String status;

  TableOrder({
    required this.tableNumber,
    required this.customerEmail,
    required this.items,
    this.status = "waiting",
  });

  String get safeStatus => status.isNotEmpty ? status : "waiting";

  set safeStatus(String v) {
    status = v.isNotEmpty ? v : "waiting";
  }

  int get total =>
      items.fold(0, (sum, item) => sum + (item.price * item.qty));
}
