/**
 * Created by lejard_h on 04/01/16.
 */

import "package:test/test.dart";
import "package:polymer_app/serializer.dart";

@serializable
abstract class Proxy {
}

abstract class ProxyA extends Proxy with Serialize {

}

@serializable
class ModelA extends ProxyA{

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
class Date extends ProxyA {
    DateTime date = new DateTime.now();
    Date([this.date]);
}

main() {

    group("Serialize", () {

        test("simple test", () {

            ModelA a = new ModelA("toto");

            expect('{"@dart_type":"ModelA","foo":"toto"}', a.toJson());
            expect({ "@dart_type": "ModelA", "foo": "toto"}, a.toMap);
        });

        test("list", () {

            List<ModelA> list = [ new ModelA("toto"), new ModelA() ];

            String json = Serializer.toJson(list);
            expect('["{\\"@dart_type\\":\\"ModelA\\",\\"foo\\":\\"toto\\"}","{\\"@dart_type\\":\\"ModelA\\",\\"foo\\":\\"bar\\"}"]', json);
        });

        test("inner class non-serializable", () {
            ModelB b = new ModelB();
            expect('{"@dart_type":"ModelB","toto":"tata"}', b.toJson());
            expect({"@dart_type":"ModelB","toto":"tata"}, b.toMap);

        });

        test("inner class serializable", () {
            ModelC c = new ModelC();
            expect('{"@dart_type":"ModelC","foo":{"@dart_type":"ModelA","foo":"bar"},"plop":"titi"}', c.toJson());
            expect({"@dart_type":"ModelC","foo":{"@dart_type":"ModelA","foo":"bar"},"plop":"titi"}, c.toMap);
        });

        test("list class non-serializable", () {
            List list = [new ModelB(), new ModelB()];
            String json = Serializer.toJson(list);
            expect('["{\\"@dart_type\\":\\"ModelB\\",\\"toto\\":\\"tata\\"}","{\\"@dart_type\\":\\"ModelB\\",\\"toto\\":\\"tata\\"}"]', json);

        });

        test("list class serializable", () {
            List list = [new ModelC(), new ModelC()];
            String json = Serializer.toJson(list);
            expect('["{\\"@dart_type\\":\\"ModelC\\",\\"foo\\":{\\"@dart_type\\":\\"ModelA\\",\\"foo\\":\\"bar\\"},\\"plop\\":\\"titi\\"}","{\\"@dart_type\\":\\"ModelC\\",\\"foo\\":{\\"@dart_type\\":\\"ModelA\\",\\"foo\\":\\"bar\\"},\\"plop\\":\\"titi\\"}"]', json);
        });

        test("Datetime", () {
            Date date = new Date(new DateTime(2016, 1, 1));
            expect({"@dart_type":"Date","date":"2016-01-01 00:00:00.000"}, date.toMap);
            expect('{"@dart_type":"Date","date":"2016-01-01 00:00:00.000"}', date.toJson());
        });
    });

    group("Deserialize", () {

        test("simple test", () {
            ModelA a = new ModelA("toto");

            expect('{"@dart_type":"ModelA","foo":"toto"}', a.toJson());
            expect({ "@dart_type": "ModelA", "foo": "toto"}, a.toMap);
        });

        test("Datetime", () {
           Date date = Serializer.fromJson('{"@dart_type":"Date","date":"2016-01-01 00:00:00.000"}', Date);

            expect("2016-01-01 00:00:00.000", date.date.toString());
            expect('{"@dart_type":"Date","date":"2016-01-01 00:00:00.000"}', date.toJson());

        });

    });

}