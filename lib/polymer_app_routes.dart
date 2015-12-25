/**
 * Created by lejard_h on 24/12/15.
 */

library polymer_app.routes;

import "polymer_app_manager.dart";
import "polymer_app_elements.dart";
import "utils.dart";
import "dart:io";

class RoutesManager extends Manager {
  ElementsManager elements;

  RoutesManager(String appName, String libraryPath)
      : super(appName, libraryPath, "routes") {
    elements = new ElementsManager(appName, libraryPath);
  }

  String get libraryTemplate => "library ${toSnakeCase(appName)}.routes;"
      "// export 'route.dart';";

  createRoute(String name) {
    writeInDartFile(
        "$libraryPath/${toSnakeCase(name)}/${toSnakeCase(name)}.dart",
        routeDartTemplate(name));
    writeInFile("$libraryPath/${toSnakeCase(name)}/${toSnakeCase(name)}.html",
        elements.elementHtmlTemplate(name));
    writeInFile("$libraryPath/${toSnakeCase(name)}/${toSnakeCase(name)}.css",
        elements.elementCssTemplate(name));
  }

  routeDartTemplate(String name) => "@HtmlImport('${toSnakeCase(name)}.html')"
      "library ${toSnakeCase(appName)}.elements.${toSnakeCase(name)};"
      "import 'package:polymer/polymer.dart';"
      "import 'package:web_components/web_components.dart' show HtmlImport;"
      'import "package:polymer_app_router/polymer_app_router.dart";'
      'import "package:route_hierarchical/client.dart";\n'
      "@PolymerRegister('${toLispCase(name)}')\n"
      "class ${toCamelCase(name)} extends PolymerElement with PolymerAppRouteBehavior { "
      "${toCamelCase(name)}.created() : super.created();\n\n"
      "/// Called when an instance of ${toLispCase(name)} is inserted into the DOM.\n"
      "attached() {"
      "super.attached();"
      "}\n\n"
      "/// Called when an instance of ${toLispCase(name)} is removed from the DOM.\n"
      "detached() {"
      "super.detached();"
      "}\n\n"
      "/// Called when an attribute (such as  a class) of an instance of ${toLispCase(name)} is added, changed, or removed.\n"
      "attributeChanged(String name, String oldValue, String newValue) {"
      "}\n\n"
      "/// Called when ${toLispCase(name)} has been fully prepared (Shadow DOM created, property observers set up, event listeners attached).\n"
      "ready() {"
      "}\n\n"
      "/// Called when PolymerRouter enter on ${toLispCase(name)}\n"
      "enter(RouteEnterEvent event, [Map params]) {}\n\n"
      "}";
}
