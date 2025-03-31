import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import '../models/goal.dart';

/// Service for initializing and accessing Hive database boxes
class HiveService {
  /// Initializes Hive and registers all adapters
  static Future<void> init() async {
    await Hive.initFlutter(); // Initialize Hive with Flutter bindings
    
    // Register adapters only if they haven't been registered before
    if (!Hive.isAdapterRegistered(0)) {  // Transaction adapters
      Hive.registerAdapter(TransactionAdapter());
      Hive.registerAdapter(TransactionTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {  // Goal adapter
      Hive.registerAdapter(GoalAdapter());
    }

    // Open all required boxes (tables)
    await Hive.openBox<Transaction>('transactions');
    await Hive.openBox<Goal>('goals');
  }

  /// Provides direct access to the transactions box
  static Box<Transaction> get transactionsBox => Hive.box<Transaction>('transactions');
  
  /// Provides direct access to the goals box  
  static Box<Goal> get goalsBox => Hive.box<Goal>('goals');
}