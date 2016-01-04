/**
 * Created by lejard_h on 23/12/15.
 */

library polymer_app.polymer_model;

import "package:polymer/polymer.dart";
import "serializer.dart";

@serializable
abstract class PolymerModel extends JsProxy with Serialize {
}