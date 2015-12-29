/**
 * Created by lejard_h on 23/12/15.
 */

import "package:polymer/polymer.dart";
import "dart:convert";

abstract class PolymerModel extends JsProxy {
  PolymerModel.fromJson(json) {
    if (json is String) {
      json = JSON.decode(json) as Map;
    }
    if (json is Map) {
      fromMap(json);
    } else {
      throw "Invalid Json format.";
    }
  }

  PolymerModel();

  fromMap(Map json);

  Map get toMap;

  String toString() => toMap.toString();

  String toJson() => JSON.encode(toMap);
}

