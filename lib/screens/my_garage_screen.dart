import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vites2/screens/garage_chat_screen.dart';
import 'package:vites2/services/garage_service.dart';

class MyGarageScreen extends StatefulWidget {
  final String garageId;

  const MyGarageScreen({super.key, required this.garageId});

  @override
  State<MyGarageScreen> createState() => _MyGarageScreenState();
}

class _MyGarageScreenState extends State<MyGarageScreen> {
  final GarageService _garageService = GarageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benim Garajım'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('garages').doc(widget.garageId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Garaj bulunamadı.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'] ?? 'İsimsiz Garaj',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(data['description'] ?? ''),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => GarageChatScreen(garageId: widget.garageId)));
                  },
                  child: const Text('Sohbete Gir'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    try {
                      await _garageService.leaveGarage(widget.garageId);
                      if(mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Garajdan ayrıldın.'), backgroundColor: Colors.green),
                        );
                      }
                    } catch (e) {
                       if(mounted) {
                         ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ayrılma başarısız: ${e.toString()}'), backgroundColor: Colors.red),
                        );
                       }
                    }
                  },
                  child: const Text('Garajdan Ayrıl', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
