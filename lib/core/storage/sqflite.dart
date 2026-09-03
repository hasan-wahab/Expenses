import 'dart:async';

import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  /// Bump this when local schema must reset / migrate.
  static const int dbVersion = 8;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), TableKeys.myDb);

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 4) {
      await _dropAllTables(db);
      await _onCreate(db, newVersion);
      return;
    }
    if (oldVersion < 5) {
      await db.execute('''
          CREATE TABLE IF NOT EXISTS ${TableKeys.appLockTable}(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            requires_login INTEGER
          )
        ''');
    }
    if (oldVersion < 6) {
      await _migratePropertyShareColumns(db);
    }
    if (oldVersion < 7) {
      await _migrateExpenseShareColumns(db);
    }
    if (oldVersion < 8) {
      await _migrateExpenseCreatedBy(db);
    }
  }

  Future<void> _migratePropertyShareColumns(Database db) async {
    const newTable = 'PROPERTY_CARD_TABLE_V6';
    await db.execute('''
          CREATE TABLE $newTable (
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
            ownerId TEXT DEFAULT '',
            ownerEmail TEXT DEFAULT '',
            isSharedWithMe INTEGER DEFAULT 0,
            myPermissions TEXT DEFAULT '',
            UNIQUE(email, ownerId, cardId)
          )
        ''');
    await db.execute('''
          INSERT INTO $newTable (
            id, email, cardId, propertyName, imageUrl, categoryType, createAt,
            monthlyBudget, monthlyExpenses, progress, updateAt, syncStatus,
            isDeleted, propertyLocation, ownerId, ownerEmail, isSharedWithMe,
            myPermissions
          )
          SELECT
            id, email, cardId, propertyName, imageUrl, categoryType, createAt,
            monthlyBudget, monthlyExpenses, progress, updateAt, syncStatus,
            isDeleted, propertyLocation, '', '', 0, ''
          FROM ${TableKeys.propertyCardTable}
        ''');
    await db.execute('DROP TABLE ${TableKeys.propertyCardTable}');
    await db.execute(
      'ALTER TABLE $newTable RENAME TO ${TableKeys.propertyCardTable}',
    );
  }

  Future<void> _migrateExpenseCreatedBy(Database db) async {
    const newTable = 'EXPENSES_TABLE_V8';
    await db.execute('''
          CREATE TABLE $newTable (
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
            propertyOwnerId TEXT DEFAULT '',
            isSharedWithMe INTEGER DEFAULT 0,
            createdById TEXT DEFAULT '',
            UNIQUE(email, createdById, expenseId)
          )
        ''');
    await db.execute('''
          INSERT INTO $newTable (
            id, email, expenseId, propertyCardId, title, note, receiptImage,
            amount, categoryType, date, createAt, updateAt, syncStatus,
            isDeleted, propertyOwnerId, isSharedWithMe, createdById
          )
          SELECT
            id, email, expenseId, propertyCardId, title, note, receiptImage,
            amount, categoryType, date, createAt, updateAt, syncStatus,
            isDeleted, IFNULL(propertyOwnerId, ''), IFNULL(isSharedWithMe, 0), ''
          FROM ${TableKeys.expensesTable}
        ''');
    await db.execute('DROP TABLE ${TableKeys.expensesTable}');
    await db.execute(
      'ALTER TABLE $newTable RENAME TO ${TableKeys.expensesTable}',
    );
  }

  Future<void> _migrateExpenseShareColumns(Database db) async {
    await db.execute(
      "ALTER TABLE ${TableKeys.expensesTable} ADD COLUMN propertyOwnerId TEXT DEFAULT ''",
    );
    await db.execute(
      'ALTER TABLE ${TableKeys.expensesTable} ADD COLUMN isSharedWithMe INTEGER DEFAULT 0',
    );
  }

  Future<void> _dropAllTables(Database db) async {
    await db.execute('DROP TABLE IF EXISTS ${TableKeys.expensesTable}');
    await db.execute('DROP TABLE IF EXISTS ${TableKeys.propertyCardTable}');
    await db.execute('DROP TABLE IF EXISTS ${TableKeys.categoryTable}');
    await db.execute('DROP TABLE IF EXISTS ${TableKeys.userTable}');
    await db.execute('DROP TABLE IF EXISTS ${TableKeys.currentUserEmailTable}');
    await db.execute('DROP TABLE IF EXISTS ${TableKeys.fingerPrintTable}');
    await db.execute('DROP TABLE IF EXISTS ${TableKeys.onboardingTable}');
    await db.execute('DROP TABLE IF EXISTS ${TableKeys.appLockTable}');
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${TableKeys.fingerPrintTable}(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            finger_print INTEGER
          )
        ''');
    await db.execute('''
          CREATE TABLE ${TableKeys.onboardingTable}(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            completed INTEGER
          )
        ''');
    await db.execute('''
          CREATE TABLE ${TableKeys.appLockTable}(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            requires_login INTEGER
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
            ownerId TEXT DEFAULT '',
            ownerEmail TEXT DEFAULT '',
            isSharedWithMe INTEGER DEFAULT 0,
            myPermissions TEXT DEFAULT '',
            UNIQUE(email, ownerId, cardId)
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
            propertyOwnerId TEXT DEFAULT '',
            isSharedWithMe INTEGER DEFAULT 0,
            createdById TEXT DEFAULT '',
            UNIQUE(email, createdById, expenseId)
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
