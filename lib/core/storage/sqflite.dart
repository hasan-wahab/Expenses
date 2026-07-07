import 'dart:async';

import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  /// Database init
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  /// Create DB
  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), TableKeys.myDb);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${TableKeys.fingerPrintTable}(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            finger_print INTEGER
          )
        ''');
    await db.execute('''
          CREATE TABLE ${TableKeys.userTable}(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name Text,
            email Text,
            token Text,
            createAt Text,
            updateAt Text
          )
        ''');

    await db.execute('''
        CREATE TABLE ${TableKeys.propertyCardTable} (
          cardId INTEGER PRIMARY KEY,
          propertyName TEXT,
          imageUrl TEXT,
          categoryType TEXT,
          createAt TEXT,
          monthlyBudget INTEGER,
          monthlyExpenses INTEGER,
          progress REAL,
          updateAt TEXT,
          propertyLocation TEXT
        )
      ''');
  }
}
