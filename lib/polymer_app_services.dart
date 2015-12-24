/**
 * Created by lejard_h on 24/12/15.
 */

library polymer_app.services;

import "polymer_app_manager.dart";
import "utils.dart";
import "dart:io";

class ServicesManager extends JsonObject {
  String rootPath;
  String appName;

  String get completePath => "$rootPath/$path";

  String get path => get("directory");
  List get services => get("list");

  ServicesManager.fromMap(Map config) : super.fromMap(config);
  ServicesManager.fromJson(String json) : super.fromJson(json);

  addToLibrary(String name) {
    File services = new File("$completePath/services.dart");
    services.writeAsString(services.readAsStringSync() +
        "\n" +
        "export '${toSnakeCase(name)}/${toSnakeCase(name)}.dart';\n");
  }

  createService(String name, [String content]) {
    if (content == null) {
      content = serviceDartTemplate(name);
    }
    createDartFile("$completePath/${toSnakeCase(name)}/${toSnakeCase(name)}.dart", content);
    addToLibrary(name);
  }

  serviceDartTemplate(String name) => 'library ${toSnakeCase(appName)}.services.${toSnakeCase(name)};'
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
          "}";
}
