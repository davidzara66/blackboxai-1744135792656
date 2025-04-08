import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financial_manager/models/sale_purchase_model.dart';
import 'package:financial_manager/services/database_service.dart';
import 'package:financial_manager/widgets/sales_purchases/sale_purchase_form.dart';

class SalesPurchasesScreen extends StatelessWidget {
  const SalesPurchasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales & Purchases'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add-sale-purchase');
            },
          ),
        ],
      ),
      body: StreamBuilder<List<SalePurchase>>(
        stream: Provider.of<DatabaseService>(context).getSalesPurchases(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = snapshot.data!;

          if (transactions.isEmpty) {
            return const Center(child: Text('No transactions yet'));
          }

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                title: Text(transaction.contact),
                subtitle: Text(transaction.date.toString()),
                trailing: Text('\$${transaction.total.toStringAsFixed(2)}'),
                onTap: () {
                  // TODO: Show details
                },
              );
            },
          );
        },
      ),
    );
  }
}