import 'package:flutter/material.dart';

void main() {
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vites2'),
      ),
      body: const Center(
        child: Text('Vites2 Ana Sayfa'),
      ),
    );
  }
}
