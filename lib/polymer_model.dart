/**
 * Created by lejard_h on 23/12/15.
 */

import "package:polymer/polymer.dart";
import "dart:convert";

abstract class PolymerModel extends JsProxy {
  PolymerModel.fromJson(String json) {
    _fromJson(JSON.decode(json));
  }

  PolymerModel();

  _fromJson(Map json);

  Map get toMap;

  String toString() => toMap.toString();

  String toJson() => JSON.encode(toMap);
}

