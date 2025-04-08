import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financial_manager/services/database_service.dart';
import 'package:financial_manager/widgets/financial_ratios/ratio_card.dart';

class RatiosScreen extends StatelessWidget {
  const RatiosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Ratios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              // TODO: Implement PDF export
            },
          ),
          IconButton(
            icon: const Icon(Icons.grid_on),
            onPressed: () {
              // TODO: Implement Excel export
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Transaction>>(
        stream: database.getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = snapshot.data!;
          final income = _calculateTotal(transactions, TransactionCategory.income);
          final expenses = _calculateTotal(transactions, TransactionCategory.expense);
          final profit = income - expenses;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                RatioCard(
                  title: 'Profit Margin',
                  value: income > 0 ? (profit / income) * 100 : 0,
                  unit: '%',
                  description: 'Net income divided by total revenue',
                ),
                const SizedBox(height: 16),
                RatioCard(
                  title: 'Current Ratio',
                  value: 1.5, // TODO: Calculate from assets/liabilities
                  description: 'Current assets divided by current liabilities',
                ),
                const SizedBox(height: 16),
                RatioCard(
                  title: 'Debt-to-Equity',
                  value: 0.6, // TODO: Calculate from debt/equity
                  description: 'Total liabilities divided by shareholders equity',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double _calculateTotal(List<Transaction> transactions, TransactionCategory category) {
    return transactions
        .where((t) => t.category == category)
        .fold(0, (sum, t) => sum + t.amount);
  }
}