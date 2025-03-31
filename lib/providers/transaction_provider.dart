import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/goal.dart';
import '../database/database_helper.dart';

/// Manages application state for financial transactions and savings goals
class TransactionProvider extends ChangeNotifier {
  /// Returns all transactions from the database
  List<Transaction> get transactions => 
      HiveService.transactionsBox.values.toList().cast<Transaction>();
  
  /// Returns all savings goals from the database
  List<Goal> get goals => 
      HiveService.goalsBox.values.toList().cast<Goal>();

  /// Calculates current available balance (income - expenses - savings)
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

  /// Calculates total amount saved across all savings transactions
  double get totalSavings {
    return transactions
        .where((t) => t.type == TransactionType.savings)
        .fold(0.0, (double sum, t) => sum + t.amount);
  }

  /// Calculates available savings not yet allocated to goals
  double get availableSavings {
    final totalInGoals = goals.fold(0.0, (sum, goal) => sum + goal.contributedAmount);
    return totalSavings - totalInGoals;
  }

  /// Adds a new transaction and notifies listeners
  Future<void> addTransaction(Transaction newTransaction) async {
    await HiveService.transactionsBox.add(newTransaction);
    notifyListeners(); // Update all listening widgets
  }

  /// Adds a new savings goal and notifies listeners
  Future<void> addGoal(Goal newGoal) async {
    await HiveService.goalsBox.add(newGoal);
    notifyListeners();
  }

  /// Makes a contribution to an existing goal
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

  /// Refreshes data from disk and notifies listeners
  Future<void> refreshData() async {
    await HiveService.transactionsBox.flush();
    notifyListeners();
  }
}