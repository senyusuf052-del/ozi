import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vites2/models/garage.dart';
import 'package:vites2/services/garage_service.dart';

class GarageDetailsScreen extends StatefulWidget {
  final Garage garage;

  const GarageDetailsScreen({super.key, required this.garage});

  @override
  State<GarageDetailsScreen> createState() => _GarageDetailsScreenState();
}

class _GarageDetailsScreenState extends State<GarageDetailsScreen> {
  final GarageService _garageService = GarageService();
  final _emailController = TextEditingController();

  bool get _isOwner {
    return FirebaseAuth.instance.currentUser?.uid == widget.garage.owner;
  }

  void _showAddMemberDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Üye Ekle'),
          content: TextField(
            controller: _emailController,
            decoration: const InputDecoration(hintText: "Kullanıcı e-postası"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _garageService.addMemberToGarage(
                      widget.garage.id, _emailController.text);
                  Navigator.pop(context);
                  _emailController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Üye başarıyla eklendi!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Üye eklenemedi: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  void _showLeaveGarageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Garajdan Ayrıl'),
          content: const Text('Bu garajdan ayrılmak istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _garageService.leaveGarage(widget.garage.id);
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(context); // Go back to the garages list
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Garajdan başarıyla ayrıldınız.')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Garajdan ayrılamadı: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Ayrıl'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.garage.name),
        actions: [
          if (_isOwner)
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: _showAddMemberDialog,
            )
          else
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: _showLeaveGarageDialog,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Üyeler (${widget.garage.members.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.garage.members.length,
                itemBuilder: (context, index) {
                  final memberId = widget.garage.members[index];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(memberId),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
