// lib/utils/format_currency.dart
import 'package:intl/intl.dart';

final NumberFormat _formatter = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

String formatCurrency(int value) {
  return _formatter.format(value);
}
