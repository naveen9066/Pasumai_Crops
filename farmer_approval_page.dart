import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:crop_frontend/widgets/language_switcher.dart';
import 'package:crop_frontend/localization/app_localizations.dart';

class Farmer {
  final String id;
  final String? name;
  final String? mobile;
  final String? address;
  final String? aadharUrl;
  final String? landRecordUrl;
  final String? rationCardUrl;

  Farmer({
    required this.id,
    this.name,
    this.mobile,
    this.address,
    this.aadharUrl,
    this.landRecordUrl,
    this.rationCardUrl,
  });

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      id: json['farmer_id'] ?? '',
      name: json['name'],
      mobile: json['mobile_number'],
      address: json['address'],
      aadharUrl: json['aadhar_image_url'],
      landRecordUrl: json['land_record_url'],
      rationCardUrl: json['ration_card_url'],
    );
  }
}

class FarmerApprovalPage extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const FarmerApprovalPage({super.key, required this.onLocaleChange});

  @override
  State<FarmerApprovalPage> createState() => _FarmerApprovalPageState();
}

class _FarmerApprovalPageState extends State<FarmerApprovalPage> {
  late Future<List<Farmer>> farmers;

  @override
  void initState() {
    super.initState();
    farmers = fetchPendingFarmers();
  }

  Future<List<Farmer>> fetchPendingFarmers() async {
    final baseUrl = dotenv.env['BASE_URL']!;
    final response = await http.get(Uri.parse('$baseUrl/api/farmer/pending'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => Farmer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load farmers');
    }
  }

  Future<void> approveFarmer(String id) async {
    final baseUrl = dotenv.env['BASE_URL']!;
    final response =
        await http.put(Uri.parse('$baseUrl/api/farmer/approve/$id'));
    if (response.statusCode == 200) {
      setState(() {
        farmers = fetchPendingFarmers();
      });
    }
  }

  Future<void> rejectFarmer(String id) async {
    final baseUrl = dotenv.env['BASE_URL']!;
    final response =
        await http.delete(Uri.parse('$baseUrl/api/farmer/reject/$id'));
    if (response.statusCode == 200) {
      setState(() {
        farmers = fetchPendingFarmers();
      });
    }
  }

  Widget buildDetail(String? label, String? value, {bool isImage = false}) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();
    if (isImage) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label!, style: const TextStyle(fontWeight: FontWeight.bold)),
          Image.network(value,
              errorBuilder: (_, __, ___) =>
                  Text(AppLocalizations.of(context)!.translate('not_found'))),
          const SizedBox(height: 15),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(value, style: const TextStyle(fontSize: 16)),
      );
    }
  }

  void showFarmerDetails(Farmer farmer, AppLocalizations local) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(local.translate('farmer_details'),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (farmer.name != null && farmer.name!.isNotEmpty)
                Text("👤 ${farmer.name}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              if (farmer.mobile != null && farmer.mobile!.isNotEmpty)
                Text("📱 ${farmer.mobile}",
                    style: const TextStyle(fontSize: 16)),
              if (farmer.address != null && farmer.address!.isNotEmpty)
                Text("🏠 ${farmer.address}",
                    style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 15),
              buildDetail(local.translate('aadhar_image'), farmer.aadharUrl,
                  isImage: true),
              buildDetail(local.translate('land_record'), farmer.landRecordUrl,
                  isImage: true),
              buildDetail(local.translate('ration_card'), farmer.rationCardUrl,
                  isImage: true),
            ],
          ),
        ),
        actions: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // Background color
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(local.translate('close'),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                approveFarmer(farmer.id);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Background color
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(local.translate('approve'),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                rejectFarmer(farmer.id);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Background color
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(local.translate('reject'),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.translate('farmer_approvals'),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 192, 255, 202),
        actions: [
          LanguageSwitcher(onLocaleChange: widget.onLocaleChange),
        ],
      ),
      body: FutureBuilder<List<Farmer>>(
        future: farmers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(local.translate('no_pending_farmers')));
          }

          final farmerList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: farmerList.length,
            itemBuilder: (context, index) {
              final farmer = farmerList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(farmer.name ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(farmer.mobile ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: TextButton(
                    onPressed: () => showFarmerDetails(farmer, local),
                    child: Text(local.translate('view'),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
