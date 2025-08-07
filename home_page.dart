import 'package:crop_frontend/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import '../widgets/language_switcher.dart'; // Import the reusable widget

class HomePage extends StatelessWidget {
  final Function(Locale) onLocaleChange;

  const HomePage({super.key, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text(
          AppLocalizations.of(context).translate('home_title'),
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 12.0), // Adjust padding as needed
            child: LanguageSwitcher(onLocaleChange: onLocaleChange),
          ),
        ],
      ),
      body: Center(
        child: Text(AppLocalizations.of(context).translate('welcome_message')),
      ),
    );
  }
}
