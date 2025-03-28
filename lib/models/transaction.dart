enum TransactionType {
  income,
  expense,
  savings
}

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
  })  : date = date ?? DateTime.now(),
        assert(
          (type == TransactionType.expense && category != null) ||
              (type != TransactionType.expense),
          'Category must be provided for expenses',
        ),
        assert(amount > 0, 'Amount must be positive');

  static const List<String> expenseCategories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Other',
  ];
}