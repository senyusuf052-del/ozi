import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GarageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createGarage(String name, String description) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("Bu işlemi yapmak için giriş yapmalısınız.");
    }

    final garageRef = await _firestore.collection('garages').add({
      'name': name,
      'description': description,
      'creator_uid': currentUser.uid,
      'members': [currentUser.uid],
      'created_at': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('users').doc(currentUser.uid).update({
      'garage_id': garageRef.id,
    });
  }

  Future<void> joinGarage(String garageId) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("Bu işlemi yapmak için giriş yapmalısınız.");
    }

    await _firestore.collection('garages').doc(garageId).update({
      'members': FieldValue.arrayUnion([currentUser.uid]),
    });

    await _firestore.collection('users').doc(currentUser.uid).update({
      'garage_id': garageId,
    });
  }

  Stream<QuerySnapshot> getGaragesStream() {
    return _firestore.collection('garages').orderBy('created_at', descending: true).snapshots();
  }

  Future<void> leaveGarage(String garageId) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("Bu işlemi yapmak için giriş yapmalısınız.");
    }

    await _firestore.collection('garages').doc(garageId).update({
      'members': FieldValue.arrayRemove([currentUser.uid]),
    });

    await _firestore.collection('users').doc(currentUser.uid).update({
      'garage_id': FieldValue.delete(),
    });
  }

  Stream<QuerySnapshot> getGarageMessagesStream(String garageId) {
    return _firestore
        .collection('garages')
        .doc(garageId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(String garageId, String text) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("Mesaj göndermek için giriş yapmalısınız.");
    }

    final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
    final username = userDoc.data()?['username'] ?? currentUser.email;

    await _firestore
        .collection('garages')
        .doc(garageId)
        .collection('messages')
        .add({
      'text': text,
      'sender_uid': currentUser.uid,
      'sender_username': username,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
