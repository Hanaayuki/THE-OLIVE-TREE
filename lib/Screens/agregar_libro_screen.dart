import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../Data/database_helper.dart';
import '../models/libro.dart';

class AgregarLibroScreen extends StatefulWidget {
  const AgregarLibroScreen({super.key});

  @override
  State<AgregarLibroScreen> createState() =>
      _AgregarLibroScreenState();
}

class _AgregarLibroScreenState
    extends State<AgregarLibroScreen> {
  final _formKey = GlobalKey<FormState>();

  String _titulo = '';
  String _autor = '';

  String? _rutaPdf;
  String? _rutaPortada;

  // Seleccionar PDF
  Future<void> _seleccionarPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null) {
        debugPrint('No se seleccionó ningún PDF.');
        return;
      }

      final archivo = result.files.single;

      debugPrint('Nombre del PDF: ${archivo.name}');
      debugPrint('Ruta del PDF: ${archivo.path}');

      if (archivo.path == null || archivo.path!.isEmpty) {
        debugPrint('ERROR: FilePicker no ha devuelto una ruta válida.');
        return;
      }

      setState(() {
        _rutaPdf = archivo.path;
      });

      debugPrint('PDF guardado en _rutaPdf: $_rutaPdf');
    } catch (e) {
      debugPrint('Error al elegir archivo: $e');
    }
  }

  Future<void> _seleccionarPortada() async {
    try {
      final picker = ImagePicker();
      final imagen = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (imagen != null) {
        setState(() {
          _rutaPortada = imagen.path;
        });
      }
    } catch (e) {
      debugPrint('Error al elegir portada: $e');
    }
  }

  Future<void> _guardarLibro() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    debugPrint('==============================');
    debugPrint('GUARDANDO LIBRO');
    debugPrint('Título: $_titulo');
    debugPrint('Autor: $_autor');
    debugPrint('PDF: $_rutaPdf');
    debugPrint('Portada: $_rutaPortada');
    debugPrint('==============================');
      final nuevoLibro = Libro(
        titulo: _titulo,
        autor: _autor,
        estado: 'Pendiente',
        portada: _rutaPortada,
        rutaPdf: _rutaPdf,
        calificacion: 0,
        resena: '',
      );

      await DatabaseHelper.instance.insertLibro(nuevoLibro);

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Añadir Nuevo Libro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Título',
                ),
                validator: (v) =>
                    (v == null || v.isEmpty)
                        ? 'Campo obligatorio'
                        : null,
                onSaved: (v) => _titulo = v!,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Autor',
                ),
                validator: (v) =>
                    (v == null || v.isEmpty)
                        ? 'Campo obligatorio'
                        : null,
                onSaved: (v) => _autor = v!,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _seleccionarPortada,
                child: Text(
                  _rutaPortada == null
                      ? 'Seleccionar Portada'
                      : 'Portada seleccionada',
                ),
              ),

              const SizedBox(height: 10),

              if (_rutaPortada != null)
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(12),
                  child: Image.file(
                    File(_rutaPortada!),
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _seleccionarPdf,
                child: Text(
                  _rutaPdf == null
                      ? 'Seleccionar PDF'
                      : 'Archivo seleccionado',
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _guardarLibro,
                child:
                    const Text('Guardar Libro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}