import 'package:flutter/material.dart';
import 'package:financial_manager/widgets/investment/van_tir_calculator.dart';

class InvestmentAnalysisScreen extends StatefulWidget {
  const InvestmentAnalysisScreen({super.key});

  @override
  State<InvestmentAnalysisScreen> createState() => _InvestmentAnalysisScreenState();
}

class _InvestmentAnalysisScreenState extends State<InvestmentAnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment Analysis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              // TODO: Implement PDF export
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            VanTirCalculator(),
            SizedBox(height: 20),
            // TODO: Add sensitivity analysis widget
          ],
        ),
      ),
    );
  }
}