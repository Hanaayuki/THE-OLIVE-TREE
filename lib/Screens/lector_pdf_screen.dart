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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
      ),
      body: SfPdfViewer.file(
        File(widget.rutaPdf),
        controller: _pdfController,
      ),
    );
  }
}