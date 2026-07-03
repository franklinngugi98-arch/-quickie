import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save or update meter
  Future<void> saveMeter(String userId, String meterNumber, String nickname) async {
    await _db.collection('users').doc(userId).collection('meters').doc(meterNumber).set({
      'nickname': nickname,
      'meterNumber': meterNumber,
      'lastBalance': 0,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Get meters for user
  Stream<QuerySnapshot> getMeters(String userId) {
    return _db.collection('users').doc(userId).collection('meters').snapshots();
  }
}
