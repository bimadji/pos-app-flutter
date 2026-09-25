import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../utils/pdf_report.dart';
import '../../models/sales_record.dart';

class ViewReportsScreen extends StatelessWidget {
  final int totalProducts;
  final int lowStockCount;
  final int totalUsers;
  final List<Product> products;

  const ViewReportsScreen({
    super.key,
    required this.totalProducts,
    required this.lowStockCount,
    required this.totalUsers,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    List<Product> localProducts = List.from(products);
    List<SalesRecord> salesHistory = [];


    if (localProducts.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Laporan Penjualan")),
        body: const Center(child: Text("Belum ada data produk")),
      );
    }
    bool allZero = localProducts.every((p) => p.sold == 0);

    // =============== sort produk berdasarkan terjual ===============
    localProducts.sort((a, b) => b.sold.compareTo(a.sold));

    final Product mostSold = localProducts.first;
    final Product? leastSold = localProducts.length > 1
        ? localProducts.last
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Penjualan", style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // info cards
            _infoCard(
              title: "Total Produk",
              value: "$totalProducts",
              icon: Icons.inventory,
            ),
            _infoCard(
              title: "Produk Stok Rendah",
              value: "$lowStockCount",
              icon: Icons.warning_amber,
            ),
            _infoCard(
              title: "Total Karyawan",
              value: "$totalUsers",
              icon: Icons.people,
            ),

            const SizedBox(height: 20),
            //
            // if (allZero)
            //   _reportTile(
            //     title: "Belum Ada Penjualan",
            //     productName: "-",
            //     value: "0",
            //     color: Colors.grey,
            //   )
            // else ...[
            //   _reportTile(
            //     title: "Produk Terlaris",
            //     productName: mostSold.name,
            //     value: "${mostSold.sold} Terjual",
            //     color: Colors.green,
            //   ),
            //
            //   const SizedBox(height: 12),
            //
            //   if (leastSold != null)
            //     _reportTile(
            //       title: "Paling Sedikit Terjual",
            //       productName: leastSold.name,
            //       value: "${leastSold.sold} Terjual",
            //       color: Colors.red,
            //     ),
            // ],
            ElevatedButton(
              onPressed: () {
                exportSalesReportPDF(
                  products: products, // data produk dikirim ke PDF
                  salesHistory: salesHistory, // data histori penjualan
                );
              },
              child: Text("Export PDF"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0x33000000),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.blue),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16)),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reportTile({
    required String title,
    required String productName,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.4), width: 2),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(Icons.bar_chart, size: 32, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(productName),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
