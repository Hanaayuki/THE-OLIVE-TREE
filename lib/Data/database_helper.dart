import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/libro.dart'; 

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('the_olive_tree.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE libros ADD COLUMN rutaPdf TEXT',
      );
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE notas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          libro_id TEXT NOT NULL,
          titulo_libro TEXT NOT NULL,
          pagina INTEGER NOT NULL,
          contenido TEXT NOT NULL,
          fecha TEXT NOT NULL
        )
      ''');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE libros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        autor TEXT NOT NULL,
        portada TEXT,
        estado TEXT NOT NULL,
        calificacion INTEGER,
        resena TEXT,
        rutaPdf TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE notas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        libro_id TEXT NOT NULL,
        titulo_libro TEXT NOT NULL,
        pagina INTEGER NOT NULL,
        contenido TEXT NOT NULL,
        fecha TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertLibro(Libro libro) async {
    final db = await instance.database;
    return await db.insert('libros', libro.toMap());
  }

  Future<List<Libro>> getLibros() async {
    final db = await instance.database;
    final result = await db.query('libros');

    return result.map((json) => Libro.fromMap(json)).toList();
  }

  Future<int> deleteLibro(int id) async {
    final db = await instance.database;
    return await db.delete(
      'libros',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertarNota(Map<String, dynamic> nota) async {
    final db = await instance.database;
    return db.insert('notas', nota);
  }

  Future<List<Map<String, dynamic>>> obtenerLibrosConNotas() async {
    final db = await instance.database;
    return db.rawQuery(
      'SELECT DISTINCT libro_id, titulo_libro FROM notas ORDER BY titulo_libro ASC',
    );
  }

  Future<List<Map<String, dynamic>>> obtenerNotasPorLibro(String libroId) async {
    final db = await instance.database;
    return db.query(
      'notas',
      where: 'libro_id = ?',
      whereArgs: [libroId],
      orderBy: 'pagina ASC',
    );
  }

  Future<int> eliminarNota(int id) async {
    final db = await instance.database;
    return db.delete('notas', where: 'id = ?', whereArgs: [id]);
  }
}
