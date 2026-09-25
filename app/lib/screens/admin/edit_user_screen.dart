import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../core/services/user_service.dart';

class EditUserScreen extends StatefulWidget {
  final AppUser user;
  final Function(AppUser) onUpdate;

  const EditUserScreen({
    super.key,
    required this.user,
    required this.onUpdate,
  });

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController nameC;
  late TextEditingController emailC;
  String? selectedRole;
  bool loading = false;

  final List<String> roles = [
    "kasir",
    "manager",
    "cleaning",
    "chef",
    "waiter/waitress"
  ];

  @override
  void initState() {
    super.initState();
    nameC = TextEditingController(text: widget.user.name);
    emailC = TextEditingController(text: widget.user.email);
    selectedRole = widget.user.role;
  }

  Future<void> saveChanges() async {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Pilih role terlebih dahulu")));
      return;
    }

    setState(() => loading = true);

    final updatedUser = widget.user.copyWith(
      name: nameC.text,
      email: emailC.text,
      role: selectedRole!,
    );

    final res = await UserService().updateUser(updatedUser);

    setState(() => loading = false);

    if (res["success"] == true) {
      widget.onUpdate(updatedUser);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Gagal memperbarui user")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),

      appBar: AppBar(
        title: const Text("Edit Karyawan"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // HEADER HIASAN SAMA SPT SCREEN UTAMA
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, color: Colors.white, size: 25),
                    SizedBox(width: 10),
                    Text(
                      "Edit Data Karyawan",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // CARD UTAMA
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // FIELD NAME
                      TextField(
                        controller: nameC,
                        decoration: InputDecoration(
                          labelText: "Nama Lengkap",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // FIELD EMAIL
                      TextField(
                        controller: emailC,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // DROPDOWN ROLE
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        items: roles.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role.toUpperCase()),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: "Role",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) => setState(() => selectedRole = value),
                      ),

                      const SizedBox(height: 25),

                      // BUTTON SAVE
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: loading ? null : saveChanges,
                          child: loading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                            "Simpan Perubahan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
