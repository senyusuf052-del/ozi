import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final String fileName = const Uuid().v4();
      final Reference ref = _storage.ref().child('posts').child(fileName);

      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> createPost(String text, {File? imageFile}) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("Bu işlemi yapmak için giriş yapmalısınız.");
    }

    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _uploadImage(imageFile);
    }

    final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
    final username = userDoc.data()?['username'] ?? currentUser.email;

    await _firestore.collection('posts').add({
      'text': text,
      'imageUrl': imageUrl,
      'author_uid': currentUser.uid,
      'author_username': username,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getPostsStream() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
