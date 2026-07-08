import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../Data/database_helper.dart';
import 'agregar_libro_screen.dart';

class BibliotecaScreen extends StatefulWidget {
  const BibliotecaScreen({super.key});

  @override
  State<BibliotecaScreen> createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen> {
  List<Libro> misLibros = [];

  @override
  void initState() {
    super.initState();
    _cargarLibros(); 
  }

  Future<void> _cargarLibros() async {
    final librosDb = await DatabaseHelper.instance.getLibros();
    setState(() {
      misLibros = librosDb;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Biblioteca'),
        backgroundColor: Colors.brown,
      ),
      body: misLibros.isEmpty
          ? const Center(
              child: Text(
                'Aún no tienes libros.\n¡Pulsa el botón + para añadir uno!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: misLibros.length,
              itemBuilder: (context, index) {
                final libro = misLibros[index];
                return ListTile(
                  leading: const Icon(Icons.book, color: Colors.brown),
                  title: Text(libro.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(libro.autor),
                  trailing: Text(libro.estado),
                );
              },
            ),
floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AgregarLibroScreen(),
            ),
          );

          if (resultado == true) {
            // Aquí recargarás tu lista más adelante
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ), // Cierra FloatingActionButton
    ); // Cierra Scaffold
  } // Cierra build
} // Cierra la clase _BibliotecaScreenState