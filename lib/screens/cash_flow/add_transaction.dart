import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financial_manager/services/database_service.dart';
import 'package:financial_manager/widgets/cash_flow/transaction_form.dart';
import 'package:financial_manager/models/transaction_model.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: TransactionForm(
          onSubmit: (transaction) async {
            try {
              await database.addTransaction(transaction);
              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error saving transaction: $e')),
              );
            }
          },
        ),
      ),
    );
  }
}