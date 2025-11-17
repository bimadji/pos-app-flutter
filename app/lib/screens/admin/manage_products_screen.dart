import 'package:flutter/material.dart';
import 'package:app/models/product.dart';

typedef AddProductCallback = void Function(Product product);
typedef RemoveProductCallback = void Function(String id);

class ManageProductsScreen extends StatefulWidget {
  final List<Product> products;
  final AddProductCallback addProduct;
  final RemoveProductCallback removeProduct;

  const ManageProductsScreen({
    super.key,
    required this.products, 
    required this.addProduct, 
    required this.removeProduct, 
  });

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  void _addProduct() {
    final name = _nameController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final stock = int.tryParse(_stockController.text) ?? 0;

    if (name.isEmpty || price <= 0 || stock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pastikan semua field terisi dengan benar.')),
      );
      return;
    }

    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      name: name,
      price: price,
      stock: stock,
    );
    
    // 1. Panggil fungsi callback (Update State di DashboardScreen)
    widget.addProduct(newProduct); 

    // Reset fields
    _nameController.clear();
    _priceController.clear();
    _stockController.clear();
    
    // 2. Update State LOKAL (FIX BUG: Memastikan list di layar ini langsung update)
    setState(() {}); 

     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Menu "$name" berhasil ditambahkan.')),
      );
  }

  // --- FUNGSI DEKORASI HEADER ---
  Widget _buildDecorativeHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      color: const Color(0xFF2196F3), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.fastfood, color: Colors.white, size: 30), // Ikon FnB
          SizedBox(width: 10),
          Text(
            'Products Management', 
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
        title: const Text('Manajemen Menu'),
        // Warna AppBar diubah agar menyatu dengan dekorasi
        backgroundColor: Colors.white, 
        foregroundColor: Colors.black87,
        elevation: 0, 
      ),
      backgroundColor: const Color(0xFFF0F0F5), 
      body: Column(
        children: <Widget>[
          _buildDecorativeHeader(context), // <--- TAMBAH DEKORASI

          // Bagian Tambah Produk Baru
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tambah Menu Baru',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                ),
                const SizedBox(height: 10),
                _buildTextField('Nama Menu/Produk', _nameController, TextInputType.text),
                _buildTextField('Harga (Rp)', _priceController, TextInputType.number),
                _buildTextField('Stok Awal', _stockController, TextInputType.number),
                ElevatedButton.icon(
                  onPressed: _addProduct,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Tambah Menu'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo, 
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          
          // Daftar Produk
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Menu (${widget.products.length})',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
              ),
            ),
          ),
          
          Expanded(
            child: widget.products.isEmpty
                ? const Center(child: Text('Belum ada menu', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: widget.products.length,
                    itemBuilder: (context, index) {
                      final product = widget.products[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          // Circle Avatar (Ikon Stok)
                          leading: CircleAvatar(
                            backgroundColor: product.stock <= 10 ? Colors.redAccent : Colors.green, 
                            child: Text(product.stock.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('Rp ${product.price.toStringAsFixed(0)}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              widget.removeProduct(product.id);
                              setState(() {}); // FIX BUG: Auto-update setelah hapus
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Menu "${product.name}" dihapus.')),
                                );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
      ),
    );
  }
}