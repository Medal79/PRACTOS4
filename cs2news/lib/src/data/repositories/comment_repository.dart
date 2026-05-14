import 'package:sqlite3/sqlite3.dart';
import '../../domain/models/comment.dart';

class CommentRepository {
  final Database _db;

  CommentRepository(this._db);

  void insert(Comment c) {
    _db.execute(
      'INSERT INTO comments (id, newsId, authorId, text, createdAt) VALUES (?, ?, ?, ?, ?)',
      [c.id, c.newsId, c.authorId, c.text, c.createdAt.toIso8601String()],
    );
  }

  List<Comment> getAll() {
    final rows = _db.select('SELECT * FROM comments');
    return rows.map((row) => Comment.fromMap(row)).toList();
  }

  Comment? getById(String id) {
    final rows = _db.select('SELECT * FROM comments WHERE id = ?', [id]);
    if (rows.isEmpty) return null;
    return Comment.fromMap(rows.first);
  }

  void update(Comment c) {
    _db.execute(
      'UPDATE comments SET newsId = ?, authorId = ?, text = ?, createdAt = ? WHERE id = ?',
      [c.newsId, c.authorId, c.text, c.createdAt.toIso8601String(), c.id],
    );
  }

  void delete(String id) {
    _db.execute('DELETE FROM comments WHERE id = ?', [id]);
  }
}