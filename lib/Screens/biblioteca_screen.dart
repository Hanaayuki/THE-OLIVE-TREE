import 'dart:io';

import 'package:flutter/material.dart';

import '../models/libro.dart';
import '../Data/database_helper.dart';
import 'agregar_libro_screen.dart';
import 'lector_pdf_screen.dart';

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

    if (mounted) {
      setState(() {
        misLibros = librosDb;
      });
    }
  }

  void _abrirLibro(Libro libro) {
    if (libro.rutaPdf != null && libro.rutaPdf!.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LectorPdfScreen(
            rutaPdf: libro.rutaPdf!,
            titulo: libro.titulo,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Este libro no tiene ningún PDF asociado.',
          ),
        ),
      );
    }
  }

  Future<void> _eliminarLibro(Libro libro) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar libro'),
          content: Text(
            '¿Quieres eliminar "${libro.titulo}" de tu biblioteca?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    if (libro.id != null) {
      await DatabaseHelper.instance.deleteLibro(libro.id!);
    }

    if (mounted) {
      setState(() {
        misLibros.removeWhere(
          (item) => item.id == libro.id,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Libro eliminado de la biblioteca.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Biblioteca',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: misLibros.isEmpty
          ? const Center(
              child: Text(
                'Tu biblioteca está vacía.\n'
                'Pulsa + para añadir tu primer libro.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemCount: misLibros.length,
              itemBuilder: (context, index) {
                final libro = misLibros[index];

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          _abrirLibro(libro);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8E2D6),
                                    borderRadius:
                                        BorderRadius.circular(16),
                                  ),
                                  child: libro.portada != null &&
                                          libro.portada!.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Image.file(
                                            File(libro.portada!),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        )
                                      : const Center(
                                          child: Icon(
                                            Icons.menu_book,
                                            size: 60,
                                            color:
                                                Color(0xFF556B2F),
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                libro.titulo,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                libro.autor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                libro.estado,
                                style: const TextStyle(
                                  color: Color(0xFF556B2F),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        top: 4,
                        right: 4,
                        child: PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.black87,
                          ),
                          onSelected: (valor) {
                            if (valor == 'abrir') {
                              _abrirLibro(libro);
                            } else if (valor == 'eliminar') {
                              _eliminarLibro(libro);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'abrir',
                              child: Row(
                                children: [
                                  Icon(Icons.menu_book),
                                  SizedBox(width: 10),
                                  Text('Abrir libro'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'eliminar',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline),
                                  SizedBox(width: 10),
                                  Text('Eliminar libro'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const AgregarLibroScreen(),
            ),
          );

          if (resultado == true) {
            _cargarLibros();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}