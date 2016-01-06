/**
 * Created by lejard_h on 04/01/16.
 */

import "package:test/test.dart";
import "dart:convert";
import "package:polymer_app/serializer.dart";

@serializable
abstract class Proxy {}

abstract class ProxyA extends Proxy with Serialize {}

@serializable
class ModelA extends ProxyA {
  String foo;

  ModelA([this.foo = "bar"]);
}

class Test {
  String toto = "tata";
}

@serializable
class ModelB extends ProxyA {
  Test foo = new Test();
  String toto = "tata";
}

@serializable
class ModelC extends ProxyA {
  ModelA foo = new ModelA();
  String plop = "titi";
}

@serializable
class ModelD extends ProxyA {
  List tests;

  ModelD([this.tests]);
}

@serializable
class Date extends ProxyA {
  DateTime date = new DateTime.now();

  Date([this.date]);
}

main() {
  initSerializer();
  group("Serialize", () {
    test("simple test", () {
      ModelA a = new ModelA("toto");

      expect("{@dart_type: ModelA, foo: toto}", a.toString());
      expect('{"@dart_type":"ModelA","foo":"toto"}', a.toJson());
      expect({"@dart_type": "ModelA", "foo": "toto"}, a.toMap);
    });

    test("Map to Map", () {
      Map a = {"test": "toto", "titi": new ModelA()};
      String json = Serializer.toJson(a);
      expect('{"test":"toto","titi":"{\\"@dart_type\\":\\"ModelA\\",\\"foo\\":\\"bar\\"}","@dart_type":"_InternalLinkedHashMap"}', json);
    });

    test("list", () {
      List<ModelA> list = [new ModelA("toto"), new ModelA()];

      String json = Serializer.toJson(list);
      expect(
          '["{\\"@dart_type\\":\\"ModelA\\",\\"foo\\":\\"toto\\"}","{\\"@dart_type\\":\\"ModelA\\",\\"foo\\":\\"bar\\"}"]',
          json);
    });

    test("inner list", () {
      List<ModelA> list = [new ModelA("toto"), new ModelA()];
      ModelD test = new ModelD(list);
      String json = test.toJson();

      expect(
          '{"@dart_type":"ModelD","tests":["{\\"@dart_type\\":\\"ModelA\\",\\"foo\\":\\"toto\\"}","{\\"@dart_type\\":\\"ModelA\\",\\"foo\\":\\"bar\\"}"]}',
          json);
    });

    test("inner class non-serializable", () {
      ModelB b = new ModelB();
      expect('{"@dart_type":"ModelB","toto":"tata"}', b.toJson());
      expect({"@dart_type": "ModelB", "toto": "tata"}, b.toMap);
    });

    test("inner class serializable", () {
      ModelC c = new ModelC();
      expect(
          '{"@dart_type":"ModelC","foo":{"@dart_type":"ModelA","foo":"bar"},"plop":"titi"}',
          c.toJson());
      expect({
        "@dart_type": "ModelC",
        "foo": {"@dart_type": "ModelA", "foo": "bar"},
        "plop": "titi"
      }, c.toMap);
    });

    test("list class non-serializable", () {
      List list = [new ModelB(), new ModelB()];
      String json = Serializer.toJson(list);
      expect(
          '["{\\"@dart_type\\":\\"ModelB\\",\\"toto\\":\\"tata\\"}","{\\"@dart_type\\":\\"ModelB\\",\\"toto\\":\\"tata\\"}"]',
          json);
    });

    test("list inner list", () {
      List listA = [new ModelB(), new ModelB()];
      List listB = [new ModelB(), listA];
      String json = Serializer.toJson(listB);
      print(json);
      expect(
          '["{\\"@dart_type\\":\\"ModelB\\",\\"toto\\":\\"tata\\"}",["{\\"@dart_type\\":\\"ModelB\\",\\"toto\\":\\"tata\\"}","{\\"@dart_type\\":\\"ModelB\\",\\"toto\\":\\"tata\\"}"]]',
          json);
    });

    test("list class serializable", () {
      List list = [new ModelC(), new ModelC()];
      String json = Serializer.toJson(list);
      expect(
          '["{\\"@dart_type\\":\\"ModelC\\",\\"foo\\":{\\"@dart_type\\":\\"ModelA\\",\\"foo\\":\\"bar\\"},\\"plop\\":\\"titi\\"}","{\\"@dart_type\\":\\"ModelC\\",\\"foo\\":{\\"@dart_type\\":\\"ModelA\\",\\"foo\\":\\"bar\\"},\\"plop\\":\\"titi\\"}"]',
          json);
    });

    test("Datetime", () {
      Date date = new Date(new DateTime(2016, 1, 1));
      expect({"@dart_type": "Date", "date": "2016-01-01 00:00:00.000"},
          date.toMap);
      expect('{"@dart_type":"Date","date":"2016-01-01 00:00:00.000"}',
          date.toJson());
    });
  });

  group("Deserialize", () {
    test("simple test - fromJson", () {
      ModelA a =
          Serializer.fromJson('{"@dart_type":"ModelA","foo":"toto"}', ModelA);

      expect(ModelA, a.runtimeType);
      expect("toto", a.foo);
    });

    test("simple test - fromMap", () {
      ModelA a =
          Serializer.fromMap({"@dart_type": "ModelA", "foo": "toto"}, ModelA);

      expect(ModelA, a.runtimeType);
      expect("toto", a.foo);
    });

    test("Map fromMap Map", () {
      //TODO: add model inside map
      Map a = {"test": "toto"};
      Map b = Serializer.fromMap(a, Map);

      expect(a["test"], b["test"]);
    });

    test("list - fromJson", () {
      List list = Serializer.fromJson(
          '["{\\"@dart_type\\":\\"ModelA\\",\\"foo\\":\\"toto\\"}","{\\"@dart_type\\":\\"ModelA\\",\\"foo\\":\\"bar\\"}"]',
          ModelA);

      expect(2, list.length);
      expect("toto", list[0]?.foo);
      expect("bar", list[1]?.foo);

      expect(ModelA, list[0]?.runtimeType);
      expect(ModelA, list[1]?.runtimeType);
    });

    test("list - fromList", () {
      List list = Serializer.fromList(
          JSON.decode(
              '["{\\"@dart_type\\":\\"ModelA\\",\\"foo\\":\\"toto\\"}","{\\"@dart_type\\":\\"ModelA\\",\\"foo\\":\\"bar\\"}"]'),
          ModelA);

      expect(2, list.length);
      expect("toto", list[0]?.foo);
      expect("bar", list[1]?.foo);

      expect(ModelA, list[0]?.runtimeType);
      expect(ModelA, list[1]?.runtimeType);
    });

    test("inner list", () {
      ModelD test = Serializer.fromJson(
          '{"@dart_type":"ModelD","tests":["{\\"@dart_type\\":\\"ModelA\\",\\"foo\\":\\"toto\\"}","{\\"@dart_type\\":\\"ModelA\\",\\"foo\\":\\"bar\\"}"]}',
          ModelD);

      expect(2, test?.tests?.length);
      expect(ModelA, test?.tests[0]?.runtimeType);
      expect(ModelA, test?.tests[1]?.runtimeType);
      expect("toto", test?.tests[0]?.foo);
      expect("bar", test?.tests[1]?.foo);
    });

    test("inner class non-serializable", () {
      ModelB b = Serializer.fromJson(
          '{"@dart_type":"ModelB","toto":"tata","foo":{"toto":"tata"}}',
          ModelB);

      expect(null, b.foo);
    });

    test("inner class serializable", () {
      ModelC c = Serializer.fromJson(
          '{"@dart_type":"ModelC","foo":{"@dart_type":"ModelA","foo":"toto"},"plop":"bar"}',
          ModelC);
      expect(ModelA, c.foo.runtimeType);
      expect("toto", c.foo.foo);
      expect("bar", c.plop);
    });

    test("Datetime", () {
      Date date = Serializer.fromJson(
          '{"@dart_type":"Date","date":"2016-01-01 00:00:00.000"}', Date);

      expect("2016-01-01 00:00:00.000", date.date.toString());
      expect('{"@dart_type":"Date","date":"2016-01-01 00:00:00.000"}',
          date.toJson());
    });
  });
}
