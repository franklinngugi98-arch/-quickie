import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const StimaQuickApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background notifications
}

class StimaQuickApp extends StatefulWidget {
  const StimaQuickApp({super.key});

  @override
  State<StimaQuickApp> createState() => _StimaQuickAppState();
}

class _StimaQuickAppState extends State<StimaQuickApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StimaQuick',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      home: HomeScreen(toggleTheme: toggleTheme),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const HomeScreen({super.key, required this.toggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ... (keep your existing controllers and logic)
  // Add the rest from previous full code, with Settings button in AppBar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StimaQuick - KPLC Tokens'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: widget.toggleTheme, icon: const Icon(Icons.brightness_6)),
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen(toggleTheme: widget.toggleTheme))), icon: const Icon(Icons.settings)),
        ],
      ),
      // Rest of your body from previous code
    );
  }
}

// Simple Settings Screen
class SettingsScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  const SettingsScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            trailing: const Icon(Icons.brightness_6),
            onTap: toggleTheme,
          ),
          ListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Low balance alerts enabled'),
          ),
          const ListTile(
            title: Text('About'),
            subtitle: Text('StimaQuick v1.0'),
          ),
        ],
      ),
    );
  }
}
