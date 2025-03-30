import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/goal.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Goal> _goals = [];

  List<Transaction> get transactions => _transactions;
  List<Goal> get goals => _goals;

  double get availableBalance {
    return _transactions.fold(0.0, (double sum, transaction) {
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
        .fold(0.0, (double sum, t) => sum + t.amount);
  }

  double get availableSavings {
    final totalInGoals = _goals.fold(0.0, (sum, goal) => sum + goal.contributedAmount);
    return totalSavings - totalInGoals;
  }

  void addTransaction(Transaction newTransaction) {
    _transactions.add(newTransaction);
    notifyListeners();
  }

  void addGoal(Goal newGoal) {
    _goals.add(newGoal);
    notifyListeners();
  }

  void contributeToGoal(int goalIndex, double amount) {
    final goal = _goals[goalIndex];
    
    _goals[goalIndex] = Goal(
      name: goal.name,
      targetAmount: goal.targetAmount,
      contributedAmount: goal.contributedAmount + amount,
      createdDate: goal.createdDate,
    );
    
    notifyListeners();
  }
}