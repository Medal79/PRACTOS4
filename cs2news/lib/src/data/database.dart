import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as p;

class AppDatabase {
  final Database sqlite;

  AppDatabase(String filePath) : sqlite = sqlite3.open(filePath) {
    _createTables();
  }

  factory AppDatabase.inApp() {
    final path = p.join(Directory.current.path, 'cs2news.db');
    return AppDatabase(path);
  }

  void _createTables() {
    sqlite.execute('PRAGMA foreign_keys = ON;');

    sqlite.execute('''
      CREATE TABLE IF NOT EXISTS authors (
        id       TEXT PRIMARY KEY,
        username TEXT NOT NULL,
        email    TEXT NOT NULL
      );
    ''');

    sqlite.execute('''
      CREATE TABLE IF NOT EXISTS news (
        id          TEXT PRIMARY KEY,
        authorId    TEXT NOT NULL,
        title       TEXT NOT NULL,
        content     TEXT NOT NULL,
        views       INTEGER NOT NULL,
        publishedAt TEXT NOT NULL,
        FOREIGN KEY (authorId) REFERENCES authors(id) ON DELETE CASCADE
      );
    ''');

    sqlite.execute('''
      CREATE TABLE IF NOT EXISTS comments (
        id        TEXT PRIMARY KEY,
        newsId    TEXT NOT NULL,
        authorId  TEXT NOT NULL,
        text      TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (newsId)   REFERENCES news(id)    ON DELETE CASCADE,
        FOREIGN KEY (authorId) REFERENCES authors(id) ON DELETE CASCADE
      );
    ''');

    sqlite.execute('''
      CREATE TABLE IF NOT EXISTS complaints (
        id           TEXT PRIMARY KEY,
        newsId       TEXT NOT NULL,
        reporterName TEXT NOT NULL,
        reason       TEXT NOT NULL,
        createdAt    TEXT NOT NULL,
        FOREIGN KEY (newsId) REFERENCES news(id) ON DELETE CASCADE
      );
    ''');
  }

  void dispose() {
    sqlite.dispose();
  }
}