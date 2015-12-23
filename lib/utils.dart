/**
 * Created by lejard_h on 23/12/15.
 */

library polymer_app.utils;

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

createService(String name, String path, String appName) {
  Directory dir = createDirectory("$path${toSnakeCase(name)}");

  File services = new File("$path/services.dart");
  services.writeAsString(services.readAsStringSync() +
      "\n" +
      "export '${toSnakeCase(name)}/${toSnakeCase(name)}.dart';\n");

  File fileDart =
  createFile("${dir.resolveSymbolicLinksSync()}/${toSnakeCase(name)}.dart");
  fileDart.writeAsStringSync(factoryContent(name, appName));
}

createPolymerBehavior(String name, String path, String appName) {
  Directory dir = createDirectory("$path${toSnakeCase(name)}");

  File behaviors = new File("$path/behaviors.dart");
  behaviors.writeAsString(behaviors.readAsStringSync() +
      "\n" +
      "export '${toSnakeCase(name)}/${toSnakeCase(name)}.dart';\n");

  File fileDart =
  createFile("${dir.resolveSymbolicLinksSync()}/${toSnakeCase(name)}.dart");
  fileDart.writeAsStringSync(polymerBehaviorContent(name, appName));
}

createRouteElement(String name, String path, String appName) {
  name = name + "-route";
  Directory dir = createDirectory("${path}route/${toSnakeCase(name)}");

  File elements = new File("$path/elements.dart");
  elements.writeAsString(elements.readAsStringSync() +
      "\n" +
      "export 'route/${toSnakeCase(name)}/${toSnakeCase(name)}.dart';\n");

  File fileDart =
  createFile("${dir.resolveSymbolicLinksSync()}/${toSnakeCase(name)}.dart");
  fileDart.writeAsStringSync(polymerElementDartRouteContent(name, appName));

  File fileHtml =
  createFile("${dir.resolveSymbolicLinksSync()}/${toSnakeCase(name)}.html");
  fileHtml.writeAsStringSync(polymerElementHtmlContent(name));

  File fileCss =
  createFile("${dir.resolveSymbolicLinksSync()}/${toSnakeCase(name)}.css");
  fileCss.writeAsStringSync(polymerElementCssContent());
}

createPolymerElement(String name, String path, String appName) {
  Directory dir = createDirectory("$path${toSnakeCase(name)}");

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

createModel(String name, String path, String appName) {
  Directory dir = createDirectory("$path${toSnakeCase(name)}");

  File models = new File("$path/models.dart");
  models.writeAsString(models.readAsStringSync() +
      "\n" +
      "export '${toSnakeCase(name)}/${toSnakeCase(name)}.dart';\n");

  File fileDart =
  createFile("${dir.resolveSymbolicLinksSync()}/${toSnakeCase(name)}.dart");
  fileDart.writeAsStringSync(modelContent(name, appName));
}

toSnakeCase(String name) => name?.replaceAll("-", "_").replaceAll(" ", "_")?.toLowerCase();
toLispCase(String name) => name?.replaceAll("_", "-").replaceAll(" ", "-")?.toLowerCase();
toCamelCase(String str) => toLispCase(str)
    ?.split('-')
    ?.map((e) => e[0].toUpperCase() + e.substring(1))
    .join('');
