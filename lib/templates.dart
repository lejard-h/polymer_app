library polymer_app.templates;

import 'package:polymer_app/utils.dart';
import "package:dart_style/dart_style.dart";

DartFormatter _formatter = new DartFormatter();

indexDartContent(String appName) =>
    _formatter.format("import 'package:polymer/polymer.dart';"
        "import 'package:${toSnakeCase(appName)}/${toSnakeCase(appName)}.dart';"
        "main() async {"
        "await initPolymer();"
        "}");

appLibraryContent(String appName) =>
    _formatter.format("library ${toSnakeCase(appName)};"
        "export 'elements/elements.dart';"
        "export 'behaviors/behaviors.dart';"
        "export 'models/models.dart';"
        "export 'services/services.dart';");

modelsLibContent(String appName) =>
    _formatter.format("library ${toSnakeCase(appName)}.models;"
        "// export 'model.dart';");

elementsLibContent(String appName) =>
    _formatter.format("library ${toSnakeCase(appName)}.elements;"
        "export 'root_element/root_element.dart';");

behaviorsLibContent(String appName) =>
    _formatter.format("library ${toSnakeCase(appName)}.behaviors;"
        "// export 'behavior.dart';");

servicesLibContent(String appName) =>
    _formatter.format("library ${toSnakeCase(appName)}.services;"
        "// export 'service.dart';");

rootElementDartContent(String appName) => _formatter.format(
    '@HtmlImport("root_element.html")'
    "library $appName.elements.root_element;"
    'import "package:polymer/polymer.dart";'
    'import "dart:html";'
    'import "package:web_components/web_components.dart" show HtmlImport;'
    'import "package:polymer_app_router/polymer_app_router.dart" show PolymerRouter;'
    '@PolymerRegister("root-element")'
    'class RootElement extends PolymerElement {'
    'RootElement.created() : super.created();'
    'String _selected;'
    '@Property()'
    'String get selected => _selected;'
    'set selected(String value) {'
    '_selected = value;'
    'notifyPath("selected", value);'
    '}'
    '@reflectable'
    'void goTo(event, [_]) {'
    'HtmlElement elem = event.target;'
    'PolymerRouter.goToName(elem.text);'
    '}'
    '@reflectable'
    'void goToDefault(event, [_]) {'
    'PolymerRouter.goToDefault();'
    '}'
    '}');

polymerElementDartContent(String name, String appName) => _formatter.format(
    "@HtmlImport('${toSnakeCase(name)}.html')"
    "library $appName.elements.${toSnakeCase(name)};"
    "import 'package:polymer/polymer.dart';"
    "import 'package:web_components/web_components.dart' show HtmlImport;"
    "@PolymerRegister('${toLispCase(name)}')"
    "class ${toCamelCase(name)} extends PolymerElement {"
    "${toCamelCase(name)}.created() : super.created();"
    "/*"
    "* Optional lifecycle methods - uncomment if needed."
    "/// Called when an instance of ${toLispCase(name)} is inserted into the DOM."
    "attached() {"
    "super.attached();"
    "}"
    "/// Called when an instance of ${toLispCase(name)} is removed from the DOM."
    "detached() {"
    "super.detached();"
    "}"
    "/// Called when an attribute (such as  a class) of an instance of ${toLispCase(name)} is added, changed, or removed."
    "attributeChanged(String name, String oldValue, String newValue) {"
    "}"
    "/// Called when ${toLispCase(name)} has been fully prepared (Shadow DOM created, property observers set up, event listeners attached)."
    "ready() {"
    "}"
    "*/"
    "}");

polymerBehaviorContent(String name, String appName) => _formatter.format(
    'library ${toSnakeCase(appName)}.elements.${toSnakeCase(name)};'
    'import "package:polymer/polymer.dart";'
    '@behavior'
    'abstract class ${toCamelCase(name)} {'
    "/*"
    "* Optional lifecycle methods - uncomment if needed."
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
    "*/"
    '}');

factoryContent(String name, String appName) => _formatter
    .format('library ${toSnakeCase(appName)}.services.${toSnakeCase(name)};'
        "import 'package:polymer_app/http_service.dart';"
        "class ${toCamelCase(name)} {"
        "static ${toCamelCase(name)} _cache;"
        "HttpService http = new HttpService();"
        "factory ${toCamelCase(name)}() {"
        "if (_cache == null) {"
        "_cache = new ${toCamelCase(name)}._internal();"
        "}"
        "return _cache;"
        "}"
        "${toCamelCase(name)}._internal();"
        "}");

modelContent(String name, String appName) => _formatter
    .format('library ${toSnakeCase(appName)}.services.${toSnakeCase(name)};'
        'import "package:polymer_app/polymer_model.dart";'
        'class ${toCamelCase(name)} extends PolymerModel {'
        '@reflectable '
        'String foo;'
        '${toCamelCase(name)}(this.foo);'
        '_fromJson(Map json) {'
        'this.foo = json["json"];'
        '}'
        'Map get toMap => {"foo": foo};'
        '}');

indexHtmlContent(String appName) => "<!DOCTYPE html>\n"
    "<html>\n"
    "\t<head>\n"
    '\t\t<meta charset="utf-8">\n'
    '\t\t<meta name="viewport" content="width=device-width, minimum-scale=1.0, initial-scale=1.0, user-scalable=yes">\n'
    '\t\t<title>$appName</title>\n'
    '\t\t<script src="packages/web_components/webcomponents-lite.min.js"></script>\n'
    '\t\t<script src="packages/web_components/dart_support.js"></script>\n'
    '\t</head>\n'
    '\t<body unresolved class="fullbleed layout vertical">\n'
    '\t\t<root-element></root-element>\n'
    '\t\t<script type="application/dart" src="index.dart"></script>\n'
    '\t\t<script src="packages/browser/dart.js"></script>\n'
    '\t</body>\n'
    '</html>\n';

rootElementHtmlContent() => polymerElementHtmlContent("root-element", "");

polymerElementHtmlContent(String name, [String content = ""]) =>
    '<dom-module id="${toLispCase(name)}">\n'
    '\t<template>\n'
    '\t\t<link rel="import" type="css" href="${toSnakeCase(name)}.css">\n'
    '\t\t<!-- local DOM for your element -->\n'
    '\t\t$content\n'
    '\t</template>\n'
    '</dom-module>\n';

polymerElementCssContent() => ":host {\n"
    "\tfont-family: 'Roboto', 'Noto', sans-serif;\n"
    "\tfont-weight: 300;\n"
    "\tdisplay: block;\n"
    "\t}";
pubspecContent(String appName) => "name: ${toSnakeCase(appName)}\n"
    "#description:\n"
    "version: 0.0.1\n"
    "#author:\n"
    "#homepage:\n\n"
    "environment:\n"
    "  sdk: '>=1.13.0 <2.0.0'\n\n"
    "dependencies:\n"
    '  polymer: "^1.0.0-rc.10"\n'
    '  polymer_app_router: "^0.0.3"\n'
    '  dart_to_js_script_rewriter: "^0.1.0+4"\n'
    '  web_components: "^0.12.0"\n'
    '  browser: "^0.10.0"\n'
    '  reflectable: "^0.5.1"\n\n'
    'transformers:\n'
    '  - web_components:\n'
    '      entry_points:\n'
    '      - web/index.html\n'
    '  - reflectable:\n'
    '      entry_points:\n'
    '      - web/index.dart\n'
    '  - \$dart2js:\n'
    '      minify: true\n'
    "      commandLineOptions: ['--trust-type-annotations', '--trust-primitives', '--enable-experimental-mirrors']\n"
    '  - dart_to_js_script_rewriter\n';
