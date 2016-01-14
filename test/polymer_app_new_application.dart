/**
 * Created by lejard_h on 05/01/16.
 */

import "package:test/test.dart";
import "dart:io";
import "../bin/polymer_app.dart";

main() {
  PolymerApp app = new PolymerApp();

  setUpAll(() async {
    print("Generating all test");
    await app.app("test_app",
        output_folder: "./test/test_app", material_layout: "nav-view");
    await app.element("test-element", output_folder: "./test/test_app");
    await app.service("test", output_folder: "./test/test_app");
    await app.model("test", output_folder: "./test/test_app");
    await app.route("test", "test", output_folder: "./test/test_app");
    await app.behavior("test", output_folder: "./test/test_app");
  });

  tearDownAll(() {
    /* Directory dir = new Directory("./test/test_app");
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }*/
  });

  test("application", () {
    File lib = new File("./test/test_app/lib/test_app.dart");
    Directory dir = new Directory("./test/test_app");
    Directory dirlib = new Directory("./test/test_app/lib");
    Directory dirweb = new Directory("./test/test_app/web");
    Directory direlements = new Directory("./test/test_app/lib/elements");
    Directory dirroutes = new Directory("./test/test_app/lib/routes");
    Directory dirbehaviors = new Directory("./test/test_app/lib/behaviors");
    Directory dirmodels = new Directory("./test/test_app/lib/models");
    Directory dirservice = new Directory("./test/test_app/lib/models");
    Directory dirhomeroute =
        new Directory("./test/test_app/lib/routes/home_route");
    Directory dirrootelem =
        new Directory("./test/test_app/lib/elements/root_element");

    expect(true, lib.existsSync());
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

  test("element", () {

    File dart = new File("./test/test_app/lib/elements/test_element/test_element.dart");
    File html = new File("./test/test_app/lib/elements/test_element/test_element.html");
    File css = new File("./test/test_app/lib/elements/test_element/test_element.css");

    expect(true, dart.existsSync());
    expect(true, css.existsSync());
    expect(true, html.existsSync());
  });

  test("route", () {

    File dart = new File("./test/test_app/lib/routes/test_route/test_route.dart");
    File css = new File("./test/test_app/lib/routes/test_route/test_route.css");
    File html = new File("./test/test_app/lib/routes/test_route/test_route.html");

    expect(true, dart.existsSync());
    expect(true, css.existsSync());
    expect(true, html.existsSync());
  });

  test("model", () {

    File dart = new File("./test/test_app/lib/models/test_model.dart");

    expect(true, dart.existsSync());
  });

  test("behavior", () {

    File dart = new File("./test/test_app/lib/behaviors/test_behavior.dart");

    expect(true, dart.existsSync());
  });

  test("service", () {

    File dart = new File("./test/test_app/lib/services/test_service.dart");

    expect(true, dart.existsSync());
  });
}
