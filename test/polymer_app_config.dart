/**
 * Created by lejard_h on 05/01/16.
 */

import "package:test/test.dart";
import "dart:io";
import "../bin/polymer_app.dart" as polymer_app;
import "package:cupid/cupid.dart";
import "package:polymer_app/serializer.dart";
import "package:polymer_app/polymer_app_manager.dart";
import "package:polymer_app/polymer_app_services.dart";
import "package:polymer_app/polymer_app_models.dart";
import "package:polymer_app/polymer_app_behaviors.dart";
import "package:polymer_app/polymer_app_elements.dart";
import "package:polymer_app/polymer_app_routes.dart";
import "dart:async";

main(_, __) {
  test("create config", () {
    Program prog = new polymer_app.PolymerApp();
    cupid(
        prog,
        [
          "new_config",
          "--name=test_app",
          "--configOutputFolderPath=./test/test_app"
        ],
        __);

    new Timer(new Duration(seconds: 2), () {
      File config = new File("./test/test_app/polymer_app.json");

      expect(true, config.existsSync());
      Map _config = Serializer.fromJson(config.readAsStringSync(), Map);


      prog.exit();
    });
  });
}
