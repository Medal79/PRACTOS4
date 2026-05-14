import 'package:sqlite3/sqlite3.dart';
import '../../domain/models/news.dart';

class NewsRepository {
  final Database _db;

  NewsRepository(this._db);

  void insert(News n) {
    _db.execute(
      'INSERT INTO news (id, authorId, title, content, views, publishedAt) VALUES (?, ?, ?, ?, ?, ?)',
      [n.id, n.authorId, n.title, n.content, n.views, n.publishedAt.toIso8601String()],
    );
  }

  List<News> getAll() {
    final rows = _db.select('SELECT * FROM news');
    return rows.map((row) => News.fromMap(row)).toList();
  }

  News? getById(String id) {
    final rows = _db.select('SELECT * FROM news WHERE id = ?', [id]);
    if (rows.isEmpty) return null;
    return News.fromMap(rows.first);
  }

  void update(News n) {
    _db.execute(
      'UPDATE news SET authorId = ?, title = ?, content = ?, views = ?, publishedAt = ? WHERE id = ?',
      [n.authorId, n.title, n.content, n.views, n.publishedAt.toIso8601String(), n.id],
    );
  }

  void delete(String id) {
    _db.execute('DELETE FROM news WHERE id = ?', [id]);
  }
}