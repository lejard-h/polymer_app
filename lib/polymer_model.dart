/**
 * Created by lejard_h on 23/12/15.
 */

import "package:polymer/polymer.dart";
import "dart:convert";

abstract class PolymerModel extends JsProxy {
  PolymerModel.decodefromJson(String json) {
    fromJson(json);
  }

  fromJson(String json);

  Map get toMap;

  String toString() => toMap.toString();

  String toJson();
}
