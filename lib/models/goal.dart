class Goal {
  final String name;
  final double targetAmount;
  double contributedAmount;
  final DateTime createdDate;

  Goal({
    required this.name,
    required this.targetAmount,
    this.contributedAmount = 0,
    DateTime? createdDate,
  }) : createdDate = createdDate ?? DateTime.now();

  double get progress => contributedAmount / targetAmount;
  double get remainingAmount => targetAmount - contributedAmount;
}