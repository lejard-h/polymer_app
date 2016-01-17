/**
 * Created by lejard_h on 14/01/16.
 */

library polymer_app;

import "dart:async";
import "dart:convert";
import "dart:html";

import 'package:http/http.dart';
import "package:http/browser_client.dart";
import "package:polymer/polymer.dart";
import "package:reflectable/reflectable.dart";
import "package:initialize/initialize.dart" as init;
import "package:route_hierarchical/client.dart";
import "package:polymer_app_router/polymer_app_router.dart";
import "src/serializer.dart";
import "src/utils.dart";
import "package:observe/observe.dart";
import "package:polymer_autonotify/polymer_autonotify.dart";

export 'package:polymer/polymer.dart';
export "package:polymer_app_router/polymer_app_router.dart";
export "package:route_hierarchical/client.dart";
export "src/serializer.dart";
export "src/utils.dart";
export "package:observe/observe.dart";
export "package:polymer_autonotify/polymer_autonotify.dart";

part "src/polymer_model.dart";
part "src/polymer_router.dart";
part "src/polymer_services.dart";

part "src/http_service.dart";

initPolymerApp() async {
  await initSerializer();
  await initServices();
  await initPolymer();
}
