import 'package:crop_frontend/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../localization/app_localizations.dart';
import 'farmer/crop_diagnosis_page.dart';
import 'farmer/supplements_page.dart';
import 'farmer/agri_calendar_page.dart';
import 'farmer/market_info_page.dart';
import 'farmer/birds_alert_page.dart';
import 'farmer/profile_page.dart';

class Farmer {
  final String farmerId;
  final String name;
  final String mobileNumber;
  final String profilePictureUrl;

  Farmer({
    required this.farmerId,
    required this.name,
    required this.mobileNumber,
    required this.profilePictureUrl,
  });

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      farmerId: json['farmer_id'] ?? '',
      name: json['name'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      profilePictureUrl: json['profile_picture_url'] ?? '',
    );
  }
}

class FarmerHomePage extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  const FarmerHomePage({super.key, required this.onLocaleChange});

  @override
  State<FarmerHomePage> createState() => _FarmerHomePageState();
}

class _FarmerHomePageState extends State<FarmerHomePage> {
  Farmer? farmer;
  bool isLoading = true;
  final String flashNewsUrl =
      "https://www.vikatan.com/agriculture"; // Update this with the URL you want

  @override
  void initState() {
    super.initState();
    _loadFarmerData();
  }

  void flashnews() async {
    final url = flashNewsUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all local storage
    widget.onLocaleChange(const Locale('en')); // Reset locale if needed
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(onLocaleChange: widget.onLocaleChange),
      ),
      (route) => false,
    );
  }

  Future<void> _loadFarmerData() async {
    final prefs = await SharedPreferences.getInstance();
    String? farmerId = prefs.getString('farmer_id');
    if (farmerId != null) {
      final baseUrl = dotenv.env['BASE_URL'];
      try {
        final response = await http
            .get(Uri.parse('$baseUrl/api/farmer/farmerdata/$farmerId'));
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          setState(() {
            farmer = Farmer.fromJson(jsonData);
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context)!.translate('farmer_dashboard')),
        backgroundColor: Color.fromARGB(255, 192, 255, 202),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProfilePage(onLocaleChange: widget.onLocaleChange),
                  ),
                );
              },
              child: Row(
                children: [
                  Text(
                    farmer?.name ?? '',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: farmer?.profilePictureUrl != null &&
                            farmer!.profilePictureUrl.isNotEmpty
                        ? NetworkImage(farmer!.profilePictureUrl)
                        : const AssetImage('images/profile.jpg')
                            as ImageProvider,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: local.translate('logout'),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      flashnews();
                    },
                    child: Container(
                      height: 40.0,
                      child: Marquee(
                        text: AppLocalizations.of(context)!
                            .translate('flash_news'),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        scrollAxis: Axis.horizontal,
                        blankSpace: 20.0,
                        velocity: 50.0,
                      ),
                    ),
                  ),
                ),
                // Wrap the GridView in an Expanded widget
                Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.all(16),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildDashboardCard(
                        AppLocalizations.of(context)!
                            .translate('crop_diagnosis'),
                        Icons.camera,
                        CropDiagnosisPage(
                          onLocaleChange: widget.onLocaleChange,
                        ),
                      ),
                      _buildDashboardCard(
                          AppLocalizations.of(context)!
                              .translate('supplements'),
                          Icons.local_florist,
                          SupplementsPage()),
                      _buildDashboardCard(
                          AppLocalizations.of(context)!
                              .translate('agri_calendar'),
                          Icons.calendar_today,
                          AgriCalendarPage(
                            onLocaleChange: widget.onLocaleChange,
                          )),
                      _buildDashboardCard(
                          AppLocalizations.of(context)!
                              .translate('market_info'),
                          Icons.store,
                          MarketInfoPage(
                              onLocaleChange: widget.onLocaleChange)),
                      _buildDashboardCard(
                          AppLocalizations.of(context)!
                              .translate('birds_alert'),
                          Icons.pets,
                          BirdsAlertPage(
                              onLocaleChange: widget.onLocaleChange)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDashboardCard(String title, IconData icon, Widget page,
      {String? subtitle}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        color: Colors.green.shade50,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.green),
              const SizedBox(height: 10),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;
  WebViewPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News Detail')),
      body: Center(child: Text('Open Webview for $url')),
    );
  }
}
