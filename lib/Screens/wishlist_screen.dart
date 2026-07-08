import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mi Wishlist")),
      body: const Center(child: Text("Aquí verás tus libros deseados")),
    );
  }
}