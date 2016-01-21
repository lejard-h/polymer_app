/**
 * Created by lejard_h on 04/01/16.
 */

import 'dart:io' as io;
import "dart:async";
import 'package:cupid/cupid.dart';
import 'package:polymer_app/polymer_app_cli.dart';

const default_root_directory = "./";

Question askMaterialDesignLayout = const Question(
    'Which material layout:\n - $nav_view_material\n - $nav_header_material',
    type: String);
Question askName = const Question('Name of your application:', type: String);
Question askRootDirectory = const Question(
    'Localisation of your application (default: "$default_root_directory"):',
    type: String);
Question askMaterial = const Question(
    'Do you want material design application (Y/n):',
    type: String);

main([List<String> args, __]) async => cupid(new PolymerApp(), args, __);

class PolymerApp extends Program {
  io.Directory outputFolder;
  io.File configFile;
  PolymerAppManager manager;
  String appName;
  String rootDirectoryPath;
  bool isShell = false;

  @Command('Launch polymer_app as_shell')
  as_shell() {
    isShell = true;
  }

  PolymerApp();
  setUp() {
    InputDevice.prompt = new Output('<cyan>polymer_app ></cyan> ');
    _getOutputFodler("./");
    _getConfigFile();
    if (configFile.existsSync()) {
      print("'polymer_app.json' config found.");
    }
  }

  myExit() {
    if (!isShell) {
      exit();
    }
  }

  _testField(String field, String msg, [bool test(String)]) {
    if (field.isEmpty || (test != null && !test(field))) {
      printDanger("Please enter a valid $msg");
      myExit();
    }
  }

  Future<String> _askLib(String name, String libPath) async {
    String dirPath = await ask(new Question(
        '$name directory path (default: $libPath):',
        type: String));
    if (dirPath.isNotEmpty) {
      return dirPath;
    }
    return libPath;
  }

  @Command('Version')
  version() {
    this.print(package_version);
  }

  @Command('Create new polymer_app route.')
  route(String name, String path,
      {@Option('The output folder of your route') String output_folder,
      @Option('Is default route') bool isDefault: false}) async {
    _testField(name, "route name");
    _testField(path, "route path");
    String libPath = _initNewAction();

    if (manager != null) {
      libPath = manager.routes.libraryPath;
    } else {
      libPath = await _askLib("route", libPath);
    }

    print("Creating '${green(name)}' route");

    RoutesManager routes = manager?.routes ?? new RoutesManager(name, libPath);

    await routes.createRoute(name, path, isDefault: isDefault);
    if (manager != null) {
      await routes.addToLibrary("$name-route");
    }
    myExit();
  }

  _initNewAction() {
    _getOutputFodler("./");
    _getConfigFile();
    return "./";
  }

  @Command('Create new polymer_app model.')
  model(String name,
      {@Option('The output folder of your service')
      String output_folder: "./"}) async {
    _testField(name, "model name");
    String libPath = _initNewAction();

    if (manager != null) {
      libPath = manager.models.libraryPath;
    } else {
      libPath = await _askLib("model", libPath);
    }

    print("Creating '${green(name)}' model");
    ModelsManager models = manager?.models ?? new ModelsManager(name, libPath);

    await models.createModel(name);
    if (manager != null) {
      await models.addToLibrary("$name\_model");
    }
    myExit();
  }

  @Command('Create new polymer_app service.')
  service(String name,
      {@Option('The output folder of your service')
      String output_folder: "./"}) async {
    _testField(name, "service name");
    String libPath = _initNewAction();

    if (manager != null) {
      libPath = manager.services.libraryPath;
    } else {
      libPath = await _askLib("service", libPath);
    }

    printInfo("Creating '${green(name)}' service");

    ServicesManager services =
        manager?.services ?? new ServicesManager(name, libPath);

    await services.createService(name);
    if (manager != null) {
      await services.addToLibrary("$name\_service");
    }
    myExit();
  }

  @Command('Create new polymer behavior.')
  behavior(String name,
      {@Option('The output folder of your service')
      String output_folder: "./"}) async {
    _testField(name, "behavior name");
    String libPath = _initNewAction();

    if (manager != null) {
      libPath = manager.behaviors.libraryPath;
    } else {
      libPath = await _askLib("behavior", libPath);
    }
    BehaviorsManager behaviors =
        manager?.behaviors ?? new BehaviorsManager(name, libPath);

    print("Creating '${green(name)}' behavior");
    await behaviors.createBehavior(name);
    if (manager != null) {
      await behaviors.addToLibrary("$name\_behavior");
    }
    myExit();
  }

  @Command('Create new polymer element.')
  element(String name,
      {@Option('The output folder of your service')
      String output_folder: "./"}) async {
    _testField(name, "element name",
        (field) => toLispCase(field).split("-").length >= 2);
    String libPath = _initNewAction();

    if (manager != null) {
      libPath = manager.elements.libraryPath;
    } else {
      libPath = await _askLib("element", libPath);
    }

    ElementsManager elements =
        manager?.elements ?? new ElementsManager(name, libPath);

    print("Creating '${green(name)}' element");
    await elements.createElement(name);
    if (manager != null) {
      await elements.addToLibrary(name);
    }
    myExit();
  }

  @Command('Create new polymer_app config.')
  config(String name,
      {@Option('The output folder of your service')
      String output_folder: "./"}) async {
    rootDirectoryPath = output_folder;
    appName = name;
    _testField(name, "application name");
    _getOutputFodler(rootDirectoryPath);
    io.File config = writeInFile(
        "${outputFolder.resolveSymbolicLinksSync()}/polymer_app.json",
        getDefaultJsonConfig(appName));
    myExit();
    return config;
  }

  @Command('Create new polymer application.')
  app(String name,
      {@Option(
          'The output folder of your application (default: application_name)')
      String output_folder,
      @Option('True if you want Material Design') bool is_material: true,
      @Option('Material design layout') String material_layout}) async {
    appName = name;
    _testField(name, "application name");
    rootDirectoryPath = output_folder;
    if (rootDirectoryPath == null) {
      rootDirectoryPath = "./$appName";
    }
    if (material_layout == null) {
      material_layout = nav_view_material;
    }
    _getOutputFodler(rootDirectoryPath);
    _getConfigFile();

    printInfo("Creating '${green(appName)}' application");
    await writeInFile(
        "${outputFolder.resolveSymbolicLinksSync()}/polymer_app.json",
        getDefaultJsonConfig(appName));
    _getConfigFile();
    await manager?.createApplication(
        material: is_material, materialLayout: material_layout);
    this.print("${green("cd $rootDirectoryPath; pub get; pub serve")}");
    myExit();
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
