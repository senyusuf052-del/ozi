import 'package:flutter/material.dart';
import 'package:vites2/services/garage_service.dart';

class CreateGarageScreen extends StatefulWidget {
  const CreateGarageScreen({super.key});

  @override
  State<CreateGarageScreen> createState() => _CreateGarageScreenState();
}

class _CreateGarageScreenState extends State<CreateGarageScreen> {
  final _nameController = TextEditingController();
  final _garageService = GarageService();

  void _createGarage() async {
    final name = _nameController.text;
    if (name.isNotEmpty) {
      await _garageService.createGarage(name);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Garaj Oluştur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Garaj Adı'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createGarage,
              child: const Text('Oluştur'),
            ),
          ],
        ),
      ),
    );
  }
}
