import 'package:flutter/material.dart';

class TemplateScreen extends StatelessWidget {
  final Color backgroundColor;
  final String screenName;

  const TemplateScreen({
    super.key,
    required this.backgroundColor,
    required this.screenName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Text(
          screenName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}