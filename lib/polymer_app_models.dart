/**
 * Created by lejard_h on 24/12/15.
 */

library polymer_app.models;

import "polymer_app_manager.dart";
import "utils.dart";

class ModelsManager extends Manager {
  ModelsManager(String appName, String libraryPath)
      : super(appName, libraryPath, "models");

  createModel(String name, [String content]) {
    name = "$name-model";
    if (content == null) {
      content = modelDartTemplate(name);
    }
    writeInDartFile(
        "$libraryPath/${toSnakeCase(name)}.dart", content);
  }

  String get libraryTemplate => "library ${toSnakeCase(appName)}.models;"
      "// export 'model.dart';";

  modelDartTemplate(String name) =>
      'library ${toSnakeCase(appName)}.services.${toSnakeCase(name)};\n\n'
      'import "package:polymer/polymer.dart";'
      'import "package:polymer_app/polymer_model.dart";'
      'class ${toCamelCase(name)} extends PolymerModel {'
      '@reflectable '
      'String foo;'
      '${toCamelCase(name)}(this.foo);'
      '${toCamelCase(name)}.fromJson(json) : super.fromJson(json);'
      'fromMap(Map json) {'
      'this.foo = json["json"];'
      '}'
      'Map get toMap => {"foo": foo};'
      '}';
}
