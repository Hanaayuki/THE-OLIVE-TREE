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
  List<Libro> librosFiltrados = [];
  bool _buscando = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarLibros();
    _searchController.addListener(_filtrarLibrosPorTexto);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarLibros() async {
    final librosDb = await DatabaseHelper.instance.getLibros();

    if (mounted) {
      setState(() {
        misLibros = librosDb;
        librosFiltrados = librosDb;
      });
    }
  }

  void _filtrarLibrosPorTexto() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      librosFiltrados = misLibros.where((libro) {
        final tituloLower = libro.titulo.toLowerCase();
        final autorLower = libro.autor.toLowerCase();
        return tituloLower.contains(query) || autorLower.contains(query);
      }).toList();
    });
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
          content: Text('Este libro no tiene ningún PDF asociado.'),
        ),
      );
    }
  }

  Future<void> _eliminarLibro(Libro libro) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF5F1E8),
          title: const Text('Eliminar libro'),
          content: Text('¿Quieres eliminar "${libro.titulo}" de tu biblioteca?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar', style: TextStyle(color: Color(0xFF3E2C1C))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF556B2F)),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    if (libro.id != null) {
      await DatabaseHelper.instance.deleteLibro(libro.id!);
    }

    if (mounted) {
      setState(() {
        misLibros.removeWhere((item) => item.id == libro.id);
        _filtrarLibrosPorTexto();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Libro eliminado de la biblioteca.')),
      );
    }
  }

  Future<void> _irAgregarLibro() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgregarLibroScreen(),
      ),
    );

    if (resultado == true) {
      _cargarLibros();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera (Título y Buscador)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buscando
                        ? TextField(
                            controller: _searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Buscar por título o autor...',
                              hintStyle: const TextStyle(color: Colors.black45, fontSize: 14),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.close, size: 20, color: Color(0xFF3E2C1C)),
                                onPressed: () {
                                  setState(() {
                                    _buscando = false;
                                    _searchController.clear();
                                  });
                                },
                              ),
                            ),
                            style: const TextStyle(fontSize: 16, color: Color(0xFF3E2C1C)),
                          )
                        : Row(
                            children: const [
                              Text(
                                'Biblioteca',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E2C1C),
                                  fontFamily: 'serif',
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.eco,
                                color: Color(0xFF556B2F),
                                size: 22,
                              ),
                            ],
                          ),
                  ),
                  if (!_buscando)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF3E2C1C), width: 1.2),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.search, color: Color(0xFF3E2C1C), size: 20),
                        onPressed: () {
                          setState(() {
                            _buscando = true;
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),

            // Barra de filtrado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBE5D8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD4CCb8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.filter_list, size: 16, color: Color(0xFF3E2C1C)),
                        SizedBox(width: 4),
                        Text(
                          'Filtrar',
                          style: TextStyle(
                            color: Color(0xFF3E2C1C),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: Color(0xFF3E2C1C), size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // CUADRÍCULA DE LIBROS EN 3 COLUMNAS
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.50,
                ),
                itemCount: librosFiltrados.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return InkWell(
                      onTap: _irAgregarLibro,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFECE4),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF8AA05B),
                            style: BorderStyle.solid,
                            width: 1.8,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add,
                              size: 32,
                              color: Color(0xFF556B2F),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Añadir\nlibro',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF3E2C1C),
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final libro = librosFiltrados[index - 1];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () => _abrirLibro(libro),
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: libro.portada != null && libro.portada!.isNotEmpty
                                        ? Image.file(
                                            File(libro.portada!),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: const Color(0xFFE8E2D6),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    size: 30,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : Container(
                                            color: const Color(0xFFE8E2D6),
                                            child: const Center(
                                              child: Icon(
                                                Icons.menu_book,
                                                size: 30,
                                                color: Color(0xFF556B2F),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  libro.titulo,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Color(0xFF3E2C1C),
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  libro.autor,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            iconSize: 16,
                            icon: const Icon(
                              Icons.more_vert,
                              size: 16,
                              color: Color(0xFF3E2C1C),
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
                                child: Text('Abrir libro'),
                              ),
                              const PopupMenuItem(
                                value: 'eliminar',
                                child: Text('Eliminar libro'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}