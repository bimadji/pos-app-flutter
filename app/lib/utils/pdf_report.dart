import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/product.dart';
import '../models/sales_record.dart';
import '../core/services/rating_service.dart';
import '../models/rating.dart';

Future<void> exportSalesReportPDF({
  required List<Product> products,
  required List<SalesRecord> salesHistory,
}) async {
  // =========================================
  //  LOAD FONT UNICODE
  // =========================================
  final fontRegularData =
  await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
  final fontBoldData =
  await rootBundle.load("assets/fonts/NotoSans-Bold.ttf");

  final ttfRegular = pw.Font.ttf(fontRegularData);
  final ttfBold = pw.Font.ttf(fontBoldData);

  final pdf = pw.Document();

  // =========================================
  //  GET RATING FROM API
  // =========================================
  final List<Rating> ratings = await RatingService().getAllRatings();

  DateTime now = DateTime.now();

  // =========================================
  //  PENJUALAN BERDASARKAN STOK DATABASE
  // =========================================
  const int initialStock = 50; // stok awal berdasarkan SQL dump kamu

  Map<int, int> totalSold = {};

  for (var p in products) {
    totalSold[p.id] = initialStock - p.stock; // ★★ perhitungan diminta ★★
  }

  // Sort untuk produk terlaris
  final sortedByStok = totalSold.entries.toList()
    ..sort((b, a) => a.value.compareTo(b.value));

  // =========================================
  //  HITUNG RATA-RATA RATING
  // =========================================
  Map<String, List<int>> ratingMap = {};

  for (var r in ratings) {
    ratingMap[r.menuName] ??= [];
    ratingMap[r.menuName]!.add(r.rating);
  }

  final avgRatings = ratingMap.entries.map((e) {
    final avg = e.value.reduce((a, b) => a + b) / e.value.length;
    return {"name": e.key, "avg": avg};
  }).toList();

  avgRatings.sort((b, a) {
    final double aAvg = ((a["avg"] ?? 0) as num).toDouble();
    final double bAvg = ((b["avg"] ?? 0) as num).toDouble();
    return bAvg.compareTo(aAvg);
  });

  final highest = avgRatings.isNotEmpty ? avgRatings.first : null;
  final lowest = avgRatings.isNotEmpty ? avgRatings.last : null;

  // =========================================
  //  BUILD PDF PAGE
  // =========================================
  pdf.addPage(
    pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: ttfRegular,
        bold: ttfBold,
        fontFallback: [ttfRegular],
      ),
      build: (context) => [
        pw.Center(
          child: pw.Text(
            "Laporan Penjualan",
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),

        pw.SizedBox(height: 20),
        pw.Text("Tanggal: ${now.toString().substring(0, 16)}"),
        pw.SizedBox(height: 25),

        pw.Text(
          "Total Penjualan",
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Table.fromTextArray(
          headers: ["Produk", "Terjual"],
          data: products.map((p) {
            final sold = totalSold[p.id] ?? 0;
            return [p.name, sold.toString()];
          }).toList(),
        ),

        pw.SizedBox(height: 30),

        pw.Text(
          "Produk Terlaris",
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),

        if (sortedByStok.isNotEmpty)
              () {
            final best = sortedByStok.first;       // ⬅ Ambil satu teratas
            final bestProduct =
            products.firstWhere((p) => p.id == best.key);

            return pw.Container(
              padding: pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    bestProduct.name,
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text("Terjual: ${best.value}"),
                ],
              ),
            );
          }()
        else
          pw.Text("Tidak ada data produk"),


        pw.SizedBox(height: 30),

        // =========================================
        //  RATING
        // =========================================
        pw.Text(
          "Rating Produk (Dari Customer)",
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),

        if (highest != null)
          pw.Text(
            "⭐ Tertinggi: ${highest["name"]} — ${(((highest["avg"] ?? 0) as num).toDouble()).toStringAsFixed(2)} / 5",
            style: pw.TextStyle(fontSize: 14),
          ),

        pw.SizedBox(height: 5),

        if (lowest != null)
          pw.Text(
            "⬇ Terendah: ${lowest["name"]} — ${(((lowest["avg"] ?? 0) as num).toDouble()).toStringAsFixed(2)} / 5",
            style: pw.TextStyle(fontSize: 14),
          ),
      ],
    ),
  );

  // EXPORT PDF
  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename: "laporan_penjualan.pdf",
  );
}
