import 'package:flutter/material.dart';

class WishlistLibro {
  String titulo;
  String autor;
  String? notas;

  WishlistLibro({required this.titulo, required this.autor, this.notas});
}

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  // Lista de ejemplo para la lista de deseos
  final List<WishlistLibro> _wishlist = [
    WishlistLibro(
      titulo: 'El nombre del viento',
      autor: 'Patrick Rothfuss',
      notas: 'Edición de bolsillo recomendada.',
    ),
    WishlistLibro(
      titulo: 'Fahrenheit 451',
      autor: 'Ray Bradbury',
      notas: 'Comprar en la próxima feria del libro.',
    ),
  ];

  void _mostrarDialogoAgregar() {
    final tituloController = TextEditingController();
    final autorController = TextEditingController();
    final notasController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF5F1E8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE3DCC9), width: 1.5),
          ),
          title: const Text(
            'Añadir a la Wishlist',
            style: TextStyle(color: Color(0xFF3E2C1C), fontFamily: 'serif', fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título del libro',
                    labelStyle: TextStyle(color: Color(0xFF3E2C1C)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF556B2F)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: autorController,
                  decoration: const InputDecoration(
                    labelText: 'Autor/a',
                    labelStyle: TextStyle(color: Color(0xFF3E2C1C)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF556B2F)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notasController,
                  decoration: const InputDecoration(
                    labelText: 'Notas o razones (opcional)',
                    labelStyle: TextStyle(color: Color(0xFF3E2C1C)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF556B2F)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Color(0xFF3E2C1C))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF556B2F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (tituloController.text.trim().isNotEmpty && autorController.text.trim().isNotEmpty) {
                  setState(() {
                    _wishlist.add(
                      WishlistLibro(
                        titulo: tituloController.text.trim(),
                        autor: autorController.text.trim(),
                        notas: notasController.text.trim().isEmpty ? null : notasController.text.trim(),
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _eliminarWishlist(int index) {
    setState(() {
      _wishlist.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Libro eliminado de la Wishlist.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabecera
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Wishlist',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E2C1C),
                          fontFamily: 'serif',
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.bookmark,
                        color: Color(0xFF556B2F),
                        size: 22,
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF3E2C1C), width: 1.2),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Color(0xFF3E2C1C), size: 20),
                      onPressed: _mostrarDialogoAgregar,
                      tooltip: 'Añadir deseo',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Lista de deseos
              Expanded(
                child: _wishlist.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.bookmark_border, size: 48, color: Color(0xFFB5A895)),
                            SizedBox(height: 8),
                            Text(
                              'Tu lista de deseos está vacía.\n¡Añade tu próximo libro por leer!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black54, fontSize: 13),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _wishlist.length,
                        itemBuilder: (context, index) {
                          final libro = _wishlist[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE3DCC9), width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F1E8),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF556B2F), width: 1),
                                ),
                                child: const Icon(Icons.menu_book, color: Color(0xFF556B2F), size: 18),
                              ),
                              title: Text(
                                libro.titulo,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF3E2C1C),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 2),
                                  Text(
                                    libro.autor,
                                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                                  ),
                                  if (libro.notas != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      libro.notas!,
                                      style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF556B2F)),
                                    ),
                                  ],
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                onPressed: () => _eliminarWishlist(index),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}