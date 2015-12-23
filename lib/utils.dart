/**
 * Created by lejard_h on 23/12/15.
 */

import 'dart:io';
import 'package:polymer_app/templates.dart';
import 'package:ansicolor/ansicolor.dart';

final AnsiPen green = new AnsiPen()..green(bold: true);

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

createPolymerElement(String name, String path, String appName) {
  Directory dir = createDirectory("$path/${toSnakeCase(name)}");

  File elements = new File("$path/elements.dart");
  elements.writeAsString(elements.readAsStringSync() +
      "\n" +
      "export '${toSnakeCase(name)}/${toSnakeCase(name)}.dart';\n");

  File fileDart =
      createFile("${dir.resolveSymbolicLinksSync()}/${toSnakeCase(name)}.dart");
  fileDart.writeAsStringSync(polymerElementDartContent(name, appName));

  File fileHtml =
      createFile("${dir.resolveSymbolicLinksSync()}/${toSnakeCase(name)}.html");
  fileHtml.writeAsStringSync(polymerElementHtmlContent(name));

  File fileCss =
      createFile("${dir.resolveSymbolicLinksSync()}/${toSnakeCase(name)}.css");
  fileCss.writeAsStringSync(polymerElementCssContent());
}

toSnakeCase(String name) => name?.replaceAll("-", "_").replaceAll(" ", "_");
toLispCase(String name) => name?.replaceAll("_", "-").replaceAll(" ", "-");
toCamelCase(String str) => toLispCase(str)
    ?.split('-')
    ?.map((e) => e[0].toUpperCase() + e.substring(1))
    .join('');
