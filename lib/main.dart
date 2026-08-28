import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async'; // para mi yo del futuro esto es para escuachar muisca y cambiar a la siguiente cancion

import 'Theme/app_theme.dart';
import 'Screens/biblioteca_screen.dart';
import 'Screens/notas_screen.dart';
import 'Screens/wishlist_screen.dart';
import 'Screens/resenas_screen.dart';

void main() => runApp(const OliveTreeApp());

class OliveTreeApp extends StatelessWidget {
  const OliveTreeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(), // Muestra primero la bienvenida
    );
  }
}

// pantalla de bienvenida 
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Al tocar cualquier parte de la pantalla, avanza al menu principal gracias papa youtube
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
        child: SizedBox.expand(
          child: Image.asset(
            'assets/images/Pantalla_de_bienvenida.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Text(
                'Toca para continuar',
                style: TextStyle(fontSize: 18, color: Color(0xFF3E2C1C)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  //  Audio y Volumen
  final AudioPlayer _audioPlayer = AudioPlayer();
  double _volumen = 0.5; // Volumen inicial al 50%
  
  // --DE LISTA DE REPRODUCCIÓN --
  final List<String> _listaCanciones = [
    'audio/musica1.mp3', // <-- musica 1 para iris
    'audio/musica2.mp3', // musica 2 para iris
  ];
  int _pistaActual = 0;
  StreamSubscription? _audioSubscription;
  // ----------------------------------------------

  String? _rutaFotoPerfil;

  // Páginas vinculadas a las opciones del menú lateral 
  final List<Widget> _paginas = [
    const BibliotecaScreen(),
    const NotasScreen(), // Pantalla de notas
    const _PaginaProximamente(titulo: 'Críticas'),
    const WishlistScreen(),
    const ResenasScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _iniciarReproductor(); // Llamamos al reproductor
    _cargarFotoPerfil();
  }

  //  FUNCIONES DE MÚSICA 
  Future<void> _iniciarReproductor() async {
    try {
      await _audioPlayer.setVolume(_volumen);

      // Escuchar cuando la canción actual TERMINE de sonar
      _audioSubscription = _audioPlayer.onPlayerComplete.listen((event) {
        _siguienteCancion();
      });

      // Reproducir la primera canción
      _reproducirCancionActual();
    } catch (e) {
      debugPrint('Error al reproducir la música: $e');
    }
  }

  Future<void> _reproducirCancionActual() async {
    await _audioPlayer.play(AssetSource(_listaCanciones[_pistaActual]));
  }

  void _siguienteCancion() {
    
    if (mounted) {
      setState(() {
        // Avanza a la siguiente pista, si llega al final, vuelve a 0
        _pistaActual = (_pistaActual + 1) % _listaCanciones.length;
      });
      _reproducirCancionActual();
    }
  }
  // ----------------------------------------

  Future<void> _cargarFotoPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Verificamos si el widget sigue montado antes de actualizar el estado
    if (!mounted) return;

    setState(() {
      _rutaFotoPerfil = prefs.getString('ruta_foto_perfil');
    });
  }

  Future<void> _cambiarFotoPerfil() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('ruta_foto_perfil', pickedFile.path);

      // Verificamos si el widget sigue montado antes de actualizar el estado
      if (!mounted) return;

      setState(() {
        _rutaFotoPerfil = pickedFile.path;
      });
    }
  }

  // Ventana Emergente de Ajustes
  void _mostrarAjustes() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFF5F1E8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Row(
                children: [
                  Icon(Icons.settings, color: Color(0xFF556B2F)),
                  SizedBox(width: 8),
                  Text('Ajustes', style: TextStyle(color: Color(0xFF3E2C1C))),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Volumen de la música',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2C1C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _volumen == 0 ? Icons.volume_off : Icons.volume_up,
                        color: const Color(0xFF556B2F),
                      ),
                      Expanded(
                        child: Slider(
                          value: _volumen,
                          activeColor: const Color(0xFF556B2F),
                          inactiveColor: const Color(0xFFE3DCC9),
                          onChanged: (nuevoVolumen) {
                            setModalState(() {
                              _volumen = nuevoVolumen;
                            });
                            setState(() {
                              _volumen = nuevoVolumen;
                            });
                            _audioPlayer.setVolume(_volumen);
                          },
                        ),
                      ),
                      Text('${(_volumen * 100).round()}%'),
                    ],
                  ),
                  const Divider(color: Color(0xFFE3DCC9), height: 30),
                  // Espacio preparado para futuras funciones
                  const Text(
                    'Próximas funciones...',
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar', style: TextStyle(color: Color(0xFF556B2F))),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _audioSubscription?.cancel(); //Cancelamos la escucha al cerrar
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E8),
      body: SafeArea(
        child: Row(
          children: [
            // BARRA LATERAL UNIFICADA
            Container(
              width: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F1E8),
                border: Border(
                  right: BorderSide(color: Color(0xFFE3DCC9), width: 1.5),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Foto de perfil superior
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: GestureDetector(
                      onTap: _cambiarFotoPerfil,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF3E2C1C), width: 1.2),
                          color: const Color(0xFFE3DCC9),
                          image: _rutaFotoPerfil != null && _rutaFotoPerfil!.isNotEmpty
                              ? DecorationImage(
                                  image: FileImage(File(_rutaFotoPerfil!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _rutaFotoPerfil == null || _rutaFotoPerfil!.isEmpty
                            ? const Icon(Icons.person, color: Color(0xFF3E2C1C), size: 22)
                            : null,
                      ),
                    ),
                  ),

                  // Opciones principales del menú
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildNavItem(0, Icons.menu_book, 'Biblioteca'),
                        const SizedBox(height: 16),
                        _buildNavItem(1, Icons.format_list_bulleted, 'ToS'),
                        const SizedBox(height: 16),
                        _buildNavItem(2, Icons.chat_bubble_outline, 'Críticas'),
                        const SizedBox(height: 16),
                        _buildNavItem(3, Icons.bookmark_outline, 'Wishlist'),
                        const SizedBox(height: 16),
                        _buildNavItem(4, Icons.edit, 'Reseñas'),
                      ],
                    ),
                  ),

                  // Botón de Ajustes y Personaje (Abajo)
                  Column(
                    children: [
                      InkWell(
                        onTap: _mostrarAjustes,
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.settings, color: Color(0xFF3E2C1C), size: 22),
                            SizedBox(height: 2),
                            Text(
                              'Ajustes',
                              style: TextStyle(fontSize: 10, color: Color(0xFF3E2C1C)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Image.asset(
                          'assets/images/personaje.png',
                          width: 45,
                          height: 45,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.eco,
                            size: 28,
                            color: Color(0xFF556B2F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // CONTENIDO DE LA PÁGINA SELECCIONADA
            Expanded(
              child: _paginas[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF556B2F) : const Color(0xFF3E2C1C),
            size: 22,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF556B2F) : const Color(0xFF3E2C1C),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaginaProximamente extends StatelessWidget {
  final String titulo;

  const _PaginaProximamente({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: Center(child: Text('$titulo: próximamente')),
    );
  }
}