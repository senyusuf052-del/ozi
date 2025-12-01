import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vites2/models/garage.dart';

class GarageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new garage
  Future<void> createGarage(String name) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    await _firestore.collection('garages').add({
      'name': name,
      'owner': currentUser.uid,
      'members': [currentUser.uid],
      'createdAt': Timestamp.now(),
    });
  }

  // Get a stream of garages for the current user
  Stream<List<Garage>> getGaragesStream() {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('garages')
        .where('members', arrayContains: currentUser.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Garage.fromSnapshot(doc)).toList();
    });
  }

  // Get user UID by email
  Future<String?> getUserUidByEmail(String email) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    }
    return null;
  }

  // Add a member to a garage
  Future<void> addMemberToGarage(String garageId, String email) async {
    final userUid = await getUserUidByEmail(email);
    if (userUid != null) {
      await _firestore.collection('garages').doc(garageId).update({
        'members': FieldValue.arrayUnion([userUid]),
      });
    } else {
      throw Exception('User not found');
    }
  }

  // Leave a garage
  Future<void> leaveGarage(String garageId) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    await _firestore.collection('garages').doc(garageId).update({
      'members': FieldValue.arrayRemove([currentUser.uid]),
    });
  }
}
