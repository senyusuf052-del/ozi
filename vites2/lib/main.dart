import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vites2/auth_gate.dart';
import 'package:vites2/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Vites2App());
}

class Vites2App extends StatelessWidget {
  const Vites2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vites2',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
      ),
      home: const AuthGate(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vites2 Ana Sayfa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Giriş yapıldı!'),
      ),
    );
  }
}
