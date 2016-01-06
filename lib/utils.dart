/**
 * Created by lejard_h on 23/12/15.
 */

library polymer_app.utils;

import 'dart:io';
import 'package:dart_style/dart_style.dart';
import "dart:async";


String green(String value) => "<green>$value</green>";
String white(String value) => "<white>$value</white>";
String red(String value) => "<red>$value</red>";

Future<Directory> createDirectory(String path) async {
  Directory dir = new Directory(path);
  if (!dir.existsSync()) {
    await dir.create(recursive: true);
  }
  if (dir.existsSync()) {
    print("Creating '${white(path)}' directory. ${green("Success")}");
  } else {
    print("Creating '${white(path)}' directory. ${red("Fail")}");
    throw "Impossible to create directory ${white(path)}";
  }
  return dir;
}

Future<File> createFile(String path) async {
  File file = new File(path);
  if (!file.existsSync()) {
    await file.create(recursive: true);
  }
  if (file.existsSync()) {
    print("Creating '${white(path)}' file. ${green("Success")}");
  } else {
    print("Creating '${white(path)}' file. ${red("Fail")}");
    throw "Impossible to create file ${white(path)}";
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

writeInDartFile(String path, String content) async =>
    writeInFile(path, _formatter.format(content));

writeInFile(String path, String content) async {
  File fileDart = await createFile(path);
  await fileDart.writeAsString(content);
  return fileDart;
}
