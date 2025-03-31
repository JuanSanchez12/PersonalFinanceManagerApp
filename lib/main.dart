import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Widgets/navbar_widget.dart';
import 'Screens/home_screen.dart';
import 'Screens/add_transaction_screen.dart';
import 'Screens/spending_breakdown_screen.dart';
import 'Screens/savings_screen.dart';
import 'Screens/report_screen.dart';
import 'database/database_helper.dart';
import 'providers/transaction_provider.dart';

void main() async {
  // Initialize Flutter engine and Hive database before app starts
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  // Wrap app with TransactionProvider for state management
  runApp(
    ChangeNotifierProvider(
      create: (_) => TransactionProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance App',
      home: const MainScreen(),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Tracks active bottom nav item

  // Screens corresponding to each bottom navigation item
  final List<Widget> _screens = [
    const HomeScreen(),
    const SpendingBreakdownScreen(),
    Container(), // Placeholder for the center FAB action
    const SavingsScreen(),
    const ReportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Special handling for center button (index 2) to open add transaction
          if (index == 2) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const AddTransactionScreen()));
          } else {
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }
}