import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  
  TransactionType _selectedType = TransactionType.expense;
  String? _selectedCategory;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submitTransaction() {
    if (_formKey.currentState!.validate()) {
      final newTransaction = Transaction(
        type: _selectedType,
        amount: double.parse(_amountController.text),
        category: _selectedType == TransactionType.income 
            ? null 
            : _selectedCategory,
      );

      Provider.of<TransactionProvider>(context, listen: false)
          .addTransaction(newTransaction);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Transaction Type Selector
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transaction Type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<TransactionType>(
                          title: const Text('Income'),
                          value: TransactionType.income,
                          groupValue: _selectedType,
                          onChanged: (value) => setState(() => _selectedType = value!),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<TransactionType>(
                          title: const Text('Expense'),
                          value: TransactionType.expense,
                          groupValue: _selectedType,
                          onChanged: (value) => setState(() => _selectedType = value!),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<TransactionType>(
                          title: const Text('Savings'),
                          value: TransactionType.savings,
                          groupValue: _selectedType,
                          onChanged: (value) => setState(() => _selectedType = value!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Category Dropdown (shown only for expenses)
              if (_selectedType == TransactionType.expense)
                Column(
                  children: [
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: Transaction.expenseCategories
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedCategory = value),
                      validator: (value) {
                        if (_selectedType == TransactionType.expense &&
                            (value == null || value.isEmpty)) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              // Amount Input
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Amount must be greater than zero';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                onPressed: _submitTransaction,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Add Transaction',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}