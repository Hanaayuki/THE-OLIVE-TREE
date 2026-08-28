import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mis_notas.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
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

  // Guardar una nueva nota
  Future<int> insertarNota(Map<String, dynamic> nota) async {
    final db = await instance.database;
    return await db.insert('notas', nota);
  }

  // Obtener solo los libros que tienen notas guardadas (sin repetir)
  Future<List<Map<String, dynamic>>> obtenerLibrosConNotas() async {
    final db = await instance.database;
    return await db.rawQuery(
        'SELECT DISTINCT libro_id, titulo_libro FROM notas ORDER BY titulo_libro ASC');
  }

  // Obtener todas las notas de un libro
  Future<List<Map<String, dynamic>>> obtenerNotasPorLibro(String libroId) async {
    final db = await instance.database;
    return await db.query(
      'notas',
      where: 'libro_id = ?',
      whereArgs: [libroId],
      orderBy: 'pagina ASC',
    );
  }

  // Eliminar una nota
  Future<int> eliminarNota(int id) async {
    final db = await instance.database;
    return await db.delete('notas', where: 'id = ?', whereArgs: [id]);
  }
}