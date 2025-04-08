import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:financial_manager/models/sale_purchase_model.dart';

class ItemForm extends StatefulWidget {
  final SalePurchaseItem? item;
  final Function(SalePurchaseItem) onSubmit;

  const ItemForm({
    super.key,
    this.item,
    required this.onSubmit,
  });

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _formKey.currentState?.patchValue({
        'description': widget.item?.description,
        'quantity': widget.item?.quantity,
        'unitPrice': widget.item?.unitPrice,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FormBuilderTextField(
            name: 'description',
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'quantity',
            decoration: const InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter quantity';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'unitPrice',
            decoration: const InputDecoration(
              labelText: 'Unit Price',
              prefixText: '\$ ',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter price';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Save Item'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState!.value;
      widget.onSubmit(
        SalePurchaseItem(
          productId: DateTime.now().millisecondsSinceEpoch.toString(),
          description: data['description'],
          quantity: double.parse(data['quantity']),
          unitPrice: double.parse(data['unitPrice']),
        ),
      );
    }
  }
}