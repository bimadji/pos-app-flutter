import 'package:flutter/material.dart';
import 'package:app/models/product.dart';
import '../../core/services/product_service.dart';
import 'edit_product_screen.dart';

typedef AddProductCallback = void Function(Product product);
typedef RemoveProductCallback = void Function(int id);

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
  final _categoryController = TextEditingController();

  final productService = ProductService();

  bool loading = true;

  List<Product> products = [];
  final List<String> _categories = [
    'Appetizer',
    'Main Course',
    'Dessert',
    'Minuman',
  ];

  String? _selectedCategory;


  @override
  void initState() {
    super.initState();
    products = List.from(widget.products); // load awal dari dashboard
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final productsFromDb = await productService.getProducts();

    print("PRODUCTS LOADED: ${productsFromDb.length}");

    setState(() {
      products = productsFromDb; // disimpan di state
      loading = false;
    });
  }

  Future<void> _addProduct() async {
    final name = _nameController.text;
    final category = _categoryController.text;
    final price = int.tryParse(_priceController.text) ?? 0;
    final stock = int.tryParse(_stockController.text) ?? 0;

    if (name.isEmpty || category.isEmpty || price <= 0 || stock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pastikan semua field terisi dengan benar.'),
        ),
      );
      return;
    }

    final newProduct = Product(
      id: 0,
      name: name,
      category: category,
      price: price,
      stock: stock,
      sold: 0,
      createdAt: DateTime.now().toIso8601String(),
    );

    bool success = await productService.addProduct(newProduct);

    if (success) {
      widget.addProduct(newProduct); // update dashboard
      await _loadProducts();

      _nameController.clear();
      _priceController.clear();
      _stockController.clear();
      _categoryController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Menu "$name" berhasil ditambahkan.')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menambahkan menu.')));
    }
  }

  Future<void> _deleteProduct(int id, String productName) async {
    bool success = await productService.deleteProduct(id);

    if (success) {
      widget.removeProduct(id);
      await _loadProducts();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Menu "$productName" berhasil dihapus.')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menghapus menu.')));
    }
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller,
    TextInputType type,
  ) {
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Produk'),
        backgroundColor: Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF0F0F5),
      body: Column(
        children: <Widget>[
          // Tambah produk section
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tambah Menu Baru',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  'Nama Menu/Produk',
                  _nameController,
                  TextInputType.text,
                ),
                _buildTextField(
                  'Harga (Rp)',
                  _priceController,
                  TextInputType.number,
                ),
                _buildTextField(
                  'Stok Awal',
                  _stockController,
                  TextInputType.number,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      hintText: 'Pilih Kategori',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                    ),
                    items: _categories
                        .map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: _addProduct,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Tambah Menu'),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Menu (${products.length})', // FIXED
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                ? const Center(child: Text('Belum ada menu'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: product.stock <= 10
                                ? Colors.redAccent
                                : Colors.green,
                            child: Text(
                              product.stock.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(product.name),
                          subtitle: Text('Rp ${product.price}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Tombol Edit
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProductScreen(
                                        product: products[index],
                                        onUpdate: (updatedProduct) async {
                                          bool success = await productService.updateProduct(updatedProduct);

                                          if (success) {
                                            setState(() {
                                              products[index] = updatedProduct;
                                            });

                                            await _loadProducts();

                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Produk berhasil diperbarui.")),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Gagal memperbarui produk.")),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },

                              ),

                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteProduct(
                                  products[index].id!,
                                  products[index].name,
                                ),
                              ),
                            ],
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
}
