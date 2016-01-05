/**
 * Created by lejard_h on 05/01/16.
 */

import "package:test/test.dart";
import 'package:polymer_app/utils.dart';
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

    test('createDirectory', () {
      Directory dir = createDirectory("./test_dir");
      expect(true, dir.existsSync());

      dir.deleteSync();
      expect(false, dir.existsSync());
    });

    test('createFile', () {
      File file = createFile("./test_file");
      expect(true, file.existsSync());

      file.deleteSync();
      expect(false, file.existsSync());
    });

    test('writeInFile', () {
      File file = writeInFile("./test_file", "test_file");

      expect(true, file.existsSync());
      expect("test_file", file.readAsStringSync());
      file.deleteSync();
      expect(false, file.existsSync());
    });

    test('writeInDartFile', () {
        File file = writeInDartFile("./test_file.dart", "library test_file;");

        expect(true, file.existsSync());
        expect("library test_file;\n", file.readAsStringSync());
        file.deleteSync();
        expect(false, file.existsSync());
    });
  });
}
