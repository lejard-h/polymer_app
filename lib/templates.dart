import 'package:polymer_app/utils.dart';

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

indexDartContent(String appName) => "import 'package:polymer/polymer.dart';\n"
    "import 'package:${toSnakeCase(appName)}/${toSnakeCase(appName)}.dart';\n\n"
    "main() async {\n"
    "\tawait initPolymer();\n"
    "}\n";

appLibraryContent(String appName) => "library ${toSnakeCase(appName)};\n\n"
    "export 'elements/elements.dart';\n"
    "export 'behaviors/behaviors.dart';\n"
    "export 'models/models.dart';\n"
    "export 'services/services.dart';\n";

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

modelsLibContent(String appName) =>
    "library ${toSnakeCase(appName)}.models;\n\n"
    "// export 'model.dart';";

elementsLibContent(String appName) =>
    "library ${toSnakeCase(appName)}.elements;\n\n"
    "export 'root_element/root_element.dart';";

behaviorsLibContent(String appName) =>
    "library ${toSnakeCase(appName)}.behaviors;\n\n"
    "// export 'behavior.dart';";

servicesLibContent(String appName) =>
    "library ${toSnakeCase(appName)}.services;\n\n"
    "// export 'service.dart';";

rootElementHtmlContent() => polymerElementHtmlContent("root-element", "");

rootElementDartContent(String appName) => '@HtmlImport("root_element.html")\n\n'
    "library $appName.elements.root_element;\n\n"
    'import "package:polymer/polymer.dart";\n'
    'import "dart:html";\n'
    'import "package:web_components/web_components.dart" show HtmlImport;\n'
    'import "package:polymer_app_router/polymer_app_router.dart" show PolymerRouter;\n\n'
    '@PolymerRegister("root-element")\n'
    'class RootElement extends PolymerElement {\n'
    '\tRootElement.created() : super.created();\n\n'
    '\tString _selected;\n\n'
    '\t@Property()\n'
    '\tString get selected => _selected;\n'
    '\tset selected(String value) {\n'
    '\t\t_selected = value;\n'
    '\t\tnotifyPath("selected", value);\n'
    '\t}\n'
    '\t@reflectable\n'
    '\tvoid goTo(event, [_]) {\n'
    '\t\tHtmlElement elem = event.target;\n'
    '\t\tPolymerRouter.goToName(elem.text);\n'
    '\t}\n'
    '\t@reflectable\n'
    '\tvoid goToDefault(event, [_]) {\n'
    '\t\tPolymerRouter.goToDefault();\n'
    '\t}\n'
    '}';

polymerElementDartContent(String name, String appName) =>
    "@HtmlImport('${toSnakeCase(name)}.html')\n"
    "library $appName.elements.${toSnakeCase(name)};\n\n"
    "import 'package:polymer/polymer.dart';\n"
    "import 'package:web_components/web_components.dart' show HtmlImport;\n\n"
    "@PolymerRegister('${toLispCase(name)}')\n"
    "class ${toCamelCase(name)} extends PolymerElement {\n"
    "\t${toCamelCase(name)}.created() : super.created();\n\n"
    "\t/*\n"
    "\t* Optional lifecycle methods - uncomment if needed.\n\n"
    "\t/// Called when an instance of ${toLispCase(name)} is inserted into the DOM.\n"
    "\tattached() {\n"
    "\t\tsuper.attached();\n"
    "\t}\n\n"
    "\t/// Called when an instance of ${toLispCase(name)} is removed from the DOM.\n"
    "\tdetached() {\n"
    "\t\tsuper.detached();\n"
    "\t}\n\n"
    "\t/// Called when an attribute (such as  a class) of an instance of ${toLispCase(name)} is added, changed, or removed.\n"
    "\tattributeChanged(String name, String oldValue, String newValue) {\n"
    "\t}\n\n"
    "\t/// Called when ${toLispCase(name)} has been fully prepared (Shadow DOM created, property observers set up, event listeners attached).\n"
    "\tready() {\n"
    "\t}\n\n"
    "\t*/\n"
    "}";

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

polymerBehaviorContent(String name, String appName) =>
    'import "package:polymer/polymer.dart";\n'
    'library $appName.elements.${toSnakeCase(name)};\n\n'
    '@behavior\n'
    'abstract class ${toCamelCase(name)} {\n'
    "\t/*\n"
    "\t* Optional lifecycle methods - uncomment if needed.\n\n"
    "\t/// Called when an instance of ${toCamelCase(name)} is inserted into the DOM.\n"
    "\tattached() {\n"
    "\t\tsuper.attached();\n"
    "\t}\n\n"
    "\t/// Called when an instance of ${toCamelCase(name)} is removed from the DOM.\n"
    "\tdetached() {\n"
    "\t\tsuper.detached();\n"
    "\t}\n\n"
    "\t/// Called when an attribute (such as  a class) of an instance of ${toCamelCase(name)} is added, changed, or removed.\n"
    "\tattributeChanged(String name, String oldValue, String newValue) {\n"
    "\t}\n\n"
    "\t/// Called when ${toCamelCase(name)} has been fully prepared (Shadow DOM created, property observers set up, event listeners attached).\n"
    "\tready() {\n"
    "\t}\n\n"
    "\t*/\n"
    '}\n';
