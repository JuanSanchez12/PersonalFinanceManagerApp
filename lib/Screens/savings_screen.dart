import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    
    final double totalSavings = provider.transactions
        .where((t) => t.type == TransactionType.savings)
        .fold(0, (sum, t) => sum + t.amount);
    
    final double availableSavings = totalSavings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Total Savings Card
            _buildSavingsCard(
              title: 'Total Savings',
              amount: totalSavings,
              icon: Icons.savings,
              color: Colors.blue[700]!,
            ),
            const SizedBox(height: 20),

            // Available Savings Card
            _buildSavingsCard(
              title: 'Available Savings',
              amount: availableSavings,
              icon: Icons.account_balance_wallet,
              color: Colors.green[700]!,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSavingsCard({
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
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}