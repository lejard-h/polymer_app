/**
 * Created by lejard_h on 24/12/15.
 */

library polymer_app.services;

import "polymer_app_manager.dart";
import "utils.dart";

class ServicesManager extends Manager {
  ServicesManager(String appName, String libraryPath)
      : super(appName, libraryPath, "services");

  createService(String name, [String content]) {
    name = "$name-service";
    if (content == null) {
      content = serviceDartTemplate(name);
    }
    writeInDartFile(
        "$libraryPath/${toSnakeCase(name)}.dart", content);
  }

  String get libraryTemplate => "library ${toSnakeCase(appName)}.services;"
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
