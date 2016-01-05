/**
 * Created by lejard_h on 05/01/16.
 */

import "package:test/test.dart";
import 'package:polymer_app/utils.dart';

main() {
    group("polymer_app utils", () {
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

    });
}