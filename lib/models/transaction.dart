import 'package:hive/hive.dart';

part 'transaction.g.dart'; // This will be generated

@HiveType(typeId: 0) // Unique type identifier
enum TransactionType {
  @HiveField(0) income,
  @HiveField(1) expense,
  @HiveField(2) savings,
}

@HiveType(typeId: 1) // Unique type identifier
class Transaction {
  @HiveField(0)
  final TransactionType type;
  
  @HiveField(1)
  final double amount;
  
  @HiveField(2)
  final String? category;
  
  @HiveField(3)
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

  // Your existing categories list remains unchanged
  static const List<String> expenseCategories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Other',
  ];
}