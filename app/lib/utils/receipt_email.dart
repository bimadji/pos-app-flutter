String generateReceiptHtml({
  required String customerName,
  required String customerEmail,
  required int tableNumber,
  required List<Map<String, dynamic>> items,
}) {
  int totalHarga = 0;

  // Hitung total pakai parsing agar aman
  for (final item in items) {
    final price = int.tryParse(item['price'].toString()) ?? 0;
    final qty   = int.tryParse(item['qty'].toString()) ?? 0;
    totalHarga += price * qty;
  }

  String itemsHtml = '';
  for (final item in items) {
    final price = int.tryParse(item['price'].toString()) ?? 0;
    final qty   = int.tryParse(item['qty'].toString()) ?? 0;
    final subtotal = price * qty;

    itemsHtml += '''
      <tr>
        <td style="padding: 4px 0;">${item['name']}</td>
        <td style="text-align: center;">x$qty</td>
        <td style="text-align: right;">Rp $subtotal</td>
      </tr>
    ''';
  }

  return '''
  <html>
    <body style="font-family: Arial, sans-serif; background-color: #fff8f0; padding: 20px;">
      <div style="max-width: 360px; margin: auto; background-color: #ffffff; padding: 16px; border-radius: 16px; border: 1px solid #ddd;">
        <h2 style="text-align: center; margin-bottom: 4px;">POS KAFE ORANGE</h2>
        <p style="text-align: center; font-size: 11px; color: grey;">Jl. Jalan No. 123, Surabaya</p>
        <hr/>

        <p>Meja: $tableNumber<br/>
        Email: $customerEmail<br/>
        Nama: $customerName<br/>
        Tanggal: ${DateTime.now()}</p>
        <hr/>

        <table width="100%" style="border-collapse: collapse; font-size: 13px;">
          $itemsHtml
        </table>
        <hr/>
        <p style="text-align: right; font-weight: bold;">TOTAL: Rp $totalHarga</p>
        <hr/>
        <p style="text-align: center; font-size: 12px;">Terima kasih sudah berkunjung!</p>
      </div>
    </body>
  </html>
  ''';
}
