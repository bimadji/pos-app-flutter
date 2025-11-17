import 'package:flutter/material.dart';
import 'package:app/screens/auth/login_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EC),
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF9800), Color(0xFFFFC107)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Icon + Subtitle
            Center(
              child: Column(
                children: [
                  const Icon(Icons.restaurant_menu,
                      color: Colors.orange, size: 48),
                  const SizedBox(height: 8),
                  const Text(
                    'Manage your POS system',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Statistic Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('Products', '24', Colors.orange),
                _buildStatCard('Users', '10', Colors.green),
              ],
            ),
            const SizedBox(height: 25),

            // Quick Actions (Grid)
            const Text(
              'Quick Actions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildActionButton('Manage Products', Icons.inventory, Colors.orange),
                _buildActionButton('Manage Users', Icons.people, Colors.green),
                _buildActionButton('View Reports', Icons.bar_chart, Colors.blue),
                _buildActionButton('Settings', Icons.settings, Colors.purple),
              ],
            ),

            const SizedBox(height: 30),
            const Text(
              'Recent Activity',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            // Recent Activities
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.add_box, color: Colors.orange),
                    title: Text('New product added'),
                    subtitle: Text('2 minutes ago'),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.person_add, color: Colors.green),
                    title: Text('User registered'),
                    subtitle: Text('1 hour ago'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Logout', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 8),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.insert_chart, color: color, size: 36),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(count, style: TextStyle(color: color, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 34),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
