import 'package:flutter/material.dart';
import 'package:financial_manager/services/localization_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  Future<void> _changeLanguage(BuildContext context, Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    await prefs.setString('countryCode', locale.countryCode ?? 'US');
    
    // Restart app to apply changes
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/',
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      onSelected: (locale) => _changeLanguage(context, locale),
      itemBuilder: (context) {
        return LocalizationService.supportedLocales.map((locale) {
          return PopupMenuItem<Locale>(
            value: locale,
            child: Text(
              locale.languageCode == 'es' ? 'Español' : 'English',
            ),
          );
        }).toList();
      },
    );
  }
}