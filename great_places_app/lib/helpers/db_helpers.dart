import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<void> insert(
    String table,
    Map<String, Object> data,
  ) async {
    // create database
    // path where you may store your file
    // a folder where we store the database
    final dbPath = await sql.getDatabasesPath();

    // allows us open database
    // either open an existing or creates a new one
    // we need path with database name
    final sqlDb = await sql.openDatabase(
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
        return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT)',
        );
      },
      version: 1,
    );
    sqlDb.insert(
      table,
      data,
      // overwrite existing object
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }
}
