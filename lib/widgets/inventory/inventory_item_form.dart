import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:financial_manager/models/inventory_model.dart';

class InventoryItemForm extends StatefulWidget {
  final InventoryItem? item;
  final Function(InventoryItem) onSubmit;

  const InventoryItemForm({
    super.key,
    this.item,
    required this.onSubmit,
  });

  @override
  State<InventoryItemForm> createState() => _InventoryItemFormState();
}

class _InventoryItemFormState extends State<InventoryItemForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  final List<String> _units = ['pcs', 'kg', 'g', 'L', 'mL', 'm', 'cm', 'box'];

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _formKey.currentState?.patchValue({
        'name': widget.item?.name,
        'description': widget.item?.description,
        'quantity': widget.item?.quantity,
        'unit': widget.item?.unit,
        'costPrice': widget.item?.costPrice,
        'sellingPrice': widget.item?.sellingPrice,
        'category': widget.item?.category,
        'barcode': widget.item?.barcode,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormBuilderTextField(
              name: 'name',
              decoration: const InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter item name';
                }
                return null;
              },
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
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FormBuilderTextField(
                    name: 'quantity',
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: FormBuilderDropdown<String>(
                    name: 'unit',
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    items: _units
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            ))
                        .toList(),
                    initialValue: widget.item?.unit ?? 'pcs',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'costPrice',
              decoration: const InputDecoration(
                labelText: 'Cost Price',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                if (double.tryParse(value) == null) {
                  return 'Invalid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'sellingPrice',
              decoration: const InputDecoration(
                labelText: 'Selling Price',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                if (double.tryParse(value) == null) {
                  return 'Invalid amount';
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
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState!.value;
      widget.onSubmit(
        InventoryItem(
          id: widget.item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          name: data['name'],
          description: data['description'],
          quantity: double.parse(data['quantity']),
          unit: data['unit'],
          costPrice: double.parse(data['costPrice']),
          sellingPrice: double.parse(data['sellingPrice']),
          category: data['category'],
          barcode: data['barcode'],
        ),
      );
    }
  }
}