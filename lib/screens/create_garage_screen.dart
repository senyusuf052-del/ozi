import 'package:flutter/material.dart';
import 'package:vites2/services/garage_service.dart';

class CreateGarageScreen extends StatefulWidget {
  const CreateGarageScreen({super.key});

  @override
  State<CreateGarageScreen> createState() => _CreateGarageScreenState();
}

class _CreateGarageScreenState extends State<CreateGarageScreen> {
  final GarageService _garageService = GarageService();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  void _submitForm() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Garaj adı boş olamaz.'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _garageService.createGarage(_nameController.text, _descriptionController.text);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Garaj oluşturulamadı: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
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
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Açıklama'),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Oluştur'),
                  ),
          ],
        ),
      ),
    );
  }
}
