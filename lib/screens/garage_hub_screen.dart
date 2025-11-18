import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vites2/screens/discover_garages_screen.dart';
import 'package:vites2/screens/my_garage_screen.dart';

class GarageHubScreen extends StatelessWidget {
  const GarageHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text("Lütfen giriş yapın."));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Bir hata oluştu."));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const DiscoverGaragesScreen();
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final garageId = userData['garage_id'];

        if (garageId != null) {
          return MyGarageScreen(garageId: garageId);
        } else {
          return const DiscoverGaragesScreen();
        }
      },
    );
  }
}
