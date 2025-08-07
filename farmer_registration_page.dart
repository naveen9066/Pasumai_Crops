import 'dart:convert';
import 'package:crop_frontend/widgets/language_switcher.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:crop_frontend/localization/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FarmerRegistrationPage extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const FarmerRegistrationPage({super.key, required this.onLocaleChange});

  @override
  State<FarmerRegistrationPage> createState() => _FarmerRegistrationPageState();
}

class _FarmerRegistrationPageState extends State<FarmerRegistrationPage> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController =
      TextEditingController(); // 👈 Address controller added

  XFile? _aadharCard;
  XFile? _landRecord;
  XFile? _profilePic;
  XFile? _rationCard;

  final picker = ImagePicker();

  Future<void> _pickImage(Function(XFile) setImage) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setImage(XFile(picked.path));
    }
  }

  Future<void> _submitRegistration() async {
    if (_nameController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context).translate('fill_all_fields')),
        ),
      );
      return;
    }

    if (_aadharCard == null ||
        _landRecord == null ||
        _profilePic == null ||
        _rationCard == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context).translate('upload_all_documents')),
        ),
      );
      return;
    }

    final baseUrl = dotenv.env['BASE_URL']!;
    final uri = Uri.parse('$baseUrl/api/farmer/register');

    final requestBody = {
      'name': _nameController.text,
      'mobile': _mobileController.text,
      'address': _addressController.text, // 👈 Include address
      'aadharCard': await _fileToBase64(_aadharCard!),
      'landRecord': await _fileToBase64(_landRecord!),
      'profilePic': await _fileToBase64(_profilePic!),
      'rationCard': await _fileToBase64(_rationCard!),
    };

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WaitingApprovalPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context).translate('registration_failed')),
        ),
      );
    }
  }

  Future<String> _fileToBase64(XFile file) async {
    final bytes = await file.readAsBytes();
    return "data:image/jpeg;base64,${base64Encode(bytes)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text(
          AppLocalizations.of(context).translate('register'),
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: LanguageSwitcher(onLocaleChange: widget.onLocaleChange),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Text(
                AppLocalizations.of(context).translate('register'),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Full Name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).translate('full_name'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),

            // Mobile Number
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context).translate('mobile_number'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 20),

            // Address
            TextField(
              controller: _addressController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).translate('address'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.home),
              ),
            ),
            const SizedBox(height: 20),

            // Document Uploads
            _buildImageUpload(
                AppLocalizations.of(context).translate('aadhar_card'),
                _aadharCard, (file) {
              setState(() => _aadharCard = file);
            }),
            _buildImageUpload(
                AppLocalizations.of(context).translate('land_record'),
                _landRecord, (file) {
              setState(() => _landRecord = file);
            }),
            _buildImageUpload(
                AppLocalizations.of(context).translate('profile_picture'),
                _profilePic, (file) {
              setState(() => _profilePic = file);
            }),
            _buildImageUpload(
                AppLocalizations.of(context).translate('ration_card'),
                _rationCard, (file) {
              setState(() => _rationCard = file);
            }),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _submitRegistration,
                child: Text(
                  AppLocalizations.of(context).translate('submit'),
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUpload(
      String label, XFile? file, Function(XFile) setImage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(setImage),
                  child: Text(
                    AppLocalizations.of(context).translate('upload_image'),
                  ),
                ),
                const SizedBox(width: 10),
                if (file != null)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WaitingApprovalPage extends StatelessWidget {
  const WaitingApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.lightGreen,
          title:
              Text(AppLocalizations.of(context).translate("waiting_approval")),
        ),
        body: Center(
          child: Text(
            AppLocalizations.of(context).translate("waiting_message"),
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
