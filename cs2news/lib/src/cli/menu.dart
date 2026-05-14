import 'dart:io';
import 'dart:convert';
import '../data/database.dart';
import '../data/repositories/author_repository.dart';
import '../data/repositories/news_repository.dart';
import '../data/repositories/comment_repository.dart';
import '../data/repositories/complaint_repository.dart';
import '../domain/models/author.dart';
import '../domain/models/news.dart';
import '../domain/models/comment.dart';
import '../domain/models/complaint.dart';
import 'input_helper.dart';

class Menu {
  final AppDatabase _db;
  late final AuthorRepository _authors;
  late final NewsRepository _news;
  late final CommentRepository _comments;
  late final ComplaintRepository _complaints;

  Menu() : _db = AppDatabase.inApp() {
    _authors = AuthorRepository(_db.sqlite);
    _news = NewsRepository(_db.sqlite);
    _comments = CommentRepository(_db.sqlite);
    _complaints = ComplaintRepository(_db.sqlite);
  }

  void run() {
    stdout.encoding = utf8;
    stderr.encoding = utf8;
    
    print('Система управления новостями CS2');

    while (true) {
      print('\nГлавное меню');
      print('1. Авторы');
      print('2. Новости');
      print('3. Комментарии');
      print('4. Жалобы');
      print('5. Показать всё из БД');
      print('0. Выход');

      final choice = InputHelper.askInt('Выберите пункт: ');

      switch (choice) {
        case 1:
          _authorsMenu();
        case 2:
          _newsMenu();
        case 3:
          _commentsMenu();
        case 4:
          _complaintsMenu();
        case 5:
          _showAll();
        case 0:
          print('До свидания!');
          _db.dispose();
          return;
        default:
          print('Неверный пункт. Попробуйте снова.');
      }
    }
  }

  void _showAll() {
    print('\nВСЯ БАЗА ДАННЫХ');

    print('\n[Авторы]');
    final authors = _authors.getAll();
    if (authors.isEmpty) {
      print('  пусто');
    } else {
      for (final a in authors) {
        print('  [${a.id}] ${a.username} | email: ${a.email}');
      }
    }

    print('\n[Новости]');
    final newsList = _news.getAll();
    if (newsList.isEmpty) {
      print('  пусто');
    } else {
      for (final n in newsList) {
        print('  [${n.id}] ${n.title} | автор: ${n.authorId} | просмотры: ${n.views} | ${n.publishedAt}');
      }
    }

    print('\n[Комментарии]');
    final comments = _comments.getAll();
    if (comments.isEmpty) {
      print('  пусто');
    } else {
      for (final c in comments) {
        print('  [${c.id}] новость: ${c.newsId} | автор: ${c.authorId} | "${c.text}"');
      }
    }

    print('\n[Жалобы]');
    final complaints = _complaints.getAll();
    if (complaints.isEmpty) {
      print('  пусто');
    } else {
      for (final c in complaints) {
        print('  [${c.id}] новость: ${c.newsId} | от: ${c.reporterName} | причина: ${c.reason}');
      }
    }
  }

  void _authorsMenu() {
    while (true) {
      print('\nАвторы');
      print('1. Показать всех');
      print('2. Добавить');
      print('3. Обновить');
      print('4. Удалить');
      print('0. Назад');

      final choice = InputHelper.askInt('Выберите действие: ');

      switch (choice) {
        case 1:
          final list = _authors.getAll();
          if (list.isEmpty) {
            print('Авторов нет.');
          } else {
            for (final a in list) {
              print('  [${a.id}] ${a.username} | email: ${a.email}');
            }
          }
        case 2:
          final id = InputHelper.askString('ID: ');
          if (_authors.getById(id) != null) {
            print('Ошибка: автор с ID "$id" уже существует.');
            return;
          }
          final username = InputHelper.askString('Имя пользователя: ');
          final email = InputHelper.askEmail('Email: ');
          _authors.insert(Author(id: id, username: username, email: email));
          print('Автор добавлен.');
        case 3:
          final id = InputHelper.askString('ID автора: ');
          final existing = _authors.getById(id);
          if (existing == null) {
            print('Ошибка: автор с ID "$id" не найден.');
            return;
          }
          final username = InputHelper.askString('Новое имя пользователя: ');
          final email = InputHelper.askEmail('Новый email: ');
          _authors.update(Author(id: id, username: username, email: email));
          print('Автор обновлён.');
        case 4:
          final id = InputHelper.askString('ID автора: ');
          _authors.delete(id);
          print('Автор удалён.');
        case 0:
          return;
        default:
          print('Неверный пункт.');
      }
    }
  }

  void _newsMenu() {
    while (true) {
      print('\nНовости');
      print('1. Показать все');
      print('2. Добавить');
      print('3. Обновить');
      print('4. Удалить');
      print('0. Назад');

      final choice = InputHelper.askInt('Выберите действие: ');

      switch (choice) {
        case 1:
          final list = _news.getAll();
          if (list.isEmpty) {
            print('Новостей нет.');
          } else {
            for (final n in list) {
              print('  [${n.id}] ${n.title} | автор: ${n.authorId} | просмотры: ${n.views}');
            }
          }
        case 2:
          print('\nСуществующие авторы:');
          final authorsList = _authors.getAll();
          if (authorsList.isEmpty) {
            print('  Нет авторов. Сначала добавьте автора в разделе "Авторы"!');
            return;
          }
          for (final a in authorsList) {
            print('  [${a.id}] ${a.username} | email: ${a.email}');
          }
          
          final id = InputHelper.askString('ID новости: ');
          if (_news.getById(id) != null) {
            print('Ошибка: новость с ID "$id" уже существует.');
            return;
          }
          
          String authorId;
          while (true) {
            authorId = InputHelper.askString('ID автора: ');
            final author = _authors.getById(authorId);
            if (author != null) break;
            print('Ошибка: автор с ID "$authorId" не найден. Попробуйте снова.');
          }
          
          final title = InputHelper.askString('Заголовок: ');
          final content = InputHelper.askString('Содержание: ');
          final views = InputHelper.askNonNegativeInt('Просмотры: ');
          _news.insert(News(
            id: id,
            authorId: authorId,
            title: title,
            content: content,
            views: views,
            publishedAt: DateTime.now(),
          ));
          print('Новость добавлена.');
        case 3:
          final id = InputHelper.askString('ID новости: ');
          final existing = _news.getById(id);
          if (existing == null) {
            print('Ошибка: новость с ID "$id" не найдена.');
            return;
          }
          final title = InputHelper.askString('Новый заголовок: ');
          final content = InputHelper.askString('Новое содержание: ');
          final views = InputHelper.askNonNegativeInt('Новое кол-во просмотров: ');
          _news.update(News(
            id: existing.id,
            authorId: existing.authorId,
            title: title,
            content: content,
            views: views,
            publishedAt: existing.publishedAt,
          ));
          print('Новость обновлена.');
        case 4:
          final id = InputHelper.askString('ID новости: ');
          _news.delete(id);
          print('Новость удалена.');
        case 0:
          return;
        default:
          print('Неверный пункт.');
      }
    }
  }

  void _commentsMenu() {
    while (true) {
      print('\nКомментарии');
      print('1. Показать все');
      print('2. Добавить');
      print('3. Обновить текст');
      print('4. Удалить');
      print('0. Назад');

      final choice = InputHelper.askInt('Выберите действие: ');

      switch (choice) {
        case 1:
          final list = _comments.getAll();
          if (list.isEmpty) {
            print('Комментариев нет.');
          } else {
            for (final c in list) {
              print('  [${c.id}] новость: ${c.newsId} | автор: ${c.authorId} | "${c.text}"');
            }
          }
        case 2:
          print('\nСуществующие новости:');
          final newsList = _news.getAll();
          if (newsList.isEmpty) {
            print('  Нет новостей. Сначала добавьте новость!');
            return;
          }
          for (final n in newsList) {
            print('  [${n.id}] ${n.title}');
          }
          
          print('\nСуществующие авторы:');
          final authorsList = _authors.getAll();
          if (authorsList.isEmpty) {
            print('  Нет авторов. Сначала добавьте автора!');
            return;
          }
          for (final a in authorsList) {
            print('  [${a.id}] ${a.username}');
          }
          
          final id = InputHelper.askString('ID комментария: ');
          if (_comments.getById(id) != null) {
            print('Ошибка: комментарий с ID "$id" уже существует.');
            return;
          }
          
          String newsId;
          while (true) {
            newsId = InputHelper.askString('ID новости: ');
            final news = _news.getById(newsId);
            if (news != null) break;
            print('Ошибка: новость с ID "$newsId" не найдена.');
          }
          
          String authorId;
          while (true) {
            authorId = InputHelper.askString('ID автора: ');
            final author = _authors.getById(authorId);
            if (author != null) break;
            print('Ошибка: автор с ID "$authorId" не найден.');
          }
          
          final text = InputHelper.askString('Текст: ');
          
          _comments.insert(Comment(
            id: id,
            newsId: newsId,
            authorId: authorId,
            text: text,
            createdAt: DateTime.now(),
          ));
          print('Комментарий добавлен.');
        case 3:
          final id = InputHelper.askString('ID комментария: ');
          final existing = _comments.getById(id);
          if (existing == null) {
            print('Ошибка: комментарий с ID "$id" не найден.');
            return;
          }
          final text = InputHelper.askString('Новый текст: ');
          _comments.update(Comment(
            id: existing.id,
            newsId: existing.newsId,
            authorId: existing.authorId,
            text: text,
            createdAt: existing.createdAt,
          ));
          print('Комментарий обновлён.');
        case 4:
          final id = InputHelper.askString('ID комментария: ');
          _comments.delete(id);
          print('Комментарий удалён.');
        case 0:
          return;
        default:
          print('Неверный пункт.');
      }
    }
  }

  void _complaintsMenu() {
    while (true) {
      print('\nЖалобы');
      print('1. Показать все');
      print('2. Подать жалобу');
      print('3. Обновить');
      print('4. Удалить');
      print('0. Назад');

      final choice = InputHelper.askInt('Выберите действие: ');

      switch (choice) {
        case 1:
          final list = _complaints.getAll();
          if (list.isEmpty) {
            print('Жалоб нет.');
          } else {
            for (final c in list) {
              print('  [${c.id}] новость: ${c.newsId} | от: ${c.reporterName} | причина: ${c.reason}');
            }
          }
        case 2:
          print('\nСуществующие новости:');
          final newsList = _news.getAll();
          if (newsList.isEmpty) {
            print('  Нет новостей. Сначала добавьте новость в разделе "Новости"!');
            return;
          }
          
          for (final n in newsList) {
            print('  [${n.id}] ${n.title}');
          }
          
          final id = InputHelper.askString('ID жалобы: ');
          if (_complaints.getById(id) != null) {
            print('Ошибка: жалоба с ID "$id" уже существует.');
            return;
          }
          
          String newsId;
          while (true) {
            newsId = InputHelper.askString('ID новости: ');
            final news = _news.getById(newsId);
            if (news != null) break;
            print('Ошибка: новость с ID "$newsId" не найдена. Попробуйте снова.');
          }
          
          final reporterName = InputHelper.askString('Ваш ник: ');
          final reason = InputHelper.askString('Причина жалобы: ');
          
          _complaints.insert(Complaint(
            id: id,
            newsId: newsId,
            reporterName: reporterName,
            reason: reason,
            createdAt: DateTime.now(),
          ));
          print('Жалоба подана.');
        case 3:
          final id = InputHelper.askString('ID жалобы: ');
          final existing = _complaints.getById(id);
          if (existing == null) {
            print('Ошибка: жалоба с ID "$id" не найдена.');
            return;
          }
          
          print('\nСуществующие новости:');
          final newsList = _news.getAll();
          if (newsList.isEmpty) {
            print('  Нет новостей.');
            return;
          }
          for (final n in newsList) {
            print('  [${n.id}] ${n.title}');
          }
          
          String newsId;
          while (true) {
            newsId = InputHelper.askString('ID новости: ');
            final news = _news.getById(newsId);
            if (news != null) break;
            print('Ошибка: новость с ID "$newsId" не найдена.');
          }
          
          final reporterName = InputHelper.askString('Имя заявителя: ');
          final reason = InputHelper.askString('Причина жалобы: ');
          
          _complaints.update(Complaint(
            id: existing.id,
            newsId: newsId,
            reporterName: reporterName,
            reason: reason,
            createdAt: existing.createdAt,
          ));
          print('Жалоба обновлена.');
        case 4:
          final id = InputHelper.askString('ID жалобы: ');
          _complaints.delete(id);
          print('Жалоба удалена.');
        case 0:
          return;
        default:
          print('Неверный пункт.');
      }
    }
  }
}