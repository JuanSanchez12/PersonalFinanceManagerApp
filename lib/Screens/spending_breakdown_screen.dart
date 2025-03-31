import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

class SpendingBreakdownScreen extends StatelessWidget {
  const SpendingBreakdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spending Breakdown'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<TransactionProvider>(
          builder: (context, provider, _) {
            final expenses = provider.transactions
                .where((t) => t.type == TransactionType.expense)
                .toList();

            // Calculate category totals
            final categoryTotals = Map<String, double>.fromIterables(
              Transaction.expenseCategories,
              List.filled(Transaction.expenseCategories.length, 0),
            );

            for (final expense in expenses) {
              if (expense.category != null) {
                categoryTotals[expense.category!] =
                    (categoryTotals[expense.category!] ?? 0) + expense.amount;
              }
            }

            final totalExpenses = expenses.fold(0.0, (sum, item) => sum + item.amount);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Total Expenses Card
                _buildFinanceCard(
                  title: 'Total Expenses',
                  amount: totalExpenses,
                  icon: Icons.pie_chart,
                  color: Colors.red[700]!,
                ),
                const SizedBox(height: 20),

                if (totalExpenses > 0) ...[
                  // Pie Chart Card
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Spending Distribution',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 250,
                            child: PieChart(
                              PieChartData(
                                sections: Transaction.expenseCategories
                                    .where((category) => categoryTotals[category]! > 0)
                                    .map((category) {
                                  return PieChartSectionData(
                                    color: _getCategoryColor(category),
                                    value: categoryTotals[category]!,
                                    title: category,
                                    radius: 60,
                                    titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  );
                                }).toList(),
                                centerSpaceRadius: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Category List
                const Text(
                  'Expense Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: categoryTotals.values.any((total) => total > 0)
                      ? ListView.builder(
                          itemCount: Transaction.expenseCategories.length,
                          itemBuilder: (ctx, index) {
                            final category = Transaction.expenseCategories[index];
                            final total = categoryTotals[category] ?? 0;
                            if (total <= 0) return const SizedBox.shrink();

                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: _getCategoryColor(category).withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.category,
                                        color: _getCategoryColor(category),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        category,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '\$${total.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _getCategoryColor(category),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'No expenses yet',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFinanceCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final index = Transaction.expenseCategories.indexOf(category);
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }
}