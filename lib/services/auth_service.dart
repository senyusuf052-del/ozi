import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kayıt olma metodu
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      // 1. Authentication'da kullanıcı oluştur
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? newUser = result.user;

      // 2. Firestore'da kullanıcı dokümanı oluştur
      if (newUser != null) {
        await _firestore.collection('users').doc(newUser.uid).set({
          'uid': newUser.uid,
          'email': email,
          // İleride buraya eklenecek diğer profil bilgileri (kullanıcı adı, araçlar vb.)
        });
      }

      return newUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Bilinmeyen bir hata oluştu.');
    }
  }

  // Giriş yapma metodu (değişiklik yok)
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Bilinmeyen bir hata oluştu.');
    }
  }

  // Çıkış yapma metodu (değişiklik yok)
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
