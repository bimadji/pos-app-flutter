import 'package:flutter/material.dart';
import 'package:app/core/services/auth_services.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  Future<void> _submitReset() async {
    final username = usernameController.text.trim();
    final newPass = passwordController.text.trim();

    if (username.isEmpty || newPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi username dan password baru")),
      );
      return;
    }

    setState(() => loading = true);

    final auth = AuthService();
    final result = await auth.resetPassword(username, newPass);

    setState(() => loading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password berhasil diubah")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 22),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  )
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Reset Password",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password Baru",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: loading ? null : _submitReset,
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "RESET PASSWORD",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
