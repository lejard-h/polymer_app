/**
 * Created by lejard_h on 05/01/16.
 */

import "package:test/test.dart";
import "dart:io";
import "../bin/polymer_app.dart";
import "package:polymer_app/serializer.dart";

main() {
  group("Config", () {
    test("generate", () async {
      PolymerApp prog = new PolymerApp();
      File config = await prog.new_config(
          name: "test_app", configOutputFolderPath: "./test/test_app");

      expect(true, config.existsSync());

      Map _config = Serializer.fromJson(config.readAsStringSync(), Map);

      expect("test_app", _config["name"]);

      config.parent.delete(recursive: true);
    });
  });

}
