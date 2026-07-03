import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const StimaQuickApp());
}

class StimaQuickApp extends StatelessWidget {
  const StimaQuickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StimaQuick',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _meterController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  String userId = "test_user";
  Timer? _countdownTimer;
  int remainingSeconds = 3600; // Example starting point

  String formatToken(String token) {
    token = token.replaceAll(RegExp(r'[^0-9]'), '');
    RegExp exp = RegExp(r".{1,4}");
    return exp.allMatches(token).map((m) => m.group(0)).join(" ");
  }

  Future<void> _copyToken(String token) async {
    await Clipboard.setData(ClipboardData(text: token));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Token copied!')));
  }

  Future<void> _launchBuy() async {
    const url = 'https://selfservice.kplc.co.ke/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void startCountdown(double currentBalance) {
    _countdownTimer?.cancel();
    // Estimate based on usage rate (demo - replace with real rate calculation)
    double estimatedRatePerSecond = 0.001; // Adjust based on your appliances
    remainingSeconds = (currentBalance / estimatedRatePerSecond).round();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          remainingSeconds = remainingSeconds > 0 ? remainingSeconds - 1 : 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StimaQuick - KPLC Tokens'), backgroundColor: Colors.green),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: _nicknameController, decoration: const InputDecoration(labelText: 'Nickname')),
                TextField(controller: _meterController, decoration: const InputDecoration(labelText: 'Meter Number')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: () async { /* add meter */ }, child: const Text('Add Meter')),
                    ElevatedButton(onPressed: _launchBuy, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange), child: const Text('Buy Tokens')),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(userId).collection('meters').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final meters = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: meters.length,
                  itemBuilder: (context, index) {
                    final meter = meters[index].data() as Map<String, dynamic>;
                    String tokenExample = "12345678901234567890";
                    double balance = (meter['lastBalance'] ?? 0).toDouble();
                    startCountdown(balance); // Start countdown for this meter
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.power, color: Colors.green),
                            title: Text(meter['nickname'] ?? 'Meter'),
                            subtitle: Text('Balance: $balance units'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text("Recent Token: ${formatToken(tokenExample)}"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(onPressed: () => _copyToken(tokenExample), child: const Text('Copy')),
                                    ElevatedButton(onPressed: () {}, child: const Text('Mark as Loaded')),
                                  ],
                                ),
                                Text('Countdown: ${remainingSeconds \~/ 60} min ${remainingSeconds % 60} sec left (est.)'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 100,
                            child: LineChart(
                              LineChartData(
                                gridData: const FlGridData(show: false),
                                titlesData: const FlTitlesData(show: false),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: const [FlSpot(0, 100), FlSpot(1, 80), FlSpot(2, 60), FlSpot(3, 40)],
                                    isCurved: true,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
