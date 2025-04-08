import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financial_manager/services/database_service.dart';
import 'package:financial_manager/widgets/cash_flow/transaction_list.dart';
import 'package:financial_manager/widgets/cash_flow/time_period_selector.dart';

class CashFlowHome extends StatefulWidget {
  const CashFlowHome({super.key});

  @override
  State<CashFlowHome> createState() => _CashFlowHomeState();
}

class _CashFlowHomeState extends State<CashFlowHome> {
  TimePeriod _selectedPeriod = TimePeriod.monthly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash Flow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add-transaction');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TimePeriodSelector(
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: (period) {
              setState(() => _selectedPeriod = period);
            },
          ),
          Expanded(
            child: Provider<DatabaseService>.value(
              value: Provider.of<DatabaseService>(context),
              child: const TransactionList(),
            ),
          ),
        ],
      ),
    );
  }
}

enum TimePeriod { daily, weekly, monthly }
