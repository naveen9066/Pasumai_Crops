import 'package:flutter/material.dart';
import 'package:crop_frontend/localization/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'farmer_home_page.dart';
import 'admin_dashboard_page.dart';
import 'farmer_registration_page.dart';
import '../widgets/language_switcher.dart';

enum LoginType { admin, farmer }

class LoginPage extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const LoginPage({super.key, required this.onLocaleChange});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  LoginType _loginType = LoginType.farmer;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (_loginType == LoginType.admin) {
      if (emailController.text.trim().isEmpty ||
          passwordController.text.trim().isEmpty) {
        _showErrorDialog('fill_all_fields');
        return;
      }
    } else {
      if (phoneController.text.trim().isEmpty) {
        _showErrorDialog('Please enter phone and OTP');
        return;
      }
    }

    final baseUrl = dotenv.env['BASE_URL']!;
    final uri = _loginType == LoginType.admin
        ? Uri.parse('$baseUrl/api/auth/admin/login')
        : Uri.parse('$baseUrl/api/auth/farmer/login');

    final body = _loginType == LoginType.admin
        ? {
            'email': emailController.text.trim(),
            'password': passwordController.text.trim(),
          }
        : {'mobile_number': phoneController.text.trim()};

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();

        if (_loginType == LoginType.admin) {
          await prefs.setString('user_type', 'admin');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminDashboardPage(
                onLocaleChange: widget.onLocaleChange,
              ),
            ),
          );
        } else {
          final farmerId = data['farmer']['farmer_id'];
          await prefs.setString('user_type', 'farmer');
          await prefs.setString('farmer_phone', phoneController.text.trim());
          await prefs.setString('farmer_id', farmerId);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FarmerHomePage(
                onLocaleChange: widget.onLocaleChange,
              ),
            ),
          );
        }
      } else {
        final errorMessageKey = {
              'Admin not found': 'admin_not_found',
              'Invalid credentials': 'invalid_credentials',
              'Something went wrong. Please try again later.': 'server_error',
            }[data['message']] ??
            'server_error';

        _showErrorDialog(errorMessageKey);
      }
    } catch (e) {
      _showErrorDialog('Something went wrong. Please try again later.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('login_failed')),
        content: Text(AppLocalizations.of(context).translate(message)),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context).translate('ok')),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text(
          AppLocalizations.of(context).translate('login'),
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: LanguageSwitcher(onLocaleChange: widget.onLocaleChange),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppLocalizations.of(context).translate('login'),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Radio<LoginType>(
                  value: LoginType.farmer,
                  groupValue: _loginType,
                  onChanged: (value) => setState(() => _loginType = value!),
                ),
                Text(AppLocalizations.of(context).translate('farmer')),
                const SizedBox(width: 20),
                Radio<LoginType>(
                  value: LoginType.admin,
                  groupValue: _loginType,
                  onChanged: (value) => setState(() => _loginType = value!),
                ),
                Text(AppLocalizations.of(context).translate('admin')),
              ],
            ),
            const SizedBox(height: 20),
            if (_loginType == LoginType.admin) ...[
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).translate('email'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).translate('password'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
            ] else ...[
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context).translate('phone_number'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 10)
            ],
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _login,
                  child: Text(
                    AppLocalizations.of(context).translate('login'),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_loginType == LoginType.farmer)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)
                      .translate('dontHaveAccount')),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FarmerRegistrationPage(
                            onLocaleChange: widget.onLocaleChange,
                          ),
                        ),
                      );
                    },
                    child: Text(
                        AppLocalizations.of(context).translate('register')),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
