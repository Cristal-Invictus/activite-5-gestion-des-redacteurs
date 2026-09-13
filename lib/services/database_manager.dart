import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../modele/redacteur.dart';

class DatabaseManager {
  DatabaseManager._();

  static final DatabaseManager instance = DatabaseManager._();

  static const String _databaseName = 'redacteurs.db';
  static const int _databaseVersion = 1;
  static const String _tableRedacteurs = 'redacteurs';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initialisation();
    return _database!;
  }

  Future<Database> initialisation() async {
    final databaseDirectory = await getDatabasesPath();
    final databasePath = p.join(databaseDirectory, _databaseName);

    return openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableRedacteurs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT NOT NULL,
            prenom TEXT NOT NULL,
            email TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Redacteur>> getAllRedacteurs() async {
    final db = await database;
    final rows = await db.query(
      _tableRedacteurs,
      orderBy: 'nom COLLATE NOCASE ASC, prenom COLLATE NOCASE ASC',
    );

    return rows.map(Redacteur.fromMap).toList();
  }

  Future<int> insertRedacteur(Redacteur redacteur) async {
    final db = await database;
    final values = redacteur.toMap()..remove('id');

    return db.insert(
      _tableRedacteurs,
      values,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<int> updateRedacteur(Redacteur redacteur) async {
    final id = redacteur.id;
    if (id == null) {
      throw ArgumentError('Un id est requis pour modifier un redacteur.');
    }

    final db = await database;
    final values = redacteur.toMap()..remove('id');

    return db.update(
      _tableRedacteurs,
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteRedacteur(int id) async {
    final db = await database;

    return db.delete(
      _tableRedacteurs,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
