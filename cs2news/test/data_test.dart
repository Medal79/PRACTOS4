import 'package:cs2news_app/cs2news_app.dart';
import 'package:test/test.dart';

AppDatabase openMemory() => AppDatabase(':memory:');

void main() {
  group('AuthorRepository', () {
    test('вставка и чтение по id', () {
      final db = openMemory();
      final repo = AuthorRepository(db.sqlite);
      repo.insert(Author(id: 'a1', username: 'Иван', email: 'ivan@cs2.ru'));
      final found = repo.getById('a1');
      expect(found, isNotNull);
      expect(found!.username, equals('Иван'));
      db.dispose();
    });

    test('getAll возвращает все записи', () {
      final db = openMemory();
      final repo = AuthorRepository(db.sqlite);
      repo.insert(Author(id: 'a1', username: 'Иван', email: 'ivan@cs2.ru'));
      repo.insert(Author(id: 'a2', username: 'Мария', email: 'maria@cs2.ru'));
      expect(repo.getAll().length, equals(2));
      db.dispose();
    });

    test('update изменяет запись', () {
      final db = openMemory();
      final repo = AuthorRepository(db.sqlite);
      repo.insert(Author(id: 'a1', username: 'Иван', email: 'ivan@cs2.ru'));
      repo.update(Author(id: 'a1', username: 'Пётр', email: 'petr@cs2.ru'));
      expect(repo.getById('a1')!.username, equals('Пётр'));
      db.dispose();
    });

    test('delete удаляет запись', () {
      final db = openMemory();
      final repo = AuthorRepository(db.sqlite);
      repo.insert(Author(id: 'a1', username: 'Иван', email: 'ivan@cs2.ru'));
      repo.delete('a1');
      expect(repo.getById('a1'), isNull);
      db.dispose();
    });
  });

  group('NewsRepository', () {
    test('вставка и чтение по id', () {
      final db = openMemory();
      final authors = AuthorRepository(db.sqlite);
      final news = NewsRepository(db.sqlite);
      authors.insert(Author(id: 'a1', username: 'Иван', email: 'ivan@cs2.ru'));
      news.insert(News(
        id: 'n1',
        authorId: 'a1',
        title: 'Новость CS2',
        content: 'Контент',
        views: 100,
        publishedAt: DateTime.now(),
      ));
      expect(news.getById('n1')!.title, equals('Новость CS2'));
      db.dispose();
    });

    test('delete удаляет запись', () {
      final db = openMemory();
      final authors = AuthorRepository(db.sqlite);
      final news = NewsRepository(db.sqlite);
      authors.insert(Author(id: 'a1', username: 'Иван', email: 'ivan@cs2.ru'));
      news.insert(News(
        id: 'n1',
        authorId: 'a1',
        title: 'Новость',
        content: '',
        views: 100,
        publishedAt: DateTime.now(),
      ));
      news.delete('n1');
      expect(news.getById('n1'), isNull);
      db.dispose();
    });
  });

  group('CommentRepository', () {
    test('вставка и чтение', () {
      final db = openMemory();
      final authors = AuthorRepository(db.sqlite);
      final news = NewsRepository(db.sqlite);
      final comments = CommentRepository(db.sqlite);
      authors.insert(Author(id: 'a1', username: 'Иван', email: 'ivan@cs2.ru'));
      news.insert(News(
        id: 'n1',
        authorId: 'a1',
        title: 'Новость',
        content: 'Контент',
        views: 10,
        publishedAt: DateTime.now(),
      ));
      comments.insert(Comment(
        id: 'c1',
        newsId: 'n1',
        authorId: 'a1',
        text: 'Класс!',
        createdAt: DateTime.now(),
      ));
      final all = comments.getAll();
      expect(all.length, equals(1));
      expect(all.first.text, equals('Класс!'));
      db.dispose();
    });

    test('delete удаляет запись', () {
      final db = openMemory();
      final authors = AuthorRepository(db.sqlite);
      final news = NewsRepository(db.sqlite);
      final comments = CommentRepository(db.sqlite);
      authors.insert(Author(id: 'a1', username: 'Иван', email: 'ivan@cs2.ru'));
      news.insert(News(
        id: 'n1',
        authorId: 'a1',
        title: 'Новость',
        content: 'Контент',
        views: 10,
        publishedAt: DateTime.now(),
      ));
      comments.insert(Comment(
        id: 'c1',
        newsId: 'n1',
        authorId: 'a1',
        text: 'Класс!',
        createdAt: DateTime.now(),
      ));
      comments.delete('c1');
      expect(comments.getAll(), isEmpty);
      db.dispose();
    });
  });

  group('ComplaintRepository', () {
    test('вставка и чтение по id', () {
      final db = openMemory();
      final authors = AuthorRepository(db.sqlite);
      final news = NewsRepository(db.sqlite);
      final repo = ComplaintRepository(db.sqlite);
      authors.insert(Author(id: 'a1', username: 'Иван', email: 'ivan@cs2.ru'));
      news.insert(News(
        id: 'n1',
        authorId: 'a1',
        title: 'Новость',
        content: 'Контент',
        views: 10,
        publishedAt: DateTime.now(),
      ));
      repo.insert(Complaint(
        id: 'comp1',
        newsId: 'n1',
        reporterName: 'Модератор',
        reason: 'Спам',
        createdAt: DateTime.now(),
      ));
      final found = repo.getById('comp1');
      expect(found, isNotNull);
      expect(found!.reason, equals('Спам'));
      db.dispose();
    });

    test('update изменяет причину', () {
      final db = openMemory();
      final authors = AuthorRepository(db.sqlite);
      final news = NewsRepository(db.sqlite);
      final repo = ComplaintRepository(db.sqlite);
      authors.insert(Author(id: 'a1', username: 'Иван', email: 'ivan@cs2.ru'));
      news.insert(News(
        id: 'n1',
        authorId: 'a1',
        title: 'Новость',
        content: 'Контент',
        views: 10,
        publishedAt: DateTime.now(),
      ));
      repo.insert(Complaint(
        id: 'comp1',
        newsId: 'n1',
        reporterName: 'Модератор',
        reason: 'Спам',
        createdAt: DateTime.now(),
      ));
      repo.update(Complaint(
        id: 'comp1',
        newsId: 'n1',
        reporterName: 'Модератор',
        reason: 'Оскорбления',
        createdAt: DateTime.now(),
      ));
      expect(repo.getById('comp1')!.reason, equals('Оскорбления'));
      db.dispose();
    });

    test('delete удаляет запись', () {
      final db = openMemory();
      final authors = AuthorRepository(db.sqlite);
      final news = NewsRepository(db.sqlite);
      final repo = ComplaintRepository(db.sqlite);
      authors.insert(Author(id: 'a1', username: 'Иван', email: 'ivan@cs2.ru'));
      news.insert(News(
        id: 'n1',
        authorId: 'a1',
        title: 'Новость',
        content: 'Контент',
        views: 10,
        publishedAt: DateTime.now(),
      ));
      repo.insert(Complaint(
        id: 'comp1',
        newsId: 'n1',
        reporterName: 'Модератор',
        reason: 'Спам',
        createdAt: DateTime.now(),
      ));
      repo.delete('comp1');
      expect(repo.getById('comp1'), isNull);
      db.dispose();
    });
  });
}
