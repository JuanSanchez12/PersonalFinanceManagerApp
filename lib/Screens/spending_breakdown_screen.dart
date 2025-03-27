import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

class SpendingBreakdownScreen extends StatelessWidget {
  const SpendingBreakdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
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

    // Prepare chart data
    final chartData = Transaction.expenseCategories
        .where((category) => categoryTotals[category]! > 0)
        .map((category) {
      return PieChartSectionData(
        color: _getCategoryColor(category),
        value: categoryTotals[category]!,
        title: '${(categoryTotals[category]! / expenses.fold(0, (sum, item) => sum + item.amount) * 100)}%',
        radius: 60,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spending Breakdown'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Pie Chart
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: chartData,
                  centerSpaceRadius: 40,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Category List
            const Text(
              'Expense Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: Transaction.expenseCategories.length,
              itemBuilder: (ctx, index) {
                final category = Transaction.expenseCategories[index];
                final total = categoryTotals[category] ?? 0;
                if (total <= 0) return const SizedBox.shrink();

                return ListTile(
                  leading: Container(
                    width: 20,
                    height: 20,
                    color: _getCategoryColor(category),
                  ),
                  title: Text(category),
                  trailing: Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Category colors
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