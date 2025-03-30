import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/goal.dart';
import '../providers/transaction_provider.dart';
import '../screens/add_goal_screen.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings'),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Total Savings Card
                _buildSavingsCard(
                  title: 'Total Savings',
                  amount: provider.totalSavings,
                  icon: Icons.savings,
                  color: Colors.blue[700]!,
                ),
                const SizedBox(height: 20),

                // Available Savings Card
                _buildSavingsCard(
                  title: 'Available Savings',
                  amount: provider.availableSavings,
                  icon: Icons.account_balance_wallet,
                  color: Colors.green[700]!,
                ),
                
                const SizedBox(height: 20),
                
                // Goals Section
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Your Goals',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                // Goals List
                Expanded(
                  child: provider.goals.isEmpty
                      ? const Center(
                          child: Text(
                            'No goals yet\nTap the + button to add one',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: provider.goals.length,
                          itemBuilder: (context, index) {
                            final goal = provider.goals[index];
                            return _buildGoalCard(context, goal, index, provider);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddGoalScreen(),
            ),
          );
          Provider.of<TransactionProvider>(context, listen: false).refreshData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, Goal goal, int index, TransactionProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  goal.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showContributeDialog(context, index, provider),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$${goal.contributedAmount.toStringAsFixed(2)} of \$${goal.targetAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: goal.progress,
              backgroundColor: Colors.grey[200],
              color: goal.progress >= 1 ? Colors.green : Colors.blue,
              minHeight: 10,
            ),
            if (goal.progress >= 1)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Goal Completed!',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showContributeDialog(BuildContext context, int goalIndex, TransactionProvider provider) {
    final goal = provider.goals[goalIndex];
    final availableSavings = provider.availableSavings;
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Contribute to Goal'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Available Savings: \$${availableSavings.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Goal Target: \$${goal.targetAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount to Contribute',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null) {
                      return 'Please enter a valid number';
                    }
                    if (amount <= 0) {
                      return 'Amount must be greater than zero';
                    }
                    if (amount > availableSavings) {
                      return 'Not enough savings available';
                    }
                    if (goal.contributedAmount + amount > goal.targetAmount) {
                      return 'Contribution would exceed goal target';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final amount = double.parse(amountController.text);
                  await provider.contributeToGoal(goalIndex, amount);
                  Navigator.pop(context);
                }
              },
              child: const Text('Contribute'),
            ),
          ],
        );
      },
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