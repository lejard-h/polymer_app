/**
 * Created by lejard_h on 05/01/16.
 */

import "package:test/test.dart";
import 'package:polymer_app/polymer_app_cli.dart';
import 'dart:io';

main() {
  group("utils", () {
    String testA = "foo-bar";
    String testB = "foo_bar";
    String testC = "foo bar";
    String testD = "fooBar";

    test("toSnakeCase", () {
      expect("foo_bar", toSnakeCase(testA));
      expect("foo_bar", toSnakeCase(testB));
      expect("foo_bar", toSnakeCase(testC));
      expect("foobar", toSnakeCase(testD));
    });

    test("toLispCase", () {
      expect("foo-bar", toLispCase(testA));
      expect("foo-bar", toLispCase(testB));
      expect("foo-bar", toLispCase(testC));
      expect("foobar", toLispCase(testD));
    });

    test("toCamelCase", () {
      expect("FooBar", toCamelCase(testA));
      expect("FooBar", toCamelCase(testB));
      expect("FooBar", toCamelCase(testC));
      expect("Foobar", toCamelCase(testD));
    });

    test('createDirectory', () async  {
      Directory dir = await createDirectory("./test_dir");
      expect(true, dir.existsSync());

      dir.deleteSync();
      expect(false, dir.existsSync());
    });

    test('createFile', () async {
      File file = await createFile("./test/test_file");
      expect(true, file.existsSync());

      file.deleteSync();
      expect(false, file.existsSync());
    });

    test('writeInFile', () async {
      File file = await writeInFile("./test/test_file", "test_file");

      expect(true, file.existsSync());
      expect("test_file", file.readAsStringSync());
      file.deleteSync();
      expect(false, file.existsSync());
    });

    test('writeInDartFile', () async  {
        File file = await writeInDartFile("./test/test_file.dart", "library test_file;");

        expect(true, file.existsSync());
        expect("library test_file;\n", file.readAsStringSync());
        file.deleteSync();
        expect(false, file.existsSync());
    });
  });
}
