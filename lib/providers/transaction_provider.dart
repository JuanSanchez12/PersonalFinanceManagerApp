import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/goal.dart';
import '../database/database_helper.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> get transactions => 
      HiveService.transactionsBox.values.toList().cast<Transaction>();
  
  List<Goal> get goals => 
      HiveService.goalsBox.values.toList().cast<Goal>();

  double get availableBalance {
    return transactions.fold(0.0, (double sum, transaction) {
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
    return transactions
        .where((t) => t.type == TransactionType.savings)
        .fold(0.0, (double sum, t) => sum + t.amount);
  }

  double get availableSavings {
    final totalInGoals = goals.fold(0.0, (sum, goal) => sum + goal.contributedAmount);
    return totalSavings - totalInGoals;
  }

  Future<void> addTransaction(Transaction newTransaction) async {
    await HiveService.transactionsBox.add(newTransaction);
    notifyListeners();
  }

  Future<void> addGoal(Goal newGoal) async {
    await HiveService.goalsBox.add(newGoal);
    notifyListeners();
  }

  Future<void> contributeToGoal(int goalIndex, double amount) async {
    final goalKey = HiveService.goalsBox.keyAt(goalIndex) as int;
    final goal = HiveService.goalsBox.get(goalKey) as Goal;
    
    final updatedGoal = Goal(
      name: goal.name,
      targetAmount: goal.targetAmount,
      contributedAmount: goal.contributedAmount + amount,
      createdDate: goal.createdDate,
    );
    
    await HiveService.goalsBox.put(goalKey, updatedGoal);
    notifyListeners();
  }

  Future<void> refreshData() async {
  await HiveService.transactionsBox.flush();
  notifyListeners();
}
}