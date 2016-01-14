/**
 * Created by lejard_h on 24/12/15.
 */


part of polymer_app.cli;

class RoutesManager extends Manager {
  ElementsManager elements;

  RoutesManager(String appName, String libraryPath)
      : super(appName, libraryPath, "routes") {
    appName = "$appName-route";
    elements = new ElementsManager(appName, libraryPath);
  }

  String get libraryTemplate => "library ${toSnakeCase(appName)}.routes;"
      "// export 'route.dart';";

  createRoute(String name, String path,
      {String dartTemplate, String htmlTemplate, String cssTemplate}) async {
    String routeName = name;
    name = "$name-route";
    if (dartTemplate == null) {
      dartTemplate = routeDartTemplate(name, routeName, path);
    }
    htmlTemplate = elements.elementHtmlTemplate(name, htmlTemplate ?? "");
    if (cssTemplate == null) {
      cssTemplate = elements.elementCssTemplate(name);
    }

    await writeInDartFile(
        "$libraryPath/${toSnakeCase(name)}/${toSnakeCase(name)}.dart",
        dartTemplate);
    await writeInFile("$libraryPath/${toSnakeCase(name)}/${toSnakeCase(name)}.html",
        htmlTemplate);
    await writeInFile("$libraryPath/${toSnakeCase(name)}/${toSnakeCase(name)}.css",
        cssTemplate);
  }

  addToLibrary(String name, [String path = "."]) {
    super.addToLibrary(name, name);
  }

  routeDartTemplate(String name, String routeName, String path) => "@HtmlImport('${toSnakeCase(name)}.html')"
      "library ${toSnakeCase(appName)}.elements.${toSnakeCase(name)};"
      "import 'package:polymer/polymer.dart';"
      "import 'package:web_components/web_components.dart' show HtmlImport;"
      'import "package:polymer_app_router/polymer_app_router.dart";'
      'import "package:route_hierarchical/client.dart";'
      'import "package:polymer_app/polymer_router.dart";\n\n'

      '@PolymerRoute("${toCamelCase(routeName)}", "$path")'
      "@PolymerRegister('${toLispCase(name)}')\n"
      "class ${toCamelCase(name)} extends PolymerElement with PolymerAppRouteBehavior { "
      "${toCamelCase(name)}.created() : super.created();\n\n"
      "/// Called when an instance of ${toLispCase(name)} is inserted into the DOM.\n"
      "attached() {"
      "}\n\n"
      "/// Called when an instance of ${toLispCase(name)} is removed from the DOM.\n"
      "detached() {"
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