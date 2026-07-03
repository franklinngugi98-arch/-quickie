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
      appBar: AppBar(title: const Text('StimaQuick - KPLC')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('Your Smart Meter Balance Will Show Here'),
            // We'll add real balance later
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
