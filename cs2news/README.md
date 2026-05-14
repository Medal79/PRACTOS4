# cs2news — модульное CLI-приложение на Dart

Консольное приложение для управления новостным сайтом CS2 с хранением данных в SQLite.

## Предметная область

Новостной сайт Counter-Strike 2:

- авторы(`Author`) — пользователи, пишущие статьи;
- новости(`News`) — статьи с заголовком, контентом и счётчиком просмотров;
- комментарии(`Comment`) — комментарии к новостям от авторов;
- жалобы(`Complaint`) — жалобы читателей на конкретные статьи.

## Структура папок

```
cs2news_app/
├── pubspec.yaml
├── bin/
│   └── main.dart                        # Точка входа — только Menu().run()
├── lib/
│   ├── cs2news_app.dart                 # Экспорт всех публичных классов
│   └── src/
│       ├── domain/
│       │   ├── models/                  # Сущности
│       │   │   ├── author.dart
│       │   │   ├── news.dart
│       │   │   ├── comment.dart
│       │   │   └── complaint.dart
│       │   └── validators/              # Чистые функции валидации
│       │       ├── text_validator.dart
│       │       └── number_validator.dart
│       ├── data/
│       │   ├── database.dart            # Открытие SQLite, создание таблиц
│       │   └── repositories/            # CRUD для каждой сущности
│       │       ├── author_repository.dart
│       │       ├── news_repository.dart
│       │       ├── comment_repository.dart
│       │       └── complaint_repository.dart
│       └── cli/
│           ├── menu.dart                # Главное меню (while + switch-case)
│           └── input_helper.dart        # Ввод с валидацией и повторным запросом
└── test/
    ├── domain_test.dart
    ├── data_test.dart
    └── validation_test.dart
```

## Что вынесено в каждый слой и почему

**domain** — ядро. Содержит только модели (классы с полями, toMap, fromMap) и валидаторы (чистые функции). Не знает ничего о базе данных и консоли.
**data** — работа с SQLite. Открывает базу, создаёт таблицы, реализует CRUD через репозитории. Импортирует только domain.
**cli** — общение с пользователем. Выводит меню, читает ввод, вызывает репозитории. Импортирует domain и data.
Такое разделение позволяет тестировать каждый слой независимо и легко заменять один слой без переписывания остальных.

## Сущности и связи

| Сущность   | Поля                                          |
|------------|-----------------------------------------------|
| Author     | id, username, email                           |
| News       | id, authorId, title, content, views, publishedAt|
| Comment    | id, newsId, authorId, text, createdAt         |
| Complaint  | id, newsId, reporterName, reason, createdAt   |


- Удаление `Author` каскадно удаляет его `News` и `Comment`.
- Удаление `News` каскадно удаляет `Comment` и `Complaint` на эту новость.


## Валидации

### Тип 1 — обязательное текстовое поле
- `isNonEmpty(value)` — строка не пустая после `trim()`.
- Используется в `askString()`: цикл повторяет запрос, пока поле пустое.

### Тип 2 — форматные/числовые поля
- `tryParsePositiveInt(raw)` — целое число > 0; используется для поля `views` (просмотры).
- `tryParseDate(raw)` — дата/время через `DateTime.parse()`; используется для всех полей с датой.
- `isValidEmail(value)` — regex-проверка email автора.

## Перечень Тестов

1. **domain_test** — `toMap/fromMap` для всех 4 сущностей.
2. **data_test** — вставка и чтение из in-memory SQLite; каскадное удаление.
3. **validation_test** — валидный и невалидный сценарии для всех валидаторов.

## Запуск

```bash
# Установить зависимости
dart pub get

# Запустить приложение
dart run

# Запустить тесты
dart test
```




