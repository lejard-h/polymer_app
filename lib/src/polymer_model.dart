/**
 * Created by lejard_h on 23/12/15.
 */

part of polymer_app;

@serializable
abstract class PolymerModel extends JsProxy with Observable {

  Map get toMap => Serializer.toMap(this);

  String toString() => toMap.toString();

  String toJson() => Serializer.toJson(this);

}
