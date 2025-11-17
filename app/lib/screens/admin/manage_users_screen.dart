import 'package:flutter/material.dart';
import 'package:app/models/user.dart';

typedef AddUserCallback = void Function(AppUser user);
typedef RemoveUserCallback = void Function(String id);

class ManageUsersScreen extends StatelessWidget {
  final List<AppUser> users;
  final AddUserCallback addUser;
  final RemoveUserCallback removeUser;

  const ManageUsersScreen({
    super.key,
    required this.users, 
    required this.addUser, 
    required this.removeUser, 
  });

  void _showAddUserDialog(BuildContext context) {
    final nameController = TextEditingController();
    final roleController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Karyawan Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Karyawan'),
              ),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Jabatan (e.g., Barista, Kasir)'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Batal'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Tambah'),
            onPressed: () {
              if (nameController.text.isNotEmpty && roleController.text.isNotEmpty) {
                final newUser = AppUser(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  role: roleController.text,
                );
                addUser(newUser); 
                Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  // --- FUNGSI DEKORASI HEADER ---
  Widget _buildDecorativeHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      color: const Color(0xFF4CAF50), // Warna hijau konsisten
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.badge, color: Colors.white, size: 30), 
          SizedBox(width: 10),
          Text(
            'Employee Directory',
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
        title: const Text('Manage Karyawan'),
        backgroundColor: Colors.white, 
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFE8F5E9), 
      body: Column( // Diubah menjadi Column untuk menampung dekorasi
        children: [
          _buildDecorativeHeader(context), // <--- TAMBAH DEKORASI

          Expanded( // Expanded agar ListView.builder bisa memenuhi sisa ruang
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: users.length, 
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF4CAF50),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Text(user.role, style: TextStyle(color: Colors.grey[600])),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                      onPressed: () {
                        removeUser(user.id); 
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Karyawan "${user.name}" dihapus.')),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddUserDialog(context),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}