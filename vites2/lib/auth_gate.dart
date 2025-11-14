import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vites2/screens/login_screen.dart';
import 'package:vites2/main.dart'; // HomePage'i import etmek için

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Kullanıcı giriş yapmamışsa
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // Kullanıcı giriş yapmışsa
        return const HomePage();
      },
    );
  }
}
