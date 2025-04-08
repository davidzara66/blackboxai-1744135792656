import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financial_manager/services/localization_service.dart';
import 'package:financial_manager/widgets/common/currency_selector.dart';
import 'package:financial_manager/widgets/common/language_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = LocalizationService.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('settings')),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(localizations.translate('currency_preference')),
            trailing: const CurrencySelector(),
          ),
          ListTile(
            title: Text(localizations.translate('language')),
            trailing: const LanguageSelector(),
          ),
          SwitchListTile(
            title: Text(localizations.translate('auto_update_rates')),
            value: true,
            onChanged: (value) {
              // TODO: Implement auto-update toggle
            },
          ),
        ],
      ),
    );
  }
}