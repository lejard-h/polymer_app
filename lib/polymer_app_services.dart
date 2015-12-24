/**
 * Created by lejard_h on 24/12/15.
 */

library polymer_app.services;

import "polymer_app_manager.dart";
import "utils.dart";
import "dart:io";

class ServicesManager extends Manager {
  ServicesManager.fromMap(Map config, String rootPath, String appName) : super.fromMap(config, rootPath, appName);
  ServicesManager.fromJson(String json, String rootPath, String appName) : super.fromJson(json, rootPath,appName);

  addToLibrary(String name) {
    File services = new File("$completePath/services.dart");
    services.writeAsString(services.readAsStringSync() +
        "\n" +
        "export '${toSnakeCase(name)}/${toSnakeCase(name)}.dart';\n");
  }

  createLibraryDirectory() {
    super.createLibraryDirectory();
    writeInDartFile("$completePath/services.dart", servicesLibTemplate());
  }

  createService(String name, [String content]) {
    if (content == null) {
      content = serviceDartTemplate(name);
    }
    writeInDartFile(
        "$completePath/${toSnakeCase(name)}/${toSnakeCase(name)}.dart",
        content);
    addToLibrary(name);
  }

  servicesLibTemplate() =>
      "library ${toSnakeCase(appName)}.services;"
      "// export 'service.dart';";

  serviceDartTemplate(String name) =>
      'library ${toSnakeCase(appName)}.services.${toSnakeCase(name)};'
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
