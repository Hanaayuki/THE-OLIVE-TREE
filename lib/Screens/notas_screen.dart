import 'package:flutter/material.dart';
import '../Data/database_helper.dart';
import 'Notas_libro_screen.dart';

class NotasScreen extends StatefulWidget {
  const NotasScreen({super.key});

  @override
  State<NotasScreen> createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {
  List<Map<String, dynamic>> _librosConNotas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarLibros();
  }

  Future<void> _cargarLibros() async {
    final libros = await DatabaseHelper.instance.obtenerLibrosConNotas();
    setState(() {
      _librosConNotas = libros;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mis Notas por Libro',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3E2C1C),
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : _librosConNotas.isEmpty
                    ? const Center(
                        child: Text(
                          'No tienes notas guardadas en ningún libro.',
                          style: TextStyle(color: Colors.black45),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _librosConNotas.length,
                        itemBuilder: (context, index) {
                          final libro = _librosConNotas[index];
                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.book, color: Color(0xFF556B2F)),
                              title: Text(
                                libro['titulo_libro'],
                                style: const TextStyle(
                                  color: Color(0xFF3E2C1C),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                // Al tocar el libro, abrimos sus notas específicas
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotasLibroScreen(
                                      libroId: libro['libro_id'],
                                      tituloLibro: libro['titulo_libro'],
                                    ),
                                  ),
                                ).then((_) => _cargarLibros()); // Refresca al volver
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}