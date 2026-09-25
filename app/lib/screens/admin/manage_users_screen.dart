import 'package:flutter/material.dart';
import 'package:app/models/user.dart';
import 'edit_user_screen.dart';

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
    final usernameController = TextEditingController();
    final roleController = TextEditingController();
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Tambah Karyawan Baru"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama"),
              ),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: "Role"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (usernameController.text.isEmpty ||
                  roleController.text.isEmpty) {
                return;
              }

              final newUser = AppUser(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                username: usernameController.text,
                email: emailController.text,
                name: nameController.text,
                role: roleController.text,
              );

              addUser(newUser);
              Navigator.pop(ctx);
            },
            child: const Text("Tambah"),
          ),
        ],
      ),
    );
  }


  // ==================== BUILD UI ==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Karyawan", style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF4CAF50),
        foregroundColor: Colors.black87,
        elevation: 0,
      ),

      backgroundColor: const Color(0xFFE8F5E9),

      body: Column(
        children: [
          Expanded(
            child: users.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada karyawan",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 15,
                          ),
                          leading: const CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.person, color: Colors.white),
                          ),

                          title: Text(
                            user.name.isEmpty ? user.username : user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          subtitle: Text(
                            "${user.role} • ${user.email}",
                            style: const TextStyle(color: Colors.black54),
                          ),

                          // ============= EDIT + DELETE BUTTONS =============
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditUserScreen(
                                        user: user,
                                        onUpdate: (updatedUser) {
                                          // Update user di list
                                          final index = users.indexWhere(
                                            (u) => u.id == updatedUser.id,
                                          );
                                          if (index != -1) {
                                            users[index] = updatedUser;
                                          }

                                          (context as Element).markNeedsBuild();
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  removeUser(user.id);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Karyawan "${user.name}" dihapus.',
                                      ),
                                    ),
                                  );
                                },
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

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddUserDialog(context),
      ),
    );
  }
}
