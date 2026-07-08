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

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE libros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        autor TEXT NOT NULL,
        portada TEXT,
        estado TEXT NOT NULL,
        calificacion INTEGER,
        resena TEXT
      )
    ''');
  }

 

  // 1. Guardar un libro nuevo en la base de datos
  Future<int> insertLibro(Libro libro) async {
    final db = await instance.database;
    return await db.insert('libros', libro.toMap());
  }

  // 2. Leer (Obtener) todos los libros guardados
  Future<List<Libro>> getLibros() async {
    final db = await instance.database;
    final result = await db.query('libros');
    
   
    return result.map((json) => Libro.fromMap(json)).toList();
  }

  // 3. Borrar un libro usando su ID
  Future<int> deleteLibro(int id) async {
    final db = await instance.database;
    return await db.delete(
      'libros',
      where: 'id = ?',
      whereArgs: [id],
    );
  } 
  } 
  