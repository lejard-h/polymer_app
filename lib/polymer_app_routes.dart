/**
 * Created by lejard_h on 24/12/15.
 */

library polymer_app.routes;

import "polymer_app_manager.dart";
import "polymer_app_elements.dart";
import "utils.dart";
import "dart:io";

class RoutesManager extends ElementsManager {
  RoutesManager.fromMap(Map config, String rootPath, String appName) : super.fromMap(config, rootPath, appName);
  RoutesManager.fromJson(String json, String rootPath, String appName) : super.fromJson(json, rootPath,appName);

  addToLibrary(String name) {
    File services = new File("$completePath/routes.dart");
    services.writeAsString(services.readAsStringSync() +
        "\n" +
        "export '${toSnakeCase(name)}/${toSnakeCase(name)}.dart';\n");
  }

  createLibraryDirectory() {
    Directory dir = createDirectory("$rootPath/$path");
    completePath = dir.resolveSymbolicLinksSync();
    writeInDartFile("$completePath/routes.dart", routesLibTemplate());
  }

  routesLibTemplate() =>
      "library ${toSnakeCase(appName)}.routes;"
          "// export 'route.dart';";

  createRoute(String name) {
    writeInDartFile(
        "$completePath/${toSnakeCase(name)}/${toSnakeCase(name)}.dart",
        routeDartTemplate(name));
    writeInFile("$completePath/${toSnakeCase(name)}/${toSnakeCase(name)}.html",
        elementHtmlTemplate(name));
    writeInFile("$completePath/${toSnakeCase(name)}/${toSnakeCase(name)}.css",
        elementCssTemplate(name));
    addToLibrary(name);
  }

  routeDartTemplate(String name) =>
      "@HtmlImport('${toSnakeCase(name)}.html')"
          "library $appName.elements.${toSnakeCase(name)};"
          "import 'package:polymer/polymer.dart';"
          "import 'package:web_components/web_components.dart' show HtmlImport;"
          'import "package:polymer_app_router/polymer_app_router.dart";'
          'import "package:route_hierarchical/client.dart";'
          "@PolymerRegister('${toLispCase(name)}')"
          "class ${toCamelCase(name)} extends PolymerElement with PolymerAppRouteBehavior { "
          "${toCamelCase(name)}.created() : super.created();"
          " /// Called when an instance of ${toLispCase(name)} is inserted into the DOM.\n"
          "attached() {"
          "super.attached();"
          "}\n\n"
          " /// Called when an instance of ${toLispCase(name)} is removed from the DOM.\n"
          "detached() {"
          "super.detached();"
          "}\n\n"
          "/// Called when an attribute (such as  a class) of an instance of ${toLispCase(name)} is added, changed, or removed.\n"
          "attributeChanged(String name, String oldValue, String newValue) {"
          "}\n\n"
          " /// Called when ${toLispCase(name)} has been fully prepared (Shadow DOM created, property observers set up, event listeners attached).\n"
          "ready() {"
          "}\n\n"
          "/// Called when PolymerRouter enter on ${toLispCase(name)}\n"
          "enter(RouteEnterEvent event, [Map params]) {}\n\n"
          "}";
}
