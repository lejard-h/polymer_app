/**
 * Created by lejard_h on 23/12/15.
 */

///
/// Run this script with pub run:
///
///     pub run polymer_app:new_app app_name [-o output_dir]
///
library polymer.bin.new_element;

import 'dart:io';
import 'package:args/args.dart';
import 'package:polymer_app/templates.dart';
import 'package:ansicolor/ansicolor.dart';
import 'package:polymer_app/utils.dart';

final AnsiPen green = new AnsiPen()..green(bold: true);

final AnsiPen white = new AnsiPen()..white(bold: true);

String getAppName(ArgResults results, ArgParser parser) {
  String appName;
  if (results.rest == null || results.rest.isEmpty) {
    print('No app_ame specified');
    usage(parser);
    exit(1);
  }
  appName = results.rest[1];
  return appName;
}

Directory getDirectory(String appName, ArgParser parser) {
  String outputDir = toSnakeCase(appName);

  Directory dir = createDirectory(outputDir);
  if (dir.listSync().isNotEmpty) {
    print('Directory must be empty.');
    usage(parser);
    exit(1);
  }
  return dir;
}

Directory createWebDirectory(Directory root, String appName) {
  print("");
  Directory webDirectory =
      createDirectory("${root.resolveSymbolicLinksSync()}/web");

  File indexHtmlFile =
      createFile("${webDirectory.resolveSymbolicLinksSync()}/index.html");
  indexHtmlFile.createSync(recursive: true);
  indexHtmlFile.writeAsStringSync(indexHtmlContent(appName));

  File indexDartFile =
      createFile("${webDirectory.resolveSymbolicLinksSync()}/index.dart");
  indexDartFile.createSync(recursive: true);
  indexDartFile.writeAsStringSync(indexDartContent(appName));

  return webDirectory;
}

Directory createModelsDirectory(Directory root, String appName) {
  Directory modelsDirectory =
      createDirectory("${root.resolveSymbolicLinksSync()}/models");
  File file =
      createFile("${modelsDirectory.resolveSymbolicLinksSync()}/models.dart");
  file.writeAsStringSync(modelsLibContent(appName));
  return modelsDirectory;
}

Directory createBehaviorsDirectory(Directory root, String appName) {
  Directory behaviorsDirectory =
      createDirectory("${root.resolveSymbolicLinksSync()}/behaviors");
  File file = createFile(
      "${behaviorsDirectory.resolveSymbolicLinksSync()}/behaviors.dart");
  file.writeAsStringSync(behaviorsLibContent(appName));
  return behaviorsDirectory;
}

Directory createServicesDirectory(Directory root, String appName) {
  Directory servicesDirectory =
      createDirectory("${root.resolveSymbolicLinksSync()}/services");
  File file = createFile(
      "${servicesDirectory.resolveSymbolicLinksSync()}/services.dart");
  file.writeAsStringSync(servicesLibContent(appName));
  return servicesDirectory;
}

Directory createElementsDirectory(Directory root, String appName) {
  Directory elementsDirectory =
      createDirectory("${root.resolveSymbolicLinksSync()}/elements");
  File file = createFile(
      "${elementsDirectory.resolveSymbolicLinksSync()}/elements.dart");
  file.writeAsStringSync(elementsLibContent(appName));

  Directory dir = createDirectory(
      "${elementsDirectory.resolveSymbolicLinksSync()}/root_element");

  File fileDart =
      createFile("${dir.resolveSymbolicLinksSync()}/root_element.dart");
  fileDart.writeAsStringSync(rootElementDartContent(appName));

  File fileHtml =
      createFile("${dir.resolveSymbolicLinksSync()}/root_element.html");
  fileHtml.writeAsStringSync(rootElementHtmlContent());

  File fileCss =
      createFile("${dir.resolveSymbolicLinksSync()}/root_element.css");

  fileCss.writeAsStringSync(polymerElementCssContent());
  return elementsDirectory;
}

Directory createLibDirectory(Directory root, String appName) {
  print("");
  Directory libDirectory =
      createDirectory("${root.resolveSymbolicLinksSync()}/lib");

  createModelsDirectory(libDirectory, appName);
  createServicesDirectory(libDirectory, appName);
  createBehaviorsDirectory(libDirectory, appName);
  createElementsDirectory(libDirectory, appName);

  File appNameFile = createFile(
      "${libDirectory.resolveSymbolicLinksSync()}/${toSnakeCase(appName)}.dart");
  appNameFile.createSync(recursive: true);
  appNameFile.writeAsStringSync(appLibraryContent(appName));

  return libDirectory;
}

createPubspec(Directory directory, String appName) {
  print("");
  File pubspecFile =
      createFile("${directory.resolveSymbolicLinksSync()}/pubspec.yaml");
  pubspecFile.createSync(recursive: true);
  pubspecFile.writeAsStringSync(pubspecContent(appName));
}

createNewApplication(ArgResults results, ArgParser parser, String appName) {
  print("Creating '${green(appName)}' application");
  Directory directory = getDirectory(appName, parser);

  createPubspec(directory, appName);
  createLibDirectory(directory, appName);
  createWebDirectory(directory, appName);
}

createNewService(ArgResults results, ArgParser parser, String elementName) {
  Directory dir = new Directory(".");
  String library =
      toSnakeCase(dir?.resolveSymbolicLinksSync()?.split("/")?.last);
  createService(
      elementName, dir.resolveSymbolicLinksSync() + "/lib/services/", library);
}

createNewModel(ArgResults results, ArgParser parser, String elementName) {
  Directory dir = new Directory(".");
  String library =
      toSnakeCase(dir?.resolveSymbolicLinksSync()?.split("/")?.last);
  createModel(
      elementName, dir.resolveSymbolicLinksSync() + "/lib/models/", library);
}

createNewElement(ArgResults results, ArgParser parser, String elementName) {
  if (toLispCase(elementName).split("-")?.length < 2) {
    print("Bad element name, should be 'polymer-element'");
    exit(1);
  }
  Directory dir = new Directory(".");
  String library =
      toSnakeCase(dir?.resolveSymbolicLinksSync()?.split("/")?.last);
  createPolymerElement(
      elementName, dir.resolveSymbolicLinksSync() + "/lib/elements/", library);
}

createNewBehavior(ArgResults results, ArgParser parser, String elementName) {
  Directory dir = new Directory(".");
  String library =
      toSnakeCase(dir?.resolveSymbolicLinksSync()?.split("/")?.last);
  createPolymerBehavior(
      elementName, dir.resolveSymbolicLinksSync() + "/lib/behaviors/", library);
}

createNewRoute(
    ArgResults results, ArgParser parser, String routeName, String path) {
  Directory dir = new Directory(".");
  String library =
      toSnakeCase(dir?.resolveSymbolicLinksSync()?.split("/")?.last);
  createRouteElement(
      routeName, dir.resolveSymbolicLinksSync() + "/lib/elements/", library);

  print(white("\nImport and add page to your root-element\n"));
  print(green(
          "import 'package:${toSnakeCase(library)}/elements/route/${toSnakeCase(routeName)}_route/${toSnakeCase(routeName)}_route.dart';") +
      "\n");
  print("List<Page> _pages = [");
  print("...");
  print(green(
      "\tnew Page('${toCamelCase(routeName)}', '${toSnakeCase(path)}', document.createElement('${toLispCase(routeName + "-route")}'))"));
  print("...");
  print("];");
}

void main(List<String> args) {
  ArgParser parser = new ArgParser(allowTrailingOptions: true);

  parser.addFlag('help', abbr: 'h');

  ArgResults results = parser.parse(args);

  if (results.rest.length == 3 && results.rest[0] == "new") {
    if (results.rest[1] == "app") {
      return createNewApplication(results, parser, results.rest[2]);
    } else if (results.rest[1] == "element") {
      return createNewElement(results, parser, results.rest[2]);
    } else if (results.rest[1] == "behavior") {
      return createNewBehavior(results, parser, results.rest[2]);
    } else if (results.rest[1] == "model") {
      return createNewModel(results, parser, results.rest[2]);
    } else if (results.rest[1] == "service") {
      return createNewService(results, parser, results.rest[2]);
    }
  } else if (results.rest.length == 4 &&
      results.rest[0] == "new" &&
      results.rest[1] == "route") {
    return createNewRoute(results, parser, results.rest[2], results.rest[3]);
  }
  usage(parser);
}

void usage(ArgParser parser) {
  print('polymer_app \n'
      ' - new app app_name\n'
      ' - new element element-name\n'
      ' - new model name\n'
      ' - new behavior name\n'
      ' - new service name\n'
      ' - new route name path\n');
  print(parser.usage);
}
