enum TransactionCategory { income, expense }

class Transaction {
  final String id;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionCategory category;
  final String? subCategory;

  const Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.category,
    this.subCategory,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'date': date,
      'category': category.toString(),
      'subCategory': subCategory,
    };
  }

  // Create from Firestore document
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      description: map['description'],
      date: map['date'].toDate(),
      category: map['category'] == 'TransactionCategory.income'
          ? TransactionCategory.income
          : TransactionCategory.expense,
      subCategory: map['subCategory'],
    );
  }
}