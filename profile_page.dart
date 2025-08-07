import 'dart:typed_data';
import 'package:crop_frontend/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  const ProfilePage({super.key, required this.onLocaleChange});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;

  String name = '';
  String mobileNumber = '';
  String address = '';
  String farmerId = '';
  String profileUrl = '';
  String aadharUrl = '';
  String rationUrl = '';
  String landUrl = '';

  Uint8List? selectedProfileImageBytes;
  Uint8List? selectedAadharImageBytes;
  Uint8List? selectedRationImageBytes;
  Uint8List? selectedLandImageBytes;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFarmerProfile();
  }

  Future<void> _updateProfile() async {
    final baseUrl = dotenv.env['BASE_URL'];
    final prefs = await SharedPreferences.getInstance();
    final farmerIdLocal = prefs.getString('farmer_id');

    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty || mobile.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!
                .translate('profile_fields_required'))),
      );
      return;
    }

    setState(() => isLoading = true);

    // Helper: Convert image bytes to base64
    String? toBase64(Uint8List? bytes) =>
        bytes != null ? "data:image/jpeg;base64,${base64Encode(bytes)}" : null;

    final Map<String, dynamic> requestBody = {
      "name": name,
      "mobile_number": mobile,
      "address": address,
      "profile_picture_url": selectedProfileImageBytes != null
          ? toBase64(selectedProfileImageBytes)
          : profileUrl,
      "aadhar_image_url": selectedAadharImageBytes != null
          ? toBase64(selectedAadharImageBytes)
          : aadharUrl,
      "ration_card_url": selectedRationImageBytes != null
          ? toBase64(selectedRationImageBytes)
          : rationUrl,
      "land_record_url": selectedLandImageBytes != null
          ? toBase64(selectedLandImageBytes)
          : landUrl,
      "status": "pending" // Or keep unchanged if not updating
    };

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/farmer/farmerdata/$farmerIdLocal'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .translate('profile_updated_success'))),
        );
        _loadFarmerProfile(); // reload to refresh updated data
      } else {
        debugPrint('Failed to update profile: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .translate('profile_update_failed'))),
        );
      }
    } catch (e) {
      debugPrint('Update error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)!.translate('error_occurred'))),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadFarmerProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final farmerIdLocal = prefs.getString('farmer_id');
    final baseUrl = dotenv.env['BASE_URL'];

    if (farmerIdLocal != null && baseUrl != null) {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/api/farmer/farmerdata/$farmerIdLocal'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            name = data['name'] ?? '';
            mobileNumber = data['mobile_number'] ?? '';
            address = data['address'] ?? '';
            profileUrl = data['profile_picture_url'] ?? '';
            aadharUrl = data['aadhar_image_url'] ?? '';
            rationUrl = data['ration_card_url'] ?? '';
            landUrl = data['land_record_url'] ?? '';
            farmerId = data['farmer_id'] ?? '';

            _nameController.text = name;
            _mobileController.text = mobileNumber;
            _addressController.text = address;
            isLoading = false;
          });
        } else {
          debugPrint("Failed to fetch profile data: ${response.statusCode}");
          setState(() => isLoading = false);
        }
      } catch (e) {
        debugPrint("Error fetching profile: $e");
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _selectImage(Function(Uint8List) onImagePicked) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      onImagePicked(bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('edit_profile')),
        backgroundColor: const Color.fromARGB(255, 192, 255, 202),
        automaticallyImplyLeading: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: selectedProfileImageBytes != null
                            ? MemoryImage(selectedProfileImageBytes!)
                            : profileUrl.isNotEmpty
                                ? NetworkImage(profileUrl)
                                : const AssetImage('images/profile.jpg')
                                    as ImageProvider,
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.black),
                        onPressed: () {
                          _selectImage((bytes) {
                            setState(() {
                              selectedProfileImageBytes = bytes;
                            });
                          });
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${AppLocalizations.of(context)!.translate('farmerId')} $farmerId",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.translate('name'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!
                          .translate('mobileNumber'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _addressController, // New address field
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.translate('address'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildImagePicker(
                      AppLocalizations.of(context)!.translate('aadhar_card'),
                      aadharUrl,
                      selectedAadharImageBytes, (bytes) {
                    setState(() {
                      selectedAadharImageBytes = bytes;
                    });
                  }),
                  _buildImagePicker(
                      AppLocalizations.of(context)!.translate('ration_card'),
                      rationUrl,
                      selectedRationImageBytes, (bytes) {
                    setState(() {
                      selectedRationImageBytes = bytes;
                    });
                  }),
                  _buildImagePicker(
                      AppLocalizations.of(context)!.translate('land_record'),
                      landUrl,
                      selectedLandImageBytes, (bytes) {
                    setState(() {
                      selectedLandImageBytes = bytes;
                    });
                  }),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 183, 255, 185),
                    ),
                    child: Text(AppLocalizations.of(context)!
                        .translate('update_profile')),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildImagePicker(String label, String imageUrl,
      Uint8List? selectedBytes, Function(Uint8List) onFilePicked) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade200,
                ),
                clipBehavior: Clip.antiAlias,
                child: selectedBytes != null
                    ? Image.memory(selectedBytes, fit: BoxFit.cover)
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.error)),
                      ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                radius: 16,
                child: IconButton(
                  icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                  padding: EdgeInsets.zero,
                  onPressed: () => _selectImage(onFilePicked),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
