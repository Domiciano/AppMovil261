import 'package:appmovil261/features/home/ui/pages/home_page.dart';
import 'package:appmovil261/features/post/ui/pages/posts_page.dart';
import 'package:appmovil261/features/profile/ui/pages/profile_page.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
