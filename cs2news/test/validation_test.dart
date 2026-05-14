import 'package:cs2news_app/cs2news_app.dart';
import 'package:test/test.dart';

void main() {
  group('TextValidator — текстовые поля и email', () {
    test('непустая строка → true', () {
      expect(TextValidator.isNotEmpty('Иван'), isTrue);
    });
    test('пустая строка → false', () {
      expect(TextValidator.isNotEmpty(''), isFalse);
    });
    test('строка только из пробелов → false', () {
      expect(TextValidator.isNotEmpty('   '), isFalse);
    });
    test('валидный email → true', () {
      expect(TextValidator.isValidEmail('pro@cs2.ru'), isTrue);
    });
    test('невалидный email → false', () {
      expect(TextValidator.isValidEmail('invalid-email'), isFalse);
    });
  });

  group('NumberValidator — числовые поля', () {
    test('просмотры 0 → true', () {
      expect(NumberValidator.isValidViews(0), isTrue);
    });
    test('просмотры 1500 → true', () {
      expect(NumberValidator.isValidViews(1500), isTrue);
    });
    test('просмотры отрицательные → false', () {
      expect(NumberValidator.isValidViews(-5), isFalse);
    });
    test('количество 1 → true', () {
      expect(NumberValidator.isValidQuantity(1), isTrue);
    });
    test('количество 0 → false', () {
      expect(NumberValidator.isValidQuantity(0), isFalse);
    });
  });
}