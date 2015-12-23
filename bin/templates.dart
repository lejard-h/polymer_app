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
    '\t\t<polymer-app></polymer-app>\n'
    '\t\t<script type="application/dart" src="index.dart"></script>\n'
    '\t\t<script src="packages/browser/dart.js"></script>\n'
    '\t</body>\n'
    '</html>\n';

indexDartContent(String appName) => "import 'package:$appName/$appName.dart';\n\n"
    "main() async {\n"
    "\tawait initPolymer();\n"
    "}\n";

appLibraryContent(String appName) => "library $appName;\n\n"
    "export 'package:polymer/polymer.dart';\n\n"
    "export 'elements/elements.dart';\n"
    "export 'behaviors/behaviors.dart';\n"
    "export 'models/models.dart';\n"
    "export 'services/services.dart';\n";

pubspecContent(String appName) => "name: $appName\n"
    "#description:\n"
    "version: 0.0.1\n"
    "#author:\n"
    "#homepage:\n\n"
    "environment:\n"
    "   sdk: '>=1.13.0 <2.0.0'\n\n"
    "dependencies:\n"
    '   polymer: "^1.0.0-rc.10"\n'
    '   polymer_app_router: "^0.0.3"\n'
    '   dart_to_js_script_rewriter: "^0.1.0+4"\n'
    '   web_components: "^0.12.0"\n'
    '   browser: "^0.10.0"\n'
    '   reflectable: "^0.5.1"\n\n'
    'transformers:\n'
    '   - web_components:\n'
    '     entry_points:\n'
    '       - example/index.html\n'
    '   - reflectable:\n'
    '     entry_points:\n'
    '       - example/index.dart\n'
    '   - \$dart2js:\n'
    '     minify: true\n'
    "     commandLineOptions: ['--trust-type-annotations', '--trust-primitives', '--enable-experimental-mirrors']\n"
    '   - dart_to_js_script_rewriter\n';

modelsLibContent(String appName) => "library $appName.models;\n\n"
    "// export 'model.dart';";

elementsLibContent(String appName) => "library $appName.elements;\n\n"
    "// export 'element.dart';";

behaviorsLibContent(String appName) => "library $appName.behaviors;\n\n"
    "// export 'behavior.dart';";

servicesLibContent(String appName) => "library $appName.services;\n\n"
    "// export 'service.dart';";
