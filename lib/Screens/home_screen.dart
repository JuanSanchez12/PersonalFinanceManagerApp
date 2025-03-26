import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          
          // Balance Container
          Container(
            width: double.infinity,
            color: Colors.blue,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Balance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${transactionProvider.balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Transactions Title
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 20, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Transactions List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: transactionProvider.transactions.length,
              itemBuilder: (ctx, index) {
                final transaction = transactionProvider.transactions[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    transaction.type == TransactionType.income 
                      ? Icons.attach_money 
                      : Icons.shopping_cart,
                    color: transaction.type == TransactionType.income 
                      ? Colors.green 
                      : Colors.red,
                  ),
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      transaction.category ?? 'Income',
                    ),
                  ),
                  trailing: Text(
                    '\$${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: transaction.type == TransactionType.income
                        ? Colors.green
                        : Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}