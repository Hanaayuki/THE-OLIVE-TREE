import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; 
import '../Data/database_helper.dart'; 
import '../models/libro.dart';

class AgregarLibroScreen extends StatefulWidget {
  const AgregarLibroScreen({super.key});

  @override
  _AgregarLibroScreenState createState() => _AgregarLibroScreenState();
}

class _AgregarLibroScreenState extends State<AgregarLibroScreen> {
  final _formKey = GlobalKey<FormState>();
  String _titulo = '';
  String _autor = '';
  String? _rutaPdf;

  // Función para seleccionar el archivo
  Future<void> _seleccionarPdf() async {
    try {
FilePickerResult? result = await FilePicker.platform.pickFiles(
  type: FileType.custom,
  allowedExtensions: ['pdf'],
);

      if (result != null) {
        setState(() {
          _rutaPdf = result.files.single.path;
        });
      }
    } catch (e) {
      debugPrint("Error al elegir archivo: $e");
    }
  }

  void _guardarLibro() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final nuevoLibro = Libro(
        titulo: _titulo,
        autor: _autor,
        estado: 'Pendiente',
        portada: _rutaPdf ?? '', 
        calificacion: 0,
        resena: '',
      );
      
      await DatabaseHelper.instance.insertLibro(nuevoLibro);
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir Nuevo Libro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                onSaved: (v) => _titulo = v!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Autor'),
                validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                onSaved: (v) => _autor = v!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _seleccionarPdf,
                child: Text(_rutaPdf == null ? 'Seleccionar PDF' : 'Archivo seleccionado'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarLibro,
                child: const Text('Guardar Libro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}