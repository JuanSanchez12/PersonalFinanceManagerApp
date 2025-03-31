import 'package:hive/hive.dart';

part 'transaction.g.dart'; // Auto-generated Hive adapter file

// Transaction types supported by the app
@HiveType(typeId: 0) // Unique identifier for Hive
enum TransactionType {
  @HiveField(0) income,
  @HiveField(1) expense,
  @HiveField(2) savings,
}

// Main transaction model for financial records
@HiveType(typeId: 1) // Unique identifier for Hive
class Transaction {
  @HiveField(0)
  final TransactionType type;
  
  @HiveField(1)
  final double amount; // Always stored as positive value
  
  @HiveField(2)
  final String? category; // Required only for expense types
  
  @HiveField(3)
  final DateTime date; // Auto-defaults to current time if not provided

  Transaction({
    required this.type,
    required this.amount,
    this.category,
    DateTime? date,
  })  : date = date ?? DateTime.now(),
        // Validation rules:
        assert(
          (type == TransactionType.expense && category != null) ||
              (type != TransactionType.expense),
          'Category must be provided for expenses',
        ),
        assert(amount > 0, 'Amount must be positive');

  // Predefined categories for expense tracking
  static const List<String> expenseCategories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Other',
  ];
}