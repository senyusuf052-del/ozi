import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String imageUrl;
  final String caption;
  final String userId;
  final Timestamp timestamp;

  Post({
    required this.id,
    required this.imageUrl,
    required this.caption,
    required this.userId,
    required this.timestamp,
  });

  factory Post.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Post(
      id: snapshot.id,
      imageUrl: data['imageUrl'],
      caption: data['caption'],
      userId: data['userId'],
      timestamp: data['timestamp'],
    );
  }
}
