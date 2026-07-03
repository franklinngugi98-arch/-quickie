import 'package:flutter/material.dart';

void main() {
  runApp(const StimaQuickApp());
}

class StimaQuickApp extends StatelessWidget {
  const StimaQuickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StimaQuick',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StimaQuick - KPLC Tokens'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.power, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'Welcome to StimaQuick',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Your Smart Meter Balance & Reminders'),
            SizedBox(height: 40),
            Text('Next: Add your meter number'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // We'll add buy or add meter action here later
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
