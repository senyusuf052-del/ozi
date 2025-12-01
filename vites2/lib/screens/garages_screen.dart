import 'package:flutter/material.dart';
import 'package:vites2/models/garage.dart';
import 'package:vites2/screens/create_garage_screen.dart';
import 'package:vites2/screens/garage_details_screen.dart';
import 'package:vites2/services/garage_service.dart';

class GaragesScreen extends StatefulWidget {
  const GaragesScreen({super.key});

  @override
  State<GaragesScreen> createState() => _GaragesScreenState();
}

class _GaragesScreenState extends State<GaragesScreen> {
  final GarageService _garageService = GarageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garajlar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateGarageScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Garage>>(
        stream: _garageService.getGaragesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Bir hata oluştu'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Henüz bir garajınız yok.'));
          }

          final garages = snapshot.data!;

          return ListView.builder(
            itemCount: garages.length,
            itemBuilder: (context, index) {
              final garage = garages[index];
              return ListTile(
                title: Text(garage.name),
                subtitle: Text('Üye Sayısı: ${garage.members.length}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GarageDetailsScreen(garage: garage),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
