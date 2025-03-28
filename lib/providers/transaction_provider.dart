import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  double get availableBalance {
    return _transactions.fold(0, (sum, transaction) {
      switch (transaction.type) {
        case TransactionType.income:
          return sum + transaction.amount;
        case TransactionType.expense:
        case TransactionType.savings:
          return sum - transaction.amount;
      }
    });
  }

  double get totalSavings {
    return _transactions
        .where((t) => t.type == TransactionType.savings)
        .fold(0, (sum, t) => sum + t.amount);
  }

  void addTransaction(Transaction newTransaction) {
    _transactions.add(newTransaction);
    notifyListeners();
  }
}