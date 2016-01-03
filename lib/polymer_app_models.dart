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
      'import "package:polymer_app/serializer.dart";\n'
      '/// @serializable specify that ${toCamelCase(name)} can be serialize/deserialize by polymer_app\n'
      '@serializable\n'
      'class ${toCamelCase(name)} extends PolymerModel {'
      '@reflectable\n'
      'String bar;\n\n'
      '/// The Serializer need to have an empty constructor on the class or a contructor with optionnal value\n'
      '${toCamelCase(name)}([this.bar]);\n\n'
      '${toCamelCase(name)}.foo(this.bar);'
      '}';
}
