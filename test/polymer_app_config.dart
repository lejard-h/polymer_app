/**
 * Created by lejard_h on 05/01/16.
 */

import "package:test/test.dart";
import "dart:io";
import "../bin/polymer_app.dart";
import "package:cupid/cupid.dart";
import "package:polymer_app/serializer.dart";
import "package:polymer_app/polymer_app_manager.dart";
import "package:polymer_app/polymer_app_services.dart";
import "package:polymer_app/polymer_app_models.dart";
import "package:polymer_app/polymer_app_behaviors.dart";
import "package:polymer_app/polymer_app_elements.dart";
import "package:polymer_app/polymer_app_routes.dart";
import "dart:async";

main([_, __]) {
  test("create config", () async {
    PolymerApp prog = new PolymerApp();
    File config = await prog.new_config(
        name: "test_app", configOutputFolderPath: "./test/test_app");

    expect(true, config.existsSync());

    Map _config = Serializer.fromJson(config.readAsStringSync(), Map);

    expect("test_app", _config["name"]);

    config.parent.delete(recursive: true);
  });
}
