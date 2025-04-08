import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CashFlowInput extends StatefulWidget {
  final int periods;
  final Function(List<double>) onCashFlowsChanged;

  const CashFlowInput({
    super.key,
    required this.periods,
    required this.onCashFlowsChanged,
  });

  @override
  State<CashFlowInput> createState() => _CashFlowInputState();
}

class _CashFlowInputState extends State<CashFlowInput> {
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(CashFlowInput oldWidget) {
    if (oldWidget.periods != widget.periods) {
      _initializeControllers();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _initializeControllers() {
    _controllers.clear();
    for (int i = 0; i < widget.periods; i++) {
      _controllers.add(TextEditingController(text: i == 0 ? '' : '0'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Cash Flows by Period',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(),
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Period', textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Amount', textAlign: TextAlign.center),
                ),
              ],
            ),
            ...List.generate(widget.periods, (index) {
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      index == 0 ? 'Initial' : 'Period $index',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: FormBuilderTextField(
                      controller: _controllers[index],
                      name: 'period_$index',
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _notifyCashFlowsChanged(),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  void _notifyCashFlowsChanged() {
    final cashFlows = _controllers.map((controller) {
      return double.tryParse(controller.text) ?? 0;
    }).toList();
    widget.onCashFlowsChanged(cashFlows);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}