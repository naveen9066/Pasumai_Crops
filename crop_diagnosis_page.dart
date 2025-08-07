import 'dart:convert';
import 'dart:typed_data';
import 'package:crop_frontend/localization/app_localizations.dart';
import 'package:crop_frontend/widgets/language_switcher.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CropDiagnosisPage extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  const CropDiagnosisPage({super.key, required this.onLocaleChange});

  @override
  _CropDiagnosisPageState createState() => _CropDiagnosisPageState();
}

class _CropDiagnosisPageState extends State<CropDiagnosisPage> {
  XFile? _imageFile;
  Uint8List? _imageBytes;
  final picker = ImagePicker();
  bool isLoading = false;
  dynamic responseData;

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = picked;
        _imageBytes = null;
      });
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _submitImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(AppLocalizations.of(context)!.translate('upload_first'))));
      return;
    }

    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('locale') ?? 'en';
    final baseUrl = dotenv.env['BASE_URL']!;
    final uri = Uri.parse('$baseUrl/api/farmer/cropdiagnosis');

    final requestBody = {
      'image': await _fileToBase64(_imageFile!),
      'language': langCode,
    };

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        responseData = jsonDecode(response.body);
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)!.translate('diagnosis_failed'))),
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
        backgroundColor: Color.fromARGB(255, 192, 255, 202),
        title: Text(AppLocalizations.of(context)!.translate('crop_diagnosis'),
            style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: LanguageSwitcher(onLocaleChange: widget.onLocaleChange),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _imageBytes == null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Icon(Icons.photo_library,
                                    size: 100, color: Colors.grey),
                                SizedBox(height: 10),
                                Text(
                                    AppLocalizations.of(context)!
                                        .translate('upload_prompt'),
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Image.memory(_imageBytes!,
                        width: 250, height: 250, fit: BoxFit.cover),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _pickImage,
                    child: Text(AppLocalizations.of(context)!
                        .translate('upload_image'))),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _submitImage,
                    child: Text(AppLocalizations.of(context)!
                        .translate('submit_diagnosis'))),
                const SizedBox(height: 20),
                isLoading ? _buildSkeletonLoader() : _buildDiagnosisResults(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Column(
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
                height: 20, width: double.infinity, color: Colors.white),
          ),
        );
      }),
    );
  }

  Widget _buildDiagnosisResults() {
    if (responseData == null) {
      return Text(AppLocalizations.of(context)!.translate('no_results'));
    }

    if (responseData['analysis'] != null) {
      return Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            responseData['analysis'],
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Text(AppLocalizations.of(context)!.translate('no_valid_response'));
  }
}
