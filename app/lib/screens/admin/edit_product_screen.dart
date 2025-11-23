import 'package:flutter/material.dart';
import '../../models/product.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;
  final Function(Product) onUpdate;

  const EditProductScreen({
    super.key,
    required this.product,
    required this.onUpdate,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController nameC;
  late TextEditingController priceC;
  late TextEditingController stockC;
  late TextEditingController categoryC;

  @override
  void initState() {
    super.initState();
    nameC = TextEditingController(text: widget.product.name);
    categoryC = TextEditingController(text: widget.product.category);
    priceC = TextEditingController(text: widget.product.price.toString());
    stockC = TextEditingController(text: widget.product.stock.toString());
  }

  Widget _buildTextField(String label, TextEditingController c, TextInputType t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: t,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F5),

      appBar: AppBar(
        title: const Text("Edit Menu"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),

      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: const Color(0xFF2196F3),
            child: const Center(
              child: Text(
                "Edit Menu Produk",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detail Produk",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    _buildTextField("Nama Menu", nameC, TextInputType.text),
                    _buildTextField("Kategori", categoryC, TextInputType.text),
                    _buildTextField("Harga (Rp)", priceC, TextInputType.number),
                    _buildTextField("Stok", stockC, TextInputType.number),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text(
                          "Simpan Perubahan",
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFF2196F3),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          final updatedProduct = widget.product.copyWith(
                            name: nameC.text,
                            category: categoryC.text,
                            price: int.parse(priceC.text),
                            stock: int.parse(stockC.text),
                          );

                          widget.onUpdate(updatedProduct);
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
