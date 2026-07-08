import 'package:flutter/material.dart';
import 'package:the_olive_tree/Screens/resenas_screen.dart';
import 'screens/biblioteca_screen.dart';
import 'screens/wishlist_screen.dart';


void main() => runApp(const OliveTreeApp());

class OliveTreeApp extends StatelessWidget {
  const OliveTreeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final List<Widget> _paginas = [
    const BibliotecaScreen(),
    const WishlistScreen(),
    const ResenasScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _paginas[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) => setState(() => _index = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Biblioteca'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Reseñas'),
        ],
      ),
    );
  }
}