/**
 * Created by lejard_h on 24/12/15.
 */

library polymer_app.manager;

import 'dart:io';
import "utils.dart";
import "dart:convert";
import "polymer_app_services.dart";
import "polymer_app_models.dart";
import "polymer_app_behaviors.dart";

abstract class JsonObject {
  Map _obj;

  JsonObject();
  JsonObject.fromMap(this._obj);
  JsonObject.fromJson(String json) {
    _obj = JSON.decode(json);
  }

  get(String key) => _obj[key];
  set(String key, value) => _obj[key] = value;

  Map get toMap => _obj;
  String toString() => toMap.toString();
}

class ElementsManager extends JsonObject {
  String rootPath;
  String appName;

  String get completePath => "$rootPath/$path";

  String get path => get("directory");
  List get elements => get("list");
  ElementsManager.fromMap(Map config) : super.fromMap(config);
  ElementsManager.fromJson(String json) : super.fromJson(json);
}

class RoutesManager extends ElementsManager {
  String rootPath;
  String appName;

  String get completePath => "$rootPath/$path";

  String get path => get("directory");
  List get routes => get("list");
  RoutesManager.fromMap(Map config) : super.fromMap(config);
  RoutesManager.fromJson(String json) : super.fromJson(json);
}

class PolymerAppManager extends JsonObject {
  ElementsManager _elements;
  BehaviorsManager _behaviors;
  ServicesManager _services;
  ModelsManager _models;
  RoutesManager _routes;

  PolymerAppManager.fromJson(String configJson) : super.fromJson(configJson) {
    _parseConfig();
  }

  PolymerAppManager.fromMap(Map config) : super.fromMap(config) {
    _parseConfig();
  }

  _parseConfig() {
    if (toMap == null) {
      throw "No config found.";
    }
    _elements = new ElementsManager.fromMap(get("elements"))
      ..appName = name
      ..rootPath = rootDirectory;
    _behaviors = new BehaviorsManager.fromMap(get("behaviors"))
      ..appName = name
      ..rootPath = rootDirectory;
    _services = new ServicesManager.fromMap(get("services"))
      ..appName = name
      ..rootPath = rootDirectory;
    _models = new ModelsManager.fromMap(get("models"))
      ..appName = name
      ..rootPath = rootDirectory;
    _routes = new RoutesManager.fromMap(get("routes"))
      ..appName = name
      ..rootPath = rootDirectory;
  }

  _fromJson(String configJson) {
    _obj = JSON.decode(configJson);
    _parseConfig();
  }

  PolymerAppManager([String configPath = "./polymer_app.json"]) : super() {
    File configFile = new File(configPath);
    if (!configFile.existsSync()) {
      throw "polymer_app.json not found.";
    }

    _fromJson(configFile.readAsStringSync());
  }

  String get rootDirectory => get("directory");
  String get name => get("name");
  String get webDirectory => get("web-directory");

  RoutesManager get routes => _routes;
  ModelsManager get models => _models;
  ServicesManager get services => _services;
  BehaviorsManager get behaviors => _behaviors;
  ElementsManager get elements => _elements;
}
