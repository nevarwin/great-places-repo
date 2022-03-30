import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database() async {
    // create database
    // path where you may store your file
    // a folder where we store the database
    final dbPath = await sql.getDatabasesPath();

    // allows us open database
    // either open an existing or creates a new one
    // we need path with database name
    return sql.openDatabase(
      // from path package
      path.join(
        dbPath,
        'places.db',
      ),
      // takes a function
      // function which will execute when sql tries to open database and doesn't find the file
      // then goes ahead and creates the file
      // and run some code to initialize the database
      onCreate: (db, version) {
        // command that can be seen at pubdev
        // REAL = double
        return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insert(
    String table,
    Map<String, Object> data,
  ) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      // overwrite existing object
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(
    String table,
  ) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
