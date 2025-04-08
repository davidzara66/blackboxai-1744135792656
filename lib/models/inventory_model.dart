import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  final String id;
  final String name;
  final String description;
  final double quantity;
  final String unit;
  final double costPrice;
  final double sellingPrice;
  final String? category;
  final String? barcode;
  final DateTime? lastUpdated;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.costPrice,
    required this.sellingPrice,
    this.category,
    this.barcode,
    this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'unit': unit,
      'costPrice': costPrice,
      'sellingPrice': sellingPrice,
      'category': category,
      'barcode': barcode,
      'lastUpdated': lastUpdated ?? FieldValue.serverTimestamp(),
    };
  }

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      quantity: map['quantity'],
      unit: map['unit'],
      costPrice: map['costPrice'],
      sellingPrice: map['sellingPrice'],
      category: map['category'],
      barcode: map['barcode'],
      lastUpdated: map['lastUpdated']?.toDate(),
    );
  }
}