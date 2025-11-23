import 'package:flutter/material.dart';
import '../../core/services/auth_services.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = AuthService();
  final _username = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  String _selectedRole = "Kasir";

  final List<String> roles = [
    "Kasir",
    "Manager",
    "Cleaning",
    "Chef",
    "Waiter/Waitress",
  ];

  bool _loading = false;

  Future<void> _submit() async {
    if (_username.text.isEmpty ||
        _name.text.isEmpty ||
        _email.text.isEmpty ||
        _password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    setState(() => _loading = true);

    final res = await _auth.register(
      _username.text,
      _name.text,
      _email.text,
      _password.text,
      _selectedRole,
    );

    setState(() => _loading = false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(res['success'] ? "Success" : "Failed"),
        content: Text(res['message']),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (res['success']) Navigator.pop(context);
            },
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFA726), Color(0xFFFF9800)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 32),

                /// ICON LOGO
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.person_add,
                      color: Colors.white, size: 48),
                ),

                const SizedBox(height: 16),
                const Text(
                  "Create New Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 28),

                /// CARD PUTIH
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // USERNAME
                      TextField(
                        controller: _username,
                        decoration: const InputDecoration(
                          labelText: "Username",
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // NAME
                      TextField(
                        controller: _name,
                        decoration: const InputDecoration(
                          labelText: "Full Name",
                          prefixIcon: Icon(Icons.badge_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // EMAIL
                      TextField(
                        controller: _email,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // PASSWORD
                      TextField(
                        controller: _password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // DROPDOWN ROLE
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        items: roles
                            .map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(r),
                        ))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedRole = v!),
                        decoration: const InputDecoration(
                          labelText: "Role",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.group_outlined),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // BUTTON SIGN UP
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: _loading ? null : _submit,
                          child: _loading
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : const Text(
                            "SIGN UP",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// BACK TO LOGIN
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
