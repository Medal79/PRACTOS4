import 'package:cs2news_app/cs2news_app.dart';
import 'package:test/test.dart';

void main() {
  group('Author — toMap / fromMap', () {
    test('сохраняет и восстанавливает все поля', () {
      final a = Author(id: 'a1', username: 'CS2_Pro', email: 'pro@cs2.ru');
      final restored = Author.fromMap(a.toMap());
      expect(restored.id, equals('a1'));
      expect(restored.username, equals('CS2_Pro'));
      expect(restored.email, equals('pro@cs2.ru'));
    });
  });

  group('News — toMap / fromMap', () {
    test('сохраняет и восстанавливает все поля', () {
      final n = News(
        id: 'n1',
        authorId: 'a1',
        title: 'Новый маппул',
        content: 'Подробности обновления...',
        views: 1500,
        publishedAt: DateTime(2024, 6, 1, 12, 0),
      );
      final restored = News.fromMap(n.toMap());
      expect(restored.id, equals('n1'));
      expect(restored.title, equals('Новый маппул'));
      expect(restored.views, equals(1500));
    });
  });

  group('Comment — toMap / fromMap', () {
    test('сохраняет и восстанавливает все поля', () {
      final c = Comment(
        id: 'c1',
        newsId: 'n1',
        authorId: 'a1',
        text: 'Круто, жду обновления!',
        createdAt: DateTime(2024, 6, 1, 13, 0),
      );
      final restored = Comment.fromMap(c.toMap());
      expect(restored.id, equals('c1'));
      expect(restored.text, equals('Круто, жду обновления!'));
    });
  });

  group('Complaint — toMap / fromMap', () {
    test('сохраняет и восстанавливает все поля', () {
      final comp = Complaint(
        id: 'comp1',
        newsId: 'n1',
        reporterName: 'Модератор',
        reason: 'Оскорбления в комментариях',
        createdAt: DateTime(2024, 6, 1, 14, 0),
      );
      final restored = Complaint.fromMap(comp.toMap());
      expect(restored.id, equals('comp1'));
      expect(restored.reason, equals('Оскорбления в комментариях'));
    });
  });
}