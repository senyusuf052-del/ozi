import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mevcut kullanıcının profil verilerini getir
  Future<DocumentSnapshot?> getUserProfile() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return null;
    }
    return await _firestore.collection('users').doc(currentUser.uid).get();
  }

  // Kullanıcı profilini güncelle
  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .update(data);
    }
  }
}
