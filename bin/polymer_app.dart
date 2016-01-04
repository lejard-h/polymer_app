/**
 * Created by lejard_h on 04/01/16.
 */

import 'dart:io' as io;
import 'package:cupid/cupid.dart';
import 'package:polymer_app/utils.dart';
import "package:polymer_app/polymer_app_manager.dart";
import "package:polymer_app/polymer_app_services.dart";
import "package:polymer_app/polymer_app_models.dart";
import "package:polymer_app/polymer_app_behaviors.dart";
import "package:polymer_app/polymer_app_elements.dart";
import "package:polymer_app/polymer_app_routes.dart";

const default_root_directory = "./";

Question askName = const Question('Name of your application:', type: String);
Question askRootDirectory = const Question(
    'Localisation of your application (default: "$default_root_directory"):',
    type: String);
Question askMaterial = const Question(
    'Do you want material design application (Y/n):',
    type: String);

main(List<String> args, __) {
  cupid(new PolymerApp(), args, __);
}

class PolymerApp extends Program {
  io.Directory outputFolder;
  io.File configFile;
  PolymerAppManager manager;
  String appName;
  String rootDirectoryPath;

  @Command('Create new polymer_app route.')
  new_route(
      {@Option('Your route name') String name,
      @Option('Your route path') String path}) async {
    if (name == null) {
      Question askBehaviorName =
      const Question('Name of your route:', type: String);
      name = await ask(askBehaviorName);
      if (name?.isEmpty) {
        printDanger("Please enter a valid route name");
        exit();
      }
    }
    if (path == null) {
      Question askRoutePath =
      const Question('Path of your route:', type: String);
      path = await ask(askRoutePath);
      if (path?.isEmpty) {
        printDanger("Please enter a valid route path");
        exit();
      }
    }
    String behaviorDirectory = "./";
    _getOutputFodler("./");
    _getConfigFile();

    if (manager != null) {
      behaviorDirectory = manager.routes.libraryPath;
    }

    Question askElementsDirectory = new Question(
        'Route directory path (default: $behaviorDirectory):',
        type: String);
    String behaviorsDirectoryPath = await ask(askElementsDirectory);
    if (behaviorDirectory.isEmpty) {
      behaviorDirectory = behaviorDirectory;
    }

    print("Creating '${green(name)}' route");

    RoutesManager routes =
        manager?.routes ?? new RoutesManager(name, behaviorsDirectoryPath);

    routes.createRoute(name, path);
    if (manager != null) {
      routes.addToLibrary("$name-route");
    }
  }

  @Command('Create new polymer_app model.')
  new_model({@Option('Your model name') String name}) async {
    if (name == null) {
      Question askBehaviorName =
      const Question('Name of your model:', type: String);
      name = await ask(askBehaviorName);
      if (name?.isEmpty) {
        printDanger("Please enter a valid model name");
        exit();
      }
    }
    String behaviorDirectory = "./";
    _getOutputFodler("./");
    _getConfigFile();

    if (manager != null) {
      behaviorDirectory = manager.models.libraryPath;
    }

    Question askElementsDirectory = new Question(
        'Model directory path (default: $behaviorDirectory):',
        type: String);
    String behaviorsDirectoryPath = await ask(askElementsDirectory);
    if (behaviorDirectory.isEmpty) {
      behaviorDirectory = behaviorDirectory;
    }

    print("Creating '${green(name)}' model");
    ModelsManager models =
        manager?.models ?? new ModelsManager(name, behaviorsDirectoryPath);

    models.createModel(name);
    if (manager != null) {
      models.addToLibrary("$name-model");
    }
  }

  @Command('Create new polymer_app service.')
  new_service({@Option('Your service name') String name}) async {
    if (name == null) {
      Question askServiceName =
      const Question('Name of your service:', type: String);
      name = await ask(askServiceName);
      if (name?.isEmpty) {
        printDanger("Please enter a valid service name");
        exit();
      }
    }
    String serviceDirectory = "./";
    _getOutputFodler("./");
    _getConfigFile();

    if (manager != null) {
      serviceDirectory = manager.services.libraryPath;
    }

    Question askServiceDirectory = new Question(
        'Service directory path (default: $serviceDirectory):',
        type: String);
    String serviceDirectoryPath = await ask(askServiceDirectory);
    if (serviceDirectoryPath.isEmpty) {
      serviceDirectoryPath = serviceDirectory;
    }

    printInfo("Creating '${green(name)}' service");

    ServicesManager services =
        manager?.services ?? new ServicesManager(name, serviceDirectoryPath);

    services.createService(name);
    if (manager != null) {
      services.addToLibrary("$name-service");
    }
  }

  @Command('Create new polymer behavior.')
  new_behavior({@Option('Your behavior name') String name}) async {
    if (name == null) {
      Question askBehaviorName =
      const Question('Name of your behavior:', type: String);
      name = await ask(askBehaviorName);
      if (name?.isEmpty) {
        printDanger("Please enter a valid behavior name");
        exit();
      }
    }
    String behaviorDirectory = "./";
    _getOutputFodler("./");
    _getConfigFile();

    if (manager != null) {
      behaviorDirectory = manager.behaviors.libraryPath;
    }

    Question askElementsDirectory = new Question(
        'Behavior directory path (default: $behaviorDirectory):',
        type: String);
    String behaviorsDirectoryPath = await ask(askElementsDirectory);
    if (behaviorDirectory.isEmpty) {
      behaviorDirectory = behaviorDirectory;
    }
    BehaviorsManager behaviors = manager?.behaviors ??
        new BehaviorsManager(name, behaviorsDirectoryPath);

    print("Creating '${green(name)}' behavior");
    behaviors.createBehavior(name);
    if (manager != null) {
      behaviors.addToLibrary("$name-behavior");
    }
  }

  @Command('Create new polymer element.')
  new_element({@Option('Your element name') String name}) async {
    if (name == null) {
      Question askElementName =
      const Question('Name of your element:', type: String);
      name = await ask(askElementName);
      if (name?.isEmpty || toLispCase(name).split("-").length < 2) {
        printDanger("Please enter a valid element name");
        exit();
      }
    }
    String elementDirectory = "./";
    _getOutputFodler("./");
    _getConfigFile();

    if (manager != null) {
      elementDirectory = manager.elements.libraryPath;
    }

    Question askElementsDirectory = new Question(
        'Element directory path (default: $elementDirectory):',
        type: String);
    String elementsDirectoryPath = await ask(askElementsDirectory);
    if (elementDirectory.isEmpty) {
      elementDirectory = elementDirectory;
    }

    ElementsManager elements =
        manager?.elements ?? new ElementsManager(name, elementsDirectoryPath);

    print("Creating '${green(name)}' element");
    elements.createElement(name);
    if (manager != null) {
      elements.addToLibrary(name);
    }
  }

  @Command('Create new polymer_app config.')
  new_config(
      {@Option('Your application name') String name,
      @Option('The output folder of your application')
      String configOutputFolderPath: "./"}) async {
    rootDirectoryPath = configOutputFolderPath;
    appName = name;
    if (appName == null) {
      appName = await _askAppName();
    }
    _getOutputFodler(rootDirectoryPath);
    writeInFile("${outputFolder.resolveSymbolicLinksSync()}/polymer_app.json",
        getDefaultJsonConfig(appName));
  }

  @Command('Create new polymer application.')
  new_application(
      {@Option('Your application name') String name,
      @Option('The output folder of your application')
      String outputFolderPath: "./"}) async {
    appName = name;
    if (appName == null) {
      appName = await _askAppName();
    }
    rootDirectoryPath = outputFolderPath;
    _getOutputFodler(rootDirectoryPath);
    _getConfigFile();
    bool isMaterial = await _askMaterial();
    printInfo("Creating '${green(appName)}' application");
    writeInFile("${outputFolder.resolveSymbolicLinksSync()}/polymer_app.json",
        getDefaultJsonConfig(appName));
    _getConfigFile();
    manager.createApplication(material: isMaterial);
  }

  _getOutputFodler(String outputFolderPath) {
    if (!outputFolderPath.startsWith("./") &&
        !outputFolderPath.startsWith("/")) {
      outputFolderPath = "./$outputFolderPath";
    }
    outputFolder = new io.Directory(outputFolderPath);
    if (!outputFolder.existsSync()) {
      outputFolder.createSync(recursive: true);
    }
  }

  _getConfigFile() {
    configFile = new io.File(
        "${outputFolder?.resolveSymbolicLinksSync()}/polymer_app.json");

    if (configFile.existsSync()) {
      manager = new PolymerAppManager(configFile.resolveSymbolicLinksSync(),
          outputFolder.resolveSymbolicLinksSync());
    }
  }

  _askAppName() async {
    String appName = await ask(askName);
    if (appName?.isEmpty || appName == "test") {
      printDanger("Please enter a valid application name.");
      exit();
    }
    return appName;
  }

  _askRootDirectory() async {
    String rootDirectory = await ask(askRootDirectory);
    if (rootDirectory?.isEmpty) {
      rootDirectory = default_root_directory;
    }
    return rootDirectory;
  }

  _askMaterial() async {
    String material = await ask(askMaterial);
    bool isMaterial = true;
    material = material.toLowerCase();
    if (material == "n") {
      isMaterial = false;
    }
    return isMaterial;
  }

  _askMinimum() async {
    rootDirectoryPath = await _askRootDirectory();
    _getOutputFodler(rootDirectoryPath);
    _getConfigFile();
    if (manager?.name != null) {
      appName = manager.name;
    } else {
      appName = await _askAppName();
    }
  }
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
