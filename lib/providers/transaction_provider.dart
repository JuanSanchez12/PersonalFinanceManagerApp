import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  final List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  double get balance {
    double total = 0;
    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.income) {
        total += transaction.amount;
      } else {
        total -= transaction.amount;
      }
    }
    return total;
  }

  void addTransaction(Transaction newTransaction) {
    _transactions.add(newTransaction);
    notifyListeners();
  }
}
