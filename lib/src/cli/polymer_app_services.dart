/**
 * Created by lejard_h on 24/12/15.
 */

part of polymer_app.cli;

class ServicesManager extends Manager {
  ServicesManager(String appName, String libraryPath)
      : super(appName, libraryPath, "services");

  createService(String name, [String content]) async {
    name = "$name-service";
    if (content == null) {
      content = serviceDartTemplate(name);
    }
    await writeInDartFile(
        "$libraryPath/${toSnakeCase(name)}.dart", content);
  }

  String get libraryTemplate => "library ${toSnakeCase(appName)}.services;"
      "// export 'service.dart';";

  serviceDartTemplate(String name) =>
      'library ${toSnakeCase(appName)}.services.${toSnakeCase(name)};'
      "import 'package:polymer_app/polymer_app.dart';\n"
      '@serializable\n'
      "class ${toCamelCase(name)} extends PolymerModel {"
      "HttpService http = http_service;"
      '@reflectable\n'
      'String foo = "bar";'
      "}"
  "${toCamelCase(name)} ${toSnakeCase(name)} = new ${toCamelCase(name)}();";
}
