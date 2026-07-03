import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this later for buy link

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
  String userId = "test_user"; // Change later with real login

  Future<void> _launchBuy() async {
    const url = 'https://selfservice.kplc.co.ke/'; // Or *977# link
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StimaQuick - KPLC'), backgroundColor: Colors.green),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: _nicknameController, decoration: const InputDecoration(labelText: 'Nickname')),
                TextField(controller: _meterController, decoration: const InputDecoration(labelText: 'Meter Number')),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_meterController.text.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection('users').doc(userId).collection('meters')
                          .doc(_meterController.text)
                          .set({
                            'nickname': _nicknameController.text,
                            'meterNumber': _meterController.text,
                            'lastBalance': 0,
                            'lastUpdated': FieldValue.serverTimestamp(),
                          });
                      _meterController.clear();
                      _nicknameController.clear();
                    }
                  },
                  child: const Text('Add Meter'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _launchBuy,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('Buy Tokens (opens KPLC)'),
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Your Meters & Balance', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users').doc(userId).collection('meters').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final meters = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: meters.length,
                  itemBuilder: (context, index) {
                    final meter = meters[index].data() as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.power, color: Colors.green),
                        title: Text(meter['nickname'] ?? 'Meter'),
                        subtitle: Text('Balance: ${meter['lastBalance']} units • ${meter['meterNumber']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.notifications),
                          onPressed: () {
                            // Reminder logic coming next
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Reminder set (demo)')),
                            );
                          },
                        ),
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
