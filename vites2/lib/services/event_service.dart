import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vites2/models/event.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new event
  Future<void> createEvent(String title, String description, DateTime date) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    await _firestore.collection('events').add({
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'organizerId': currentUser.uid,
      'participants': [currentUser.uid],
    });
  }

  // Get a stream of all events
  Stream<List<Event>> getEventsStream() {
    return _firestore
        .collection('events')
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromSnapshot(doc)).toList();
    });
  }

  // Join or leave an event (RSVP)
  Future<void> rsvpEvent(String eventId, bool isJoining) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    await _firestore.collection('events').doc(eventId).update({
      'participants': isJoining
          ? FieldValue.arrayUnion([currentUser.uid])
          : FieldValue.arrayRemove([currentUser.uid]),
    });
  }
}
