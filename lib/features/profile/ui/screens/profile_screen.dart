import 'package:appmovil261/features/profile/ui/pages/home_page.dart';
import 'package:appmovil261/features/profile/ui/pages/posts_page.dart';
import 'package:appmovil261/features/profile/ui/pages/profile_page.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 0;

  static const _pages = <Widget>[
    ProfilePage(),
    HomePage(),
    PostsPage(),
  ];

  static const _titles = ['Perfil', 'Home', 'Nuevo Post'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex])),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Posts'),
        ],
      ),
    );
  }
}
