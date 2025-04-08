import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:financial_manager/models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final Function(Transaction) onSubmit;

  const TransactionForm({super.key, required this.onSubmit});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  final List<String> _expenseCategories = ['Rent', 'Supplies', 'Utilities', 'Salary', 'Other'];
  final List<String> _incomeCategories = ['Sales', 'Investment', 'Other Income'];

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          FormBuilderDropdown<TransactionCategory>(
            name: 'category',
            decoration: const InputDecoration(
              labelText: 'Transaction Type',
              border: OutlineInputBorder(),
            ),
            items: TransactionCategory.values
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(
                        category == TransactionCategory.income ? 'Income' : 'Expense',
                      ),
                    ))
                .toList(),
            initialValue: TransactionCategory.expense,
          ),
          const SizedBox(height: 16),
          FormBuilderDropdown<String>(
            name: 'subCategory',
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: (_formKey.currentState?.fields['category']?.value == 
                    TransactionCategory.income
                ? _incomeCategories
                : _expenseCategories)
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'amount',
            decoration: const InputDecoration(
              labelText: 'Amount',
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
          FormBuilderDateTimePicker(
            name: 'date',
            initialValue: DateTime.now(),
            inputType: InputType.date,
            format: DateFormat('yyyy-MM-dd'),
            decoration: const InputDecoration(
              labelText: 'Date',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'description',
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Save Transaction'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState!.value;
      widget.onSubmit(
        Transaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          amount: double.parse(data['amount']),
          description: data['description'],
          date: data['date'],
          category: data['category'],
          subCategory: data['subCategory'],
        ),
      );
    }
  }
}