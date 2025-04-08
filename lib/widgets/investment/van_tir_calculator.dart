import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:financial_manager/widgets/investment/cash_flow_input.dart';

class VanTirCalculator extends StatefulWidget {
  const VanTirCalculator({super.key});

  @override
  State<VanTirCalculator> createState() => _VanTirCalculatorState();
}

class _VanTirCalculatorState extends State<VanTirCalculator> {
  final _formKey = GlobalKey<FormBuilderState>();
  final List<Map<String, dynamic>> _cashFlows = [];
  double? _vanResult;
  double? _tirResult;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'VAN/TIR Calculator',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'initialInvestment',
                    decoration: const InputDecoration(
                      labelText: 'Initial Investment',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'discountRate',
                    decoration: const InputDecoration(
                      labelText: 'Discount Rate (%)',
                      suffixText: '%',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a rate';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'periods',
                    decoration: const InputDecoration(
                      labelText: 'Number of Periods',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter number of periods';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CashFlowInput(
              periods: periods - 1, // Exclude initial investment period
              onCashFlowsChanged: (flows) {
                setState(() {
                  _cashFlows = flows;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Calculate VAN/TIR'),
            ),
            if (_vanResult != null || _tirResult != null) ...[
              const SizedBox(height: 20),
              Text(
                'VAN: \$${_vanResult?.toStringAsFixed(2) ?? 'N/A'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'TIR: ${_tirResult?.toStringAsFixed(2) ?? 'N/A'}%',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _calculate() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState!.value;
      final initialInvestment = double.parse(data['initialInvestment']);
      final discountRate = double.parse(data['discountRate']) / 100;
      final periods = int.parse(data['periods']);

      // Simulate cash flows (replace with actual input later)
      final cashFlows = List.generate(periods, (i) {
        return i == 0 
            ? -initialInvestment 
            : initialInvestment * 0.3; // 30% return per period
      });

      // Calculate VAN (NPV)
      double van = 0;
      for (int t = 0; t < cashFlows.length; t++) {
        van += cashFlows[t] / pow(1 + discountRate, t);
      }

      // Calculate TIR (IRR) using simple approximation
      double tir = 0;
      try {
        double npvAtZero = cashFlows.reduce((a, b) => a + b);
        if (npvAtZero > 0) {
          tir = 0.25; // Default guess if no solution found
          for (int i = 0; i < 100; i++) {
            double npv = 0;
            for (int t = 0; t < cashFlows.length; t++) {
              npv += cashFlows[t] / pow(1 + tir, t);
            }
            if (npv.abs() < 0.01) break;
            tir += (npv / npvAtZero) * 0.01;
          }
        }
      } catch (e) {
        tir = double.nan;
      }

      setState(() {
        _vanResult = van;
        _tirResult = tir * 100;
      });
    }
  }
}