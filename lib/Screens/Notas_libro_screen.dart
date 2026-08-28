import 'package:flutter/material.dart';
import '../Data/database_helper.dart';

class NotasLibroScreen extends StatefulWidget {
  final String libroId;
  final String tituloLibro;

  const NotasLibroScreen({super.key, required this.libroId, required this.tituloLibro});

  @override
  State<NotasLibroScreen> createState() => _NotasLibroScreenState();
}

class _NotasLibroScreenState extends State<NotasLibroScreen> {
  List<Map<String, dynamic>> _notas = [];

  @override
  void initState() {
    super.initState();
    _cargarNotas();
  }

  Future<void> _cargarNotas() async {
    final notas = await DatabaseHelper.instance.obtenerNotasPorLibro(widget.libroId);
    setState(() {
      _notas = notas;
    });
  }

  Future<void> _eliminarNota(int id) async {
    await DatabaseHelper.instance.eliminarNota(id);
    _cargarNotas(); // Recarga la lista tras borrar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Un fondo suave acorde a tu diseño
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3E2C1C)),
        title: Text(
          widget.tituloLibro,
          style: const TextStyle(color: Color(0xFF3E2C1C), fontFamily: 'serif'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _notas.isEmpty
            ? const Center(child: Text('No hay notas.'))
            : ListView.builder(
                itemCount: _notas.length,
                itemBuilder: (context, index) {
                  final nota = _notas[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        nota['contenido'],
                        style: const TextStyle(color: Color(0xFF3E2C1C)),
                      ),
                      subtitle: Text(
                        'Página: ${nota['pagina']}',
                        style: const TextStyle(color: Color(0xFF556B2F), fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () => _eliminarNota(nota['id']),
                      ),
                      onTap: () {
                        // TODO: Aquí pondrías el código para enviar al usuario
                        // a la pantalla del lector PDF en la página específica.
                        // Ej: Navigator.push(..., LectorPDFScreen(pagina: nota['pagina']));
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}