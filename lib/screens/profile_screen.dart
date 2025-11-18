import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vites2/services/auth_service.dart';
import 'package:vites2/services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot?>(
        future: _profileService.getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Profil bilgileri bulunamadı.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data == null) {
            return const Center(child: Text('Profil verileri boş.'));
          }
          _usernameController.text = data['username'] ?? '';

          final garageId = data['garage_id'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('E-posta: ${data['email'] ?? 'Belirtilmemiş'}'),
                const SizedBox(height: 8),
                Text('UID: ${data['uid'] ?? 'Belirtilmemiş'}'),
                const SizedBox(height: 16),
                if (garageId != null)
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('garages').doc(garageId).get(),
                    builder: (context, garageSnapshot) {
                      if (garageSnapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Garaj yükleniyor...');
                      }
                      if (!garageSnapshot.hasData || garageSnapshot.data == null) {
                        return const Text('Garaj: Bulunamadı');
                      }
                      final garageData = garageSnapshot.data!.data() as Map<String, dynamic>?;
                      return Text('Garaj: ${garageData?['name'] ?? 'İsimsiz Garaj'}');
                    },
                  ),
                const SizedBox(height: 24),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await _profileService.updateUserProfile({
                        'username': _usernameController.text,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profil güncellendi!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      setState(() {});
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Hata: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Kaydet'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
