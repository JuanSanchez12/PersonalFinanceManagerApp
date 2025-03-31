import 'package:hive/hive.dart';

part 'goal.g.dart'; // Hive-generated adapter file

// Savings goal model with progress tracking
@HiveType(typeId: 2) // Must be unique across all Hive models
class Goal {
  @HiveField(0)
  final String name; // Goal description (e.g. "New Laptop")
  
  @HiveField(1)
  final double targetAmount; // Total amount needed
  
  @HiveField(2)
  double contributedAmount; // Mutable - tracks current savings
  
  @HiveField(3)
  final DateTime createdDate; // Auto-set to now if not provided

  Goal({
    required this.name,
    required this.targetAmount,
    this.contributedAmount = 0, // Starts at 0 by default
    DateTime? createdDate,
  }) : createdDate = createdDate ?? DateTime.now();

  // Progress percentage (0.0 to 1.0)
  double get progress => contributedAmount / targetAmount;
  
  // How much left to save
  double get remainingAmount => targetAmount - contributedAmount;
}