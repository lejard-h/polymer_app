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
import 'package:ansicolor/ansicolor.dart';
import 'package:polymer_app/utils.dart';
import "package:polymer_app/polymer_app_manager.dart";

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

createNewApplication() {
  print("Creating '${green(manager.name)}' application");
  manager.createApplication();
}

createNewService(String name) {
  print("Creating '${green(name)}' service");
  manager.services.createService(name);
}

createNewModel(String name) {
  print("Creating '${green(name)}' model");
  manager.models.createModel(name);
}

createNewElement(String name) {
  if (toLispCase(name).split("-")?.length < 2) {
    print("Bad element name, should be 'polymer-element'");
    exit(1);
  }
  print("Creating '${green(name)}' element");
  manager.elements.createElement(name);
}

createNewBehavior(String name) {
  print("Creating '${green(name)}' behavior");
  manager.behaviors.createBehavior(name);
}

createNewRoute(String routeName, String path) {
  print("Creating '${green(routeName)}' route");
  manager.routes.createRoute("$routeName-route");

  print(white("\nImport and add page to your root-element\n"));
  print(green(
          "import 'package:${toSnakeCase(manager.name)}/elements/routes/routes.dart';") +
      "\n");
  print("List<Page> _pages = [");
  print("...");
  print(green(
      "\tnew Page('${toCamelCase(routeName)}', '${toSnakeCase(path)}', document.createElement('${toLispCase(routeName + "-route")}'))"));
  print("...");
  print("];");
}

PolymerAppManager manager;

void main(List<String> args) {
  ArgParser parser = new ArgParser(allowTrailingOptions: true);

  parser.addFlag('help', abbr: 'h');

  ArgResults results = parser.parse(args);

  File config = new File("./polymer_app.json");
  if (config.existsSync()) {
    print("'polymer_app.json' found.");
    manager = new PolymerAppManager(config.resolveSymbolicLinksSync());
  }

  if (results.rest.length == 3 && results.rest[0] == "new") {
    if (results.rest[1] == "app") {
      manager =
          new PolymerAppManager.fromJson(getDefaultJsonConfig(results.rest[2]));
      writeInFile("./polymer_app.json", getDefaultJsonConfig(results.rest[2]));
      return createNewApplication();
    } else if (results.rest[1] == "element" && manager != null) {
      return createNewElement(results.rest[2]);
    } else if (results.rest[1] == "behavior" && manager != null) {
      return createNewBehavior(results.rest[2]);
    } else if (results.rest[1] == "model" && manager != null) {
      return createNewModel(results.rest[2]);
    } else if (results.rest[1] == "service" && manager != null) {
      return createNewService(results.rest[2]);
    }
  } else if (results.rest.length == 4 &&
      results.rest[0] == "new" &&
      results.rest[1] == "route" &&
      manager != null) {
    return createNewRoute(results.rest[2], results.rest[3]);
  }
  if (manager == null) {
    print("No 'polymer_app.json found.");
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

String getDefaultJsonConfig(String appName, [String path = "./"]) => '{'
    '"name": "$appName",'
    '"directory": "$path",'
    '"web-directory": "web",'
    '"elements": {'
    ' "list": [],'
    '"directory": "elements"'
    '},'
    ' "services": {'
    '"list": [],'
    '"directory": "services"'
    '},'
    '"behaviors": {'
    '"list": [],'
    '"directory": "behaviors"'
    '},'
    '"models": {'
    '"list": [],'
    '"directory": "models"'
    '},'
    '"routes": {'
    '"list": [],'
    '"directory": "elements/routes"'
    '}'
    '}';
