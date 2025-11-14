import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Kayıt olma metodu
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // FirebaseAuthException'ı tekrar fırlat, böylece UI katmanı
      // hatanın türüne göre spesifik mesajlar gösterebilir.
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Bilinmeyen bir hata oluştu.');
    }
  }

  // Giriş yapma metodu
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

  // Çıkış yapma metodu
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
