import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import '../models/goal.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TransactionAdapter());
      Hive.registerAdapter(TransactionTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(GoalAdapter());
    }

    await Hive.openBox<Transaction>('transactions');
    await Hive.openBox<Goal>('goals');
  }

  static Box<Transaction> get transactionsBox => Hive.box<Transaction>('transactions');
  static Box<Goal> get goalsBox => Hive.box<Goal>('goals');
}