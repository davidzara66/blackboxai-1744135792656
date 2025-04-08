import 'package:flutter/material.dart';
import 'package:financial_manager/services/formatting_service.dart';

class CurrencySelector extends StatelessWidget {
  const CurrencySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.currency_exchange),
      onSelected: (currency) async {
        await FormattingService.setCurrency(currency);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Currency set to $currency')),
        );
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'USD',
          child: Text('USD (\$)'),
        ),
        const PopupMenuItem(
          value: 'VES',
          child: Text('VES (Bs.)'),
        ),
      ],
    );
  }
}