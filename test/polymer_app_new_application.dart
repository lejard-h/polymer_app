/**
 * Created by lejard_h on 05/01/16.
 */

import "package:test/test.dart";
import "dart:io";
import "../bin/polymer_app.dart";
import "package:polymer_app/polymer_app_manager.dart";

main() {
  PolymerApp prog = new PolymerApp();

  group("Application", () {
    setUpAll(() async {
      await prog.new_application(
          name: "test_app", outputFolderPath: "./test/test_app");
    });

    tearDownAll(() {
      prog.exit();
      Directory dir = new Directory("./test/test_app");
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
    });

    test("generate", () async {
      expect("test_app", prog.manager.name);
      expect("lib", prog.manager.libraryPath);

      Directory dir = new Directory("./test/test_app");
      Directory dirlib = new Directory("./test/test_app/lib");
      Directory dirweb = new Directory("./test/test_app/web");
      Directory direlements = new Directory("./test/test_app/lib/elements");
      Directory dirroutes = new Directory("./test/test_app/lib/routes");
      Directory dirbehaviors = new Directory("./test/test_app/lib/behaviors");
      Directory dirmodels = new Directory("./test/test_app/lib/models");
      Directory dirservice = new Directory("./test/test_app/lib/models");
      Directory dirhomeroute= new Directory("./test/test_app/lib/routes/home_route");
      Directory dirrootelem = new Directory("./test/test_app/lib/elements/root_element");


      expect(true, dir.existsSync());
      expect(true, dirlib.existsSync());
      expect(true, dirweb.existsSync());
      expect(true, direlements.existsSync());
      expect(true, dirrootelem.existsSync());
      expect(true, dirroutes.existsSync());
      expect(true, dirbehaviors.existsSync());
      expect(true, dirservice.existsSync());
      expect(true, dirmodels.existsSync());
      expect(true, dirhomeroute.existsSync());

    });

/*    test("serve", () async {
      Process serve = await prog.serve();
      Completer completer = new Completer();
      Timer timer =
          new Timer(const Duration(seconds: 5), () => completer.complete());
      await completer.future;
      serve?.kill();
      int code = await serve?.exitCode;
      print(code);
      expect(-15, code);
    });*/
  });
}
