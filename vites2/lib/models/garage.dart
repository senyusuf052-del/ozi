import 'package:cloud_firestore/cloud_firestore.dart';

class Garage {
  final String id;
  final String name;
  final String owner;
  final List<String> members;

  Garage({
    required this.id,
    required this.name,
    required this.owner,
    required this.members,
  });

  factory Garage.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Garage(
      id: snapshot.id,
      name: data['name'],
      owner: data['owner'],
      members: List<String>.from(data['members']),
    );
  }
}
