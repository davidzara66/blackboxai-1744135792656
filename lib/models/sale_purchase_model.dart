import 'package:flutter/foundation.dart';

enum TransactionType { sale, purchase }

class SalePurchase {
  final String id;
  final DateTime date;
  final TransactionType type;
  final String contact;
  final List<SalePurchaseItem> items;
  final double tax;
  final double discount;
  final String? notes;

  const SalePurchase({
    required this.id,
    required this.date,
    required this.type,
    required this.contact,
    required this.items,
    this.tax = 0,
    this.discount = 0,
    this.notes,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get total => subtotal * (1 - discount) * (1 + tax);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'type': type.toString(),
      'contact': contact,
      'items': items.map((item) => item.toMap()).toList(),
      'tax': tax,
      'discount': discount,
      'notes': notes,
    };
  }

  factory SalePurchase.fromMap(Map<String, dynamic> map) {
    return SalePurchase(
      id: map['id'],
      date: map['date'].toDate(),
      type: map['type'] == 'TransactionType.sale'
          ? TransactionType.sale
          : TransactionType.purchase,
      contact: map['contact'],
      items: List<SalePurchaseItem>.from(
        map['items'].map((item) => SalePurchaseItem.fromMap(item)),
      ),
      tax: map['tax'],
      discount: map['discount'],
      notes: map['notes'],
    );
  }
}

class SalePurchaseItem {
  final String productId;
  final String description;
  final double quantity;
  final double unitPrice;

  const SalePurchaseItem({
    required this.productId,
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => quantity * unitPrice;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  factory SalePurchaseItem.fromMap(Map<String, dynamic> map) {
    return SalePurchaseItem(
      productId: map['productId'],
      description: map['description'],
      quantity: map['quantity'],
      unitPrice: map['unitPrice'],
    );
  }
}