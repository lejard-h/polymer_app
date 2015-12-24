/**
 * Created by lejard_h on 24/12/15.
 */

library polymer_app.models;

import "polymer_app_manager.dart";
import "utils.dart";
import "dart:io";

class ModelsManager extends JsonObject {
  String rootPath;
  String appName;

  String get completePath => "$rootPath/$path";

  String get path => get("directory");
  List get models => get("list");
  ModelsManager.fromMap(Map config) : super.fromMap(config);
  ModelsManager.fromJson(String json) : super.fromJson(json);

  addToLibrary(String name) {
    File services = new File("$completePath/models.dart");
    services.writeAsString(services.readAsStringSync() +
        "\n" +
        "export '${toSnakeCase(name)}/${toSnakeCase(name)}.dart';\n");
  }

  createModel(String name, [String content]) {
    if (content == null) {
      content = modelDartTemplate(name);
    }
    createDartFile(
        "$completePath/${toSnakeCase(name)}/${toSnakeCase(name)}.dart",
        content);
    addToLibrary(name);
  }

  modelDartTemplate(String name) => 'library ${toSnakeCase(appName)}.services.${toSnakeCase(name)};'
          'import "package:polymer_app/polymer_model.dart";'
          'class ${toCamelCase(name)} extends PolymerModel {'
          '@reflectable '
          'String foo;'
          '${toCamelCase(name)}(this.foo);'
          '_fromJson(Map json) {'
          'this.foo = json["json"];'
          '}'
          'Map get toMap => {"foo": foo};'
          '}';
}
