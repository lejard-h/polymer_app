/**
 * Created by lejard_h on 24/12/15.
 */

library polymer_app.models;

import "polymer_app_manager.dart";
import "utils.dart";
import "dart:io";

class ModelsManager extends Manager {
  ModelsManager.fromMap(Map config, String rootPath, String appName) : super.fromMap(config, rootPath, appName);
  ModelsManager.fromJson(String json, String rootPath, String appName) : super.fromJson(json, rootPath,appName);

  addToLibrary(String name) {
    File services = new File("$completePath/models.dart");
    services.writeAsString(services.readAsStringSync() +
        "\n" +
        "export '${toSnakeCase(name)}/${toSnakeCase(name)}.dart';\n");
  }

  createLibraryDirectory() {
    super.createLibraryDirectory();
    writeInDartFile("$completePath/models.dart", modelsLibTemplate());
  }

  createModel(String name, [String content]) {
    if (content == null) {
      content = modelDartTemplate(name);
    }
    writeInDartFile(
        "$completePath/${toSnakeCase(name)}/${toSnakeCase(name)}.dart",
        content);
    addToLibrary(name);
  }

  modelsLibTemplate() =>"library ${toSnakeCase(appName)}.models;"
          "// export 'model.dart';";

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
