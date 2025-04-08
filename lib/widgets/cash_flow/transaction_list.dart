import 'package:flutter/material.dart';
import 'package:financial_manager/models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseService>(context);
    
    return StreamBuilder<List<Transaction>>(
      stream: database.getTransactions(),
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

        return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: transaction.category == TransactionCategory.income
                ? Colors.green[100]
                : Colors.red[100],
            child: Icon(
              transaction.category == TransactionCategory.income
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: transaction.category == TransactionCategory.income
                  ? Colors.green
                  : Colors.red,
            ),
          ),
          title: Text(transaction.description),
          subtitle: Text(
            DateFormat('MMM d, y').format(transaction.date),
          ),
          trailing: Text(
            NumberFormat.currency(symbol: '\$').format(transaction.amount),
            style: TextStyle(
              color: transaction.category == TransactionCategory.income
                  ? Colors.green
                  : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            // TODO: Navigate to transaction detail
          },
        );
      },
    );
  }
}