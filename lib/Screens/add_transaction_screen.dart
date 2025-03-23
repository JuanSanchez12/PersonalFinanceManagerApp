import 'package:flutter/material.dart';
import 'template_screen.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateScreen(
      backgroundColor: Colors.green,
      screenName: 'Add Transaction Screen',
    );
  }
}