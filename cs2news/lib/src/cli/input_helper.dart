import 'dart:io';
import '../domain/validators/text_validator.dart';
import '../domain/validators/number_validator.dart';

class InputHelper {
  static String askString(String prompt) {
    while (true) {
      stdout.write(prompt);
      final value = stdin.readLineSync()?.trim() ?? '';
      if (TextValidator.isNotEmpty(value)) return value;
      print('Ошибка: поле не может быть пустым.');
    }
  }

  static int askInt(String prompt) {
    while (true) {
      stdout.write(prompt);
      final input = stdin.readLineSync()?.trim() ?? '';
      final value = int.tryParse(input);
      if (value != null) return value;
      print('Ошибка: введите целое число.');
    }
  }

  static int askNonNegativeInt(String prompt) {
    while (true) {
      stdout.write(prompt);
      final input = stdin.readLineSync()?.trim() ?? '';
      final value = int.tryParse(input);
      if (value != null && NumberValidator.isValidViews(value)) return value;
      print('Ошибка: введите число 0 или больше.');
    }
  }

  static String askEmail(String prompt) {
    while (true) {
      stdout.write(prompt);
      final value = stdin.readLineSync()?.trim() ?? '';
      if (TextValidator.isValidEmail(value)) return value;
      print('Ошибка: введите корректный email (например user@cs2.com).');
    }
  }
}