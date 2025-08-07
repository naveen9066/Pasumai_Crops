import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/app_localizations.dart';
import 'admin/farmer_approval_page.dart';
import 'admin/supplement_orders_page.dart';
import 'login_page.dart';

class AdminDashboardPage extends StatelessWidget {
  final Function(Locale) onLocaleChange;

  const AdminDashboardPage({super.key, required this.onLocaleChange});

  Widget _buildDashboardCard(String Function() titleBuilder, IconData icon,
      Widget page, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.green),
              const SizedBox(height: 10),
              Text(
                titleBuilder(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all local storage
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(onLocaleChange: onLocaleChange),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.translate('admin_dashboard')),
        backgroundColor: const Color.fromARGB(255, 192, 255, 202),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: local.translate('logout'),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _buildDashboardCard(
              () => local.translate('farmer_approvals'),
              Icons.verified_user,
              FarmerApprovalPage(onLocaleChange: onLocaleChange),
              context),
          _buildDashboardCard(
              () => local.translate('supplement_orders'),
              Icons.shopping_cart,
              SupplementOrdersPage(onLocaleChange: onLocaleChange),
              context),
        ],
      ),
    );
  }
}
