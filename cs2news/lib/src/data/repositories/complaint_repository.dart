import 'package:sqlite3/sqlite3.dart';
import '../../domain/models/complaint.dart';

class ComplaintRepository {
  final Database _db;

  ComplaintRepository(this._db);

  void insert(Complaint c) {
    _db.execute(
      'INSERT INTO complaints (id, newsId, reporterName, reason, createdAt) VALUES (?, ?, ?, ?, ?)',
      [c.id, c.newsId, c.reporterName, c.reason, c.createdAt.toIso8601String()],
    );
  }

  List<Complaint> getAll() {
    final rows = _db.select('SELECT * FROM complaints');
    return rows.map((row) => Complaint.fromMap(row)).toList();
  }

  Complaint? getById(String id) {
    final rows = _db.select('SELECT * FROM complaints WHERE id = ?', [id]);
    if (rows.isEmpty) return null;
    return Complaint.fromMap(rows.first);
  }

  void update(Complaint c) {
    _db.execute(
      'UPDATE complaints SET newsId = ?, reporterName = ?, reason = ?, createdAt = ? WHERE id = ?',
      [c.newsId, c.reporterName, c.reason, c.createdAt.toIso8601String(), c.id],
    );
  }

  void delete(String id) {
    _db.execute('DELETE FROM complaints WHERE id = ?', [id]);
  }
}