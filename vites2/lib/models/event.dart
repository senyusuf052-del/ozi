import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final Timestamp date;
  final String organizerId;
  final List<String> participants;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.organizerId,
    required this.participants,
  });

  factory Event.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Event(
      id: snapshot.id,
      title: data['title'],
      description: data['description'],
      date: data['date'],
      organizerId: data['organizerId'],
      participants: List<String>.from(data['participants']),
    );
  }
}
