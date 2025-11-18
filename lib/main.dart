import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vites2/auth_gate.dart';
import 'package:vites2/screens/feed_screen.dart';
import 'package:vites2/screens/garage_hub_screen.dart';
import 'package:vites2/screens/profile_screen.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    FeedScreen(),
    GarageHubScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Akış',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Garajlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
