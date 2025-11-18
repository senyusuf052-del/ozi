import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vites2/screens/create_garage_screen.dart';
import 'package:vites2/services/garage_service.dart';

class DiscoverGaragesScreen extends StatefulWidget {
  const DiscoverGaragesScreen({super.key});

  @override
  State<DiscoverGaragesScreen> createState() => _DiscoverGaragesScreenState();
}

class _DiscoverGaragesScreenState extends State<DiscoverGaragesScreen> {
  final GarageService _garageService = GarageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garajları Keşfet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateGarageScreen()));
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _garageService.getGaragesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Henüz hiç garaj oluşturulmamış.'));
          }

          final garages = snapshot.data!.docs;

          return ListView.builder(
            itemCount: garages.length,
            itemBuilder: (context, index) {
              final garage = garages[index];
              final data = garage.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['name'] ?? 'İsimsiz Garaj'),
                subtitle: Text(data['description'] ?? ''),
                trailing: ElevatedButton(
                  onPressed: () async {
                    try {
                      await _garageService.joinGarage(garage.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Garaja katıldın!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Katılma başarısız: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Katıl'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
