import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'movie_app.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cached_movies(
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        backdropPath TEXT,
        releaseDate TEXT,
        rating REAL,
        category TEXT,
        timestamp INTEGER
      )
    ''');
  }

  Future<void> cacheMovies(List<Movie> movies, String category) async {
    final db = await database;
    final batch = db.batch();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    for (var movie in movies) {
      batch.insert(
        'cached_movies',
        {
          'id': movie.id,
          'title': movie.title,
          'overview': movie.overview,
          'posterPath': movie.posterPath,
          'backdropPath': movie.backdropPath,
          'releaseDate': movie.releaseDate,
          'rating': movie.rating,
          'category': category,
          'timestamp': timestamp,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  Future<List<Movie>> getCachedMovies(String category) async {
    final db = await database;
    final maps = await db.query(
      'cached_movies',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'timestamp DESC',
    );

    return maps.map((map) => Movie.fromMap(map)).toList();
  }

  Future<void> clearOldCache() async {
    final db = await database;
    final thirtyDaysAgo = DateTime.now()
        .subtract(const Duration(days: 30))
        .millisecondsSinceEpoch;
    
    await db.delete(
      'cached_movies',
      where: 'timestamp < ?',
      whereArgs: [thirtyDaysAgo],
    );
  }
}