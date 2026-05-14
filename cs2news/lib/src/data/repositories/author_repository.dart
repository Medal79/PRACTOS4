import 'package:sqlite3/sqlite3.dart';
import '../../domain/models/author.dart';

class AuthorRepository {
  final Database _db;

  AuthorRepository(this._db);

  void insert(Author a) {
    _db.execute(
      'INSERT INTO authors (id, username, email) VALUES (?, ?, ?)',
      [a.id, a.username, a.email],
    );
  }

  List<Author> getAll() {
    final rows = _db.select('SELECT * FROM authors');
    return rows.map((row) => Author.fromMap(row)).toList();
  }

  Author? getById(String id) {
    final rows = _db.select('SELECT * FROM authors WHERE id = ?', [id]);
    if (rows.isEmpty) return null;
    return Author.fromMap(rows.first);
  }

  void update(Author a) {
    _db.execute(
      'UPDATE authors SET username = ?, email = ? WHERE id = ?',
      [a.username, a.email, a.id],
    );
  }

  void delete(String id) {
    _db.execute('DELETE FROM authors WHERE id = ?', [id]);
  }
}