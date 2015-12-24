/**
 * Created by lejard_h on 24/12/15.
 */

library polymer_app.elements;

import "polymer_app_manager.dart";
import "utils.dart";
import "dart:io";

class ElementsManager extends JsonObject {
  String rootPath;
  String appName;

  String get completePath => "$rootPath/$path";

  String get path => get("directory");
  List get models => get("list");
  ElementsManager.fromMap(Map config) : super.fromMap(config);
  ElementsManager.fromJson(String json) : super.fromJson(json);

  addToLibrary(String name) {
    File services = new File("$completePath/elements.dart");
    services.writeAsString(services.readAsStringSync() +
        "\n" +
        "export '${toSnakeCase(name)}/${toSnakeCase(name)}.dart';\n");
  }

  createElement(String name,
      [String dartContent,
      String htmlContent,
      String cssContent,
      String innerHtmlContent]) {
    if (dartContent == null) {
      dartContent = elementDartTemplate(name);
    }
    if (htmlContent == null) {
      htmlContent = elementHtmlTemplate(name, innerHtmlContent);
    }
    if (cssContent == null) {
      cssContent = elementCssTemplate(name);
    }
    writeInDartFile(
        "$completePath/${toSnakeCase(name)}/${toSnakeCase(name)}.dart",
        dartContent);
    writeInFile("$completePath/${toSnakeCase(name)}/${toSnakeCase(name)}.html",
        htmlContent);
    writeInFile("$completePath/${toSnakeCase(name)}/${toSnakeCase(name)}.css",
        cssContent);
    addToLibrary(name);
  }

  elementDartTemplate(String name) => "@HtmlImport('${toSnakeCase(name)}.html')"
      "library $appName.elements.${toSnakeCase(name)};"
      "import 'package:polymer/polymer.dart';"
      "import 'package:web_components/web_components.dart' show HtmlImport;"
      "@PolymerRegister('${toLispCase(name)}')"
      "class ${toCamelCase(name)} extends PolymerElement {"
      "${toCamelCase(name)}.created() : super.created();"
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
      "}";

  elementHtmlTemplate(String name, String innerContent) =>
      '<dom-module id="${toLispCase(name)}">\n'
      '\t<link rel="import" type="css" href="${toSnakeCase(name)}.css">\n'
      '\t<template>\n'
      '\t\t<!-- local DOM for your element -->\n'
      '\t\t$innerContent\n'
      '\t</template>\n'
      '</dom-module>\n';

  elementCssTemplate(String name) => ":host {\n"
      "\tfont-family: 'Roboto', 'Noto', sans-serif;\n"
      "\tfont-weight: 300;\n"
      "\tdisplay: block;\n"
      "\t}";
}
