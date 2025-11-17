import 'package:flutter/material.dart';

class ViewReportsScreen extends StatelessWidget {
  final int totalProducts;
  final int lowStockCount;
  final int totalUsers;

  const ViewReportsScreen({
    super.key,
    required this.totalProducts,
    required this.lowStockCount,
    required this.totalUsers,
  });

  // --- FUNGSI DEKORASI HEADER ---
  Widget _buildDecorativeHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      color: const Color(0xFF2196F3), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.assessment, color: Colors.white, size: 30), // Ikon Laporan
          SizedBox(width: 10),
          Text(
            'Laporan & Analisa',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  // --- END FUNGSI DEKORASI ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Penjualan & Inventaris'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFE3F2FD), 
      body: Column( 
        children: <Widget>[
          _buildDecorativeHeader(context), // <--- TAMBAH DEKORASI
          Expanded( 
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  _buildReportCard(
                    context,
                    icon: Icons.restaurant_menu, // <-- ICON FNB
                    title: 'Total Menu',
                    value: totalProducts.toString(), 
                    color: Colors.orange,
                  ),
                  _buildReportCard(
                    context,
                    icon: Icons.kitchen, // <-- ICON FNB (Stok/Bahan Baku)
                    title: 'Item Stok Rendah',
                    value: lowStockCount.toString(), 
                    color: Colors.red,
                  ),
                  _buildReportCard(
                    context,
                    icon: Icons.people,
                    title: 'Total Karyawan',
                    value: totalUsers.toString(), 
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
        required Color color,
      }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: color, width: 6)), 
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 30, color: color),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color
              ),
            ),
          ],
        ),
      ),
    );
  }
}