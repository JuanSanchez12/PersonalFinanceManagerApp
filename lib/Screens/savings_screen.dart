import 'package:flutter/material.dart';
import 'template_screen.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateScreen(
      backgroundColor: Colors.purple,
      screenName: 'Savings Screen',
    );
  }
}