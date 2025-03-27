enum TransactionType { income, expense }

class Transaction {
  final TransactionType type;
  final double amount;
  final String? category;
  final DateTime date;

  Transaction({
    required this.type,
    required this.amount,
    this.category,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  static const List<String> expenseCategories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Other'
  ];
}