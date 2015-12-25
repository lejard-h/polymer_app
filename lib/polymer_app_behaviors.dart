/**
 * Created by lejard_h on 24/12/15.
 */

library polymer_app.behaviors;

import "polymer_app_manager.dart";
import "utils.dart";
import "dart:io";

class BehaviorsManager extends Manager {

  BehaviorsManager(String appName, String libraryPath) : super(appName, libraryPath, "behaviors");

  createBehavior(String name, [String content]) {
    if (content == null) {
      content = behaviorDartTemplate(name);
    }
    writeInDartFile(
        "$libraryPath/${toSnakeCase(name)}/${toSnakeCase(name)}.dart",
        content);
    addToLibrary(name);
  }

  String get libraryTemplate =>
      "library ${toSnakeCase(appName)}.behaviors;"
          "// export 'behavior.dart';";

  behaviorDartTemplate(String name) =>
      'library ${toSnakeCase(appName)}.elements.${toSnakeCase(name)};'
      'import "package:polymer/polymer.dart";'
      '@behavior'
      'abstract class ${toCamelCase(name)} {'
      "/// Called when an instance of ${toCamelCase(name)} is inserted into the DOM."
      "attached() {"
      "super.attached();"
      "}"
      "/// Called when an instance of ${toCamelCase(name)} is removed from the DOM."
      "detached() {"
      "super.detached();"
      "}"
      "/// Called when an attribute (such as  a class) of an instance of ${toCamelCase(name)} is added, changed, or removed."
      "attributeChanged(String name, String oldValue, String newValue) {"
      "}"
      "/// Called when ${toCamelCase(name)} has been fully prepared (Shadow DOM created, property observers set up, event listeners attached)."
      "ready() {"
      "}"
      '}';
}
