import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:vites2/models/post.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Upload image and create a new post
  Future<void> createPost(String caption, XFile image) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    // Upload image to Firebase Storage
    final String postId = const Uuid().v4();
    final Reference ref = _storage.ref().child('posts').child('$postId.jpg');
    await ref.putFile(File(image.path));
    final String imageUrl = await ref.getDownloadURL();

    // Create post in Firestore
    await _firestore.collection('posts').doc(postId).set({
      'imageUrl': imageUrl,
      'caption': caption,
      'userId': currentUser.uid,
      'timestamp': Timestamp.now(),
    });
  }

  // Get a stream of all posts
  Stream<List<Post>> getPostsStream() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Post.fromSnapshot(doc)).toList();
    });
  }
}
