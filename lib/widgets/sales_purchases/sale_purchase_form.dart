import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:financial_manager/models/sale_purchase_model.dart';

class SalePurchaseForm extends StatefulWidget {
  final Function(SalePurchase) onSubmit;

  const SalePurchaseForm({super.key, required this.onSubmit});

  @override
  State<SalePurchaseForm> createState() => _SalePurchaseFormState();
}

class _SalePurchaseFormState extends State<SalePurchaseForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  final List<SalePurchaseItem> _items = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            FormBuilderDropdown<TransactionType>(
              name: 'type',
              decoration: const InputDecoration(
                labelText: 'Transaction Type',
                border: OutlineInputBorder(),
              ),
              items: TransactionType.values
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(
                          type == TransactionType.sale ? 'Sale' : 'Purchase',
                        ),
                      ))
                  .toList(),
              initialValue: TransactionType.sale,
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'contact',
              decoration: const InputDecoration(
                labelText: 'Contact',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a contact';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text('Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  title: Text(item.description),
                  subtitle: Text('${item.quantity} x \$${item.unitPrice}'),
                  trailing: Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                  onTap: () => _editItem(index),
                );
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _addItem,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Add Item'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Save Transaction'),
            ),
          ],
        ),
      ),
    );
  }

  void _addItem() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Item'),
        content: ItemForm(
          onSubmit: (item) {
            setState(() => _items.add(item));
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _editItem(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: ItemForm(
          item: _items[index],
          onSubmit: (item) {
            setState(() => _items[index] = item);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState!.value;
      widget.onSubmit(
        SalePurchase(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          date: DateTime.now(),
          type: data['type'],
          contact: data['contact'],
          items: _items,
          tax: 0,
          discount: 0,
        ),
      );
    }
  }
}