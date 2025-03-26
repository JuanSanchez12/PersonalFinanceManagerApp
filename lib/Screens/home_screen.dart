import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          
          // Balance Container
          Container(
            width: double.infinity,
            color: Colors.blue,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Balance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '\$5,284.50',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Transactions Title
          Padding(
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
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.shopping_cart),
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Grocery Store'),
                  ),
                  trailing: Text('\$85.40'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.attach_money),
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Salary'),
                  ),
                  trailing: Text('\$2500.00'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.bolt),
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Electric Bill'),
                  ),
                  trailing: Text('\$120.35'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.movie),
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Movie'),
                  ),
                  trailing: Text('\$24.00'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.savings),
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Savings'),
                  ),
                  trailing: Text('\$500.00'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.build),
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Hardware'),
                  ),
                  trailing: Text('\$45.20'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.bolt),
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Internet'),
                  ),
                  trailing: Text('\$65.00'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}