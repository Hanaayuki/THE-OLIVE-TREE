import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class LectorPdfScreen extends StatefulWidget {
  final String rutaPdf;
  final String titulo;

  const LectorPdfScreen({
    super.key,
    required this.rutaPdf,
    required this.titulo,
  });

  @override
  State<LectorPdfScreen> createState() => _LectorPdfScreenState();
}

class _LectorPdfScreenState extends State<LectorPdfScreen> {
  final PdfViewerController _pdfController = PdfViewerController();

  final GlobalKey<SfPdfViewerState> _pdfViewerKey =
      GlobalKey<SfPdfViewerState>();

  bool _modoSubrayar = false;

  void _activarSubrayado() {
    setState(() {
      _modoSubrayar = true;
      _pdfController.annotationMode = PdfAnnotationMode.highlight;
    });
  }

  void _desactivarSubrayado() {
    setState(() {
      _modoSubrayar = false;
      _pdfController.annotationMode = PdfAnnotationMode.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        actions: [
          IconButton(
            icon: Icon(
              _modoSubrayar
                  ? Icons.highlight_off
                  : Icons.more_vert,
            ),
            tooltip: _modoSubrayar
                ? 'Salir de subrayado'
                : 'Opciones',
            onPressed: () {
              if (_modoSubrayar) {
                _desactivarSubrayado();
              } else {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.highlight,
                              color: Colors.orange,
                            ),
                            title: const Text('Subrayar'),
                            subtitle: const Text(
                              'Selecciona el texto que quieras marcar',
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              _activarSubrayado();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      body: SfPdfViewer.file(
        File(widget.rutaPdf),
        key: _pdfViewerKey,
        controller: _pdfController,
        enableTextSelection: true,
      ),
    );
  }
}