import 'package:hive/hive.dart';

part 'goal.g.dart'; // This will be generated

@HiveType(typeId: 2) // Unique type identifier (different from Transaction)
class Goal {
  @HiveField(0)
  final String name;
  
  @HiveField(1)
  final double targetAmount;
  
  @HiveField(2)
  double contributedAmount;
  
  @HiveField(3)
  final DateTime createdDate;

  Goal({
    required this.name,
    required this.targetAmount,
    this.contributedAmount = 0,
    DateTime? createdDate,
  }) : createdDate = createdDate ?? DateTime.now();

  // Computed properties (not stored in Hive)
  double get progress => contributedAmount / targetAmount;
  double get remainingAmount => targetAmount - contributedAmount;
}