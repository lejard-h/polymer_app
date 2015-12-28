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
import "package:polymer_app/polymer_app_services.dart";
import "package:polymer_app/polymer_app_models.dart";
import "package:polymer_app/polymer_app_behaviors.dart";
import "package:polymer_app/polymer_app_elements.dart";
import "package:polymer_app/polymer_app_routes.dart";

final AnsiPen green = new AnsiPen()..green(bold: true);
final AnsiPen white = new AnsiPen()..white(bold: true);

PolymerAppManager manager;
Directory outputFolder;
File config;
String outputFolderPath;

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

createNewApplication(ArgResults results, { material: false}) {
  String appName = results.rest[2];
  print("Creating '${green(appName)}' application");
  writeInFile("${outputFolder.resolveSymbolicLinksSync()}/polymer_app.json",
      getDefaultJsonConfig(appName));
  manager.createApplication(material: material);
}

createNewService(String name) {
  print("Creating '${green(name)}' service");

  ServicesManager services =
      manager?.services ?? new ServicesManager(name, outputFolderPath);

  services.createService(name);
  if (manager != null) {
    services.addToLibrary(name);
  }

}

createNewModel(String name) {
  print("Creating '${green(name)}' model");
  ModelsManager models =
      manager?.models ?? new ModelsManager(name, outputFolderPath);

  models.createModel(name);
  if (manager != null) {
    models.addToLibrary(name);
  }
}

createNewElement(String name) {
  if (toLispCase(name).split("-")?.length < 2) {
    print("Bad element name, should be 'polymer-element'");
    exit(1);
  }

  ElementsManager elements =
      manager?.elements ?? new ElementsManager(name, outputFolderPath);

  print("Creating '${green(name)}' element");
  elements.createElement(name);
  if (manager != null) {
    elements.addToLibrary(name);
  }
}

createNewBehavior(String name) {
  BehaviorsManager behaviors = manager?.behaviors ?? new BehaviorsManager(name, outputFolderPath);
  print(outputFolderPath);

  print("Creating '${green(name)}' behavior");
  behaviors.createBehavior(name);
  if (manager != null) {
    behaviors.addToLibrary(name);
  }
}

createNewRoute(String routeName, String path) {
  print("Creating '${green(routeName)}' route");

  RoutesManager routes = manager?.routes ?? new RoutesManager("$routeName-route", outputFolderPath);

  routes.createRoute("$routeName-route");
  print(white("\nImport and add page to your root-element\n"));
  if (manager != null) {
    routes.addToLibrary("$routeName-route");
   /* print(green(
        "import 'package:${toSnakeCase(manager.name)}/routes/routes.dart';") +
        "\n");*/
  }
  print("List<Page> _pages = [");
  print("...");
  print(green(
      "\tnew Page('${toCamelCase(routeName)}', '${toSnakeCase(path)}', document.createElement('${toLispCase(routeName + "-route")}'))"));
  print("...");
  print("];");
}

void main(List<String> args) {
  ArgParser parser = new ArgParser(allowTrailingOptions: true);

  parser.addOption('output-folder', abbr: "o", defaultsTo: "./");
  parser.addFlag('help', abbr: 'h');
  parser.addFlag('material', abbr: 'm', defaultsTo: false);

  try {
    ArgResults results = parser.parse(args);
    bool materialDesign = results["material"];
    outputFolderPath = results["output-folder"];
    outputFolder = new Directory(outputFolderPath);
    if (!outputFolder.existsSync()) {
      outputFolder.createSync(recursive: true);
    }
    config = new File("$outputFolderPath/polymer_app.json");

    if (config.existsSync()) {
      manager = new PolymerAppManager(config.resolveSymbolicLinksSync(),
          outputFolder.resolveSymbolicLinksSync());
    }

    if (isCommandNew(results.rest, "app")) {
      if (manager == null) {
        manager = new PolymerAppManager.fromJson(
            getDefaultJsonConfig(results.rest[2]), outputFolder.resolveSymbolicLinksSync());
      }
      return createNewApplication(results, material: materialDesign);
    } else if (isCommandNew(results.rest)) {
      if (results.rest[1] == "element") {
        return createNewElement(results.rest[2]);
      } else if (results.rest[1] == "behavior") {
        return createNewBehavior(results.rest[2]);
      } else if (results.rest[1] == "model") {
        return createNewModel(results.rest[2]);
      } else if (results.rest[1] == "service") {
        return createNewService(results.rest[2]);
      } else if (results.rest.length == 4 && results.rest[1] == "route") {
        return createNewRoute(results.rest[2], results.rest[3]);
      } else {
        usage(parser);
      }
    } else {
      usage(parser);
    }
  } catch (e) {
    print(e);
    usage(parser);
  }
}

void usage(ArgParser parser) {
  print('polymer_app \n'
      'new app app_name\n'
      'new element element-name\n'
      'new model name\n'
      'new behavior name\n'
      'new service name\n'
      'new route name path\n');
  print(parser.usage);
}

String getDefaultJsonConfig(String appName, [String path = "lib"]) => '{'
    '"name": "$appName",'
    '"library_path": "$path",'
    '"web_path": "web",'
    '"elements_path": "elements",'
    '"services_path": "services",'
    '"behaviors_path": "behaviors",'
    '"models_path":  "models",'
    '"routes_path": "routes"'
    '}';
