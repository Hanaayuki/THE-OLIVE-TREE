import 'package:flutter/material.dart';

class ResenasScreen extends StatelessWidget {
  const ResenasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Reseñas"),
        backgroundColor: Colors.green, // Un toque de color para tu app
      ),
      body: const Center(
        child: Text(
          "Aquí verás tus notas de lectura",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}