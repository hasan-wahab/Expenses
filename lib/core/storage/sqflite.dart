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

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE ${TableKeys.expensesTable} ADD COLUMN receiptImage TEXT',
      );
    }
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
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT,
            token TEXT,
            loginWith TEXT,
            phone TEXT,
            imageUrl TEXT,
            createAt TEXT,
            updateAt TEXT,
            UNIQUE(email)
          )
        ''');
    await db.execute('''
          CREATE TABLE ${TableKeys.currentUserEmailTable}(
            id INTEGER PRIMARY KEY,
            email TEXT
          )
        ''');

    await db.execute('''
          CREATE TABLE ${TableKeys.propertyCardTable} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT,
            cardId INTEGER,
            propertyName TEXT,
            imageUrl TEXT,
            categoryType TEXT,
            createAt TEXT,
            monthlyBudget REAL,
            monthlyExpenses REAL,
            progress REAL,
            updateAt TEXT,
            syncStatus TEXT,
            isDeleted INTEGER,
            propertyLocation TEXT,
            UNIQUE(email, cardId)
          )
        ''');

    await db.execute('''
          CREATE TABLE ${TableKeys.expensesTable} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT,
            expenseId INTEGER,
            propertyCardId INTEGER,
            title TEXT,
            note TEXT,
            receiptImage TEXT,
            amount REAL,
            categoryType TEXT,
            date TEXT,
            createAt TEXT,
            updateAt TEXT,
            syncStatus TEXT,
            isDeleted INTEGER,
            UNIQUE(email, expenseId)
          )
        ''');

    await db.execute('''
          CREATE TABLE ${TableKeys.categoryTable}(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            categoryName TEXT
          )
        ''');
  }
}
