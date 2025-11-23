import 'package:flutter/material.dart';
import '../../core/services/auth_services.dart';
import '../admin/dashboard_screen.dart';
import '../cashier/order_page.dart';
import '../auth/reset_password_screen.dart';
import '../auth/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _loading = false; // loading indicator

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _attemptLogin() async {
    final u = usernameController.text.trim();
    final p = passwordController.text;

    if (u.isEmpty || p.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final authService = AuthService();
      final result = await authService.login(u, p);

      setState(() => _loading = false);

      if (result['success'] == true) {
        final role = result['role'];
        Widget targetScreen;

        switch (role) {
          case 'admin':
            targetScreen = const DashboardScreen();
            break;
          case 'kasir':
            targetScreen = const OrderPage();
            break;
          default:
            targetScreen = const DashboardScreen();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => targetScreen),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Invalid credentials')),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildLoginUI(context),
          if (_loading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildLoginUI(BuildContext context) {
    // **UI sama persis seperti versi lama**
    return Container(
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
              const SizedBox(height: 36),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.restaurant_menu,
                    color: Colors.white, size: 48),
              ),
              const SizedBox(height: 16),
              const Text(
                'POS Food & Beverages',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Sign in to your employee account',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),
              _buildLoginCard(context),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Text(
              'Welcome Back!',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text(
              'Please sign in to continue',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: _togglePasswordVisibility,
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (val) {
                      setState(() {
                        _rememberMe = val ?? false;
                      });
                    },
                  ),
                  const Text("Remember me"),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ResetPasswordScreen()),
                  );
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: _attemptLogin,
              child: const Text(
                "SIGN IN",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("OR"),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/images/google.png',
                    width: 36,
                    height: 36,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/images/facebook.png',
                    width: 36,
                    height: 36,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don’t have an account? "),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SignUpScreen()),
                  );
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
