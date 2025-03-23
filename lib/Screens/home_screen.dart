import 'package:flutter/material.dart';
import 'template_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateScreen(
      backgroundColor: Colors.blue,
      screenName: 'Home Screen',
    );
  }
}