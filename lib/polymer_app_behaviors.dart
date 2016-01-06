/**
 * Created by lejard_h on 24/12/15.
 */

library polymer_app.behaviors;

import "polymer_app_manager.dart";
import "utils.dart";

class BehaviorsManager extends Manager {

  BehaviorsManager(String appName, String libraryPath) : super(appName, libraryPath, "behaviors");

  createBehavior(String name, [String content]) async {
    name = "$name-behavior";
    if (content == null) {
      content = behaviorDartTemplate(name);
    }
    await writeInDartFile(
        "$libraryPath/${toSnakeCase(name)}.dart",
        content);
  }

  String get libraryTemplate =>
      "library ${toSnakeCase(appName)}.behaviors;"
          "// export 'behavior.dart';";

  behaviorDartTemplate(String name) =>
      'library ${toSnakeCase(appName)}.elements.${toSnakeCase(name)};'
      'import "package:polymer/polymer.dart";'
      '@behavior\n'
      'abstract class ${toCamelCase(name)} {\n\n'
      "/// Called when an instance of ${toCamelCase(name)} is inserted into the DOM.\n"
      "attached() {"
      "super.attached();"
      "}\n\n"
      "/// Called when an instance of ${toCamelCase(name)} is removed from the DOM.\n"
      "detached() {"
      "super.detached();"
      "}\n\n"
      "/// Called when an attribute (such as  a class) of an instance of ${toCamelCase(name)} is added, changed, or removed.\n"
      "attributeChanged(String name, String oldValue, String newValue) {"
      "}\n\n"
      "/// Called when ${toCamelCase(name)} has been fully prepared (Shadow DOM created, property observers set up, event listeners attached).\n"
      "ready() {"
      "}"
      '}';
}
