/**
 * Created by lejard_h on 23/12/15.
 */

library polymer_app.utils;

import 'dart:io';
import 'package:ansicolor/ansicolor.dart';
import 'package:dart_style/dart_style.dart';

final AnsiPen green = new AnsiPen()..green(bold: true);
final AnsiPen white = new AnsiPen()..white(bold: true);

Directory createDirectory(String path) {
  print("Creating '${green(path)}' directory.");
  Directory dir = new Directory(path);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
  return dir;
}

File createFile(String path) {
  print("Creating '${green(path)}' file.");
  File file = new File(path);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
  return file;
}

toSnakeCase(String name) =>
    name?.replaceAll("-", "_").replaceAll(" ", "_")?.toLowerCase();
toLispCase(String name) =>
    name?.replaceAll("_", "-").replaceAll(" ", "-")?.toLowerCase();
toCamelCase(String str) => toLispCase(str)
    ?.split('-')
    ?.map((e) => e[0].toUpperCase() + e.substring(1))
    .join('');

DartFormatter _formatter = new DartFormatter();

writeInDartFile(String path, String content) {
  writeInFile(path, _formatter.format(content));
}

writeInFile(String path, String content) {
  File fileDart = createFile(path);
  fileDart.writeAsStringSync(content);
}