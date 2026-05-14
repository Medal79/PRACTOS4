import 'dart:io';
import 'dart:convert';
import 'package:cs2news_app/cs2news_app.dart'; 

void main() {
  stdout.encoding = utf8;
  stderr.encoding = utf8;
  
  final menu = Menu();
  menu.run();
}