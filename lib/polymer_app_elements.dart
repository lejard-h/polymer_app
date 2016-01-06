/**
 * Created by lejard_h on 24/12/15.
 */

library polymer_app.elements;

import "polymer_app_manager.dart";
import "utils.dart";

class ElementsManager extends Manager {
  ElementsManager(String appName, String libraryPath)
      : super(appName, libraryPath, "elements");

  createElement(String name,
      [String dartContent,
      String htmlContent,
      String cssContent,
      String innerHtmlContent = ""]) {
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
        "$libraryPath/${toSnakeCase(name)}/${toSnakeCase(name)}.dart",
        dartContent);
    writeInFile("$libraryPath/${toSnakeCase(name)}/${toSnakeCase(name)}.html",
        htmlContent);
    writeInFile("$libraryPath/${toSnakeCase(name)}/${toSnakeCase(name)}.css",
        cssContent);
  }

  addToLibrary(String name, [String path = "."]) {
    super.addToLibrary(name, name);
  }

  String get libraryTemplate => "library ${toSnakeCase(appName)}.elements;\n"
      "//export 'element/element.dart';";

  elementDartTemplate(String name) => "@HtmlImport('${toSnakeCase(name)}.html')"
      "library ${toSnakeCase(appName)}.elements.${toSnakeCase(name)};"
      "import 'package:polymer/polymer.dart';"
      "import 'package:web_components/web_components.dart' show HtmlImport;"
      "@PolymerRegister('${toLispCase(name)}')"
      "class ${toCamelCase(name)} extends PolymerElement {"
      "${toCamelCase(name)}.created() : super.created();\n\n"
      "/// Called when an instance of ${toLispCase(name)} is inserted into the DOM.\n"
      "attached() {"
      "super.attached();"
      "}\n\n"
      "/// Called when an instance of ${toLispCase(name)} is removed from the DOM.\n"
      "detached() { "
      "super.detached();"
      "}\n\n"
      "/// Called when an attribute (such as  a class) of an instance of ${toLispCase(name)} is added, changed, or removed.\n"
      "attributeChanged(String name, String oldValue, String newValue) {"
      "}\n\n"
      "/// Called when ${toLispCase(name)} has been fully prepared (Shadow DOM created, property observers set up, event listeners attached).\n"
      "ready() {"
      "}\n\n"
      "}";

  elementHtmlTemplate(String name, [String innerContent = ""]) =>
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
