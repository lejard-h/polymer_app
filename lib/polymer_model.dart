/**
 * Created by lejard_h on 23/12/15.
 */

import "package:polymer/polymer.dart";
import "dart:convert";
import "package:reflectable/reflectable.dart";

Map _handleUseCaseVarFromMap(Map values) {
  if (values.containsKey("useCache")) {
    values.remove("useCache");
  }
  return values;
}

class Serializable extends Reflectable {
  const Serializable()
      : super(
            invokingCapability, // Request the capability to invoke methods.
            typeCapability,
            superclassQuantifyCapability,
            typingCapability);
}

const serializable = const Serializable();

bool _isSerializableVariable(VariableMirror vm) {
  return !vm.isPrivate;
}

bool _isConvertibleObject(Object obj) => obj is PolymerModel || obj is Map;

List _convertList(List list) {
  List _list = new List.from(list);
  for (var elem in list) {
    if (elem is List) {
      elem = _convertList(elem);
    } else if (elem is Map || _isConvertibleObject(elem)) {
      elem = _toMap(elem);
    }
  }
  return _list;
}

Map _toMap(Object obj) {
  if (obj is List) {
    return null;
  }
  if (obj is Map) {
    Map data = new Map.from(obj);
    for (var key in data) {
      if (data[key] is List) {
        data[key] = _convertList(data[key]);
      } else if (obj[key] is Map) {
        data[key] = _toMap(data[key]);
      }
    }
    return data;
  }
  InstanceMirror mir = serializable.reflect(obj);
  ClassMirror cm = mir.type;
  Map data = new Map();

  while (cm.superclass != null && cm.reflectedType != PolymerModel) {
    cm.declarations.forEach((String key, DeclarationMirror dec) {
      if (dec is VariableMirror) {
        if (_isSerializableVariable(dec)) {
          data[key] = mir.invokeGetter(dec.simpleName);
        }
      }
    });
    cm = cm.superclass;
  }
  return data;
}

_toJson(Object obj) {
  if (obj is List) {
    return JSON.encode(_convertList(obj));
  }
  return JSON.encode(_toMap(obj));
}

@serializable
abstract class PolymerModel extends JsProxy {
   Map get toMap => _toMap(this);

  String toString() => toMap.toString();

  String toJson() => _toJson(this);

   static Map convertToMap(Object obj) => _toMap(obj);

  static String convertToJson(Object obj) => _toJson(obj);

 /* static PolymerModel fromJson(String json, Type type) =>
      jmap.deserialize(json, type);

  static PolymerModel fromMap(Map json, Type type) =>
      PolymerModel.fromJson(JSON.encode(_handleUseCaseVarFromMap(json)), type);*/
}

/*
const _EMPTY_SYMBOL = const Symbol('');

*/
/**
 * Helper class to deserialize generic types. Due to limitations of
 * the Dart language, we cannot have an expresion like so:
 *
 *     import 'package:json_mapper/json_mapper.dart' as jmap;
 *     int main() {
 *       List<Contact> contacts = jmap.deserialize(jsonString, <Contact>[].runtimeType);
 *     }
 *
 * We can use the helper to help us out:
 *
 *     jmap.deserialize(jsonString, TypeOf<List<ContactType>>.type);
 */ /*

class TypeOf<T> {
  Type get type => T;

  const TypeOf();
}

*/
/**
 * Serializes the provided [obj] into a valid JSON [String].
 * [obj] The object to be serialized.
 *
 * Can accept a list, map, or any instance of a class. Will throw
 * a [ArgumentError] if the input is a scalar value, as it will not
 * produce valid JSON.
 */ /*

String serialize(Object obj) {
  if (obj == null) {
    return null;
  }
  if (_isPrimitiveType(obj)) { // entry value can only be object, map, or list.
    throw new ArgumentError('Cannot serialize a scalar value into a JSON representation.');
  }
  return convert.JSON.encode(_serializeObject(obj));
}


*/
/**
 * Recursively serializes the provided [obj].
 * For internal use only.
 */ /*

dynamic _serializeObject(Object obj) {
  if (obj == null) {
    return null;
  }
  if (_isPrimitiveType(obj)) {
    return obj;
  }

  if (obj is List) {
    List<Object> list = new List<Object>();
    for (var e in obj) {
      list.add(_serializeObject(e));
    }
    return list;
  }

  Map<String, Object> data = new Map<String, Object>();
  if (obj is Map) {
    // what if key is not string?
    for (var k in obj.keys) {
      data[k] = _serializeObject(obj[k]);
    }
    return data;
  }

  // serializes object fields and getters.
  mirrors.InstanceMirror im = mirrors.reflect(obj);
  mirrors.ClassMirror cm = im.type;

  while (cm.superclass != null) {
    cm.declarations.forEach((Symbol sym, dynamic dec) {
      if (dec is mirrors.VariableMirror) {
        if (_isSerializableVariable(dec)) {
          data[mirrors.MirrorSystem.getName(sym)] = _serializeObject(im.getField(dec.simpleName).reflectee);
        }
      } else if (dec is mirrors.MethodMirror) {
        if (_hasGetter(cm, dec) && _isSerializableGetter(dec)) {
          data[mirrors.MirrorSystem.getName(sym)] = _serializeObject(im.getField(dec.simpleName).reflectee);
        }
      }
    });
    cm = cm.superclass;
  }

  return data;
}

*/
/**
 * Deserializes a JSON [String] and maps it to the provided [type].
 * Returns the an Object of type passed to [type]
 */ /*

dynamic deserialize(String json, Type type) {
  if (json == null) {
    return null;
  }

  return _deserializeObject(convert.JSON.decode(json), type);
}

*/
/**
 * Recursive function for mapping a [json] to the provided [type]
 */ /*

dynamic _deserializeObject(dynamic json, Type type) {
  if (json == null) {
    return null;
  }
  if (_isPrimitiveType(json)) {
    return json;
  }

  mirrors.ClassMirror cm = mirrors.reflectClass(type);
  mirrors.InstanceMirror instance = cm.newInstance(_EMPTY_SYMBOL, []);
  var ref = instance.reflectee;

  if (ref is List) {
    Type valType = mirrors.reflectType(type).typeArguments.single.reflectedType;
    for (var item in json) {
      ref.add(_deserializeObject(item, valType));
    }
  } else if (ref is Map) {
    Type valType = mirrors.reflectType(type).typeArguments.last.reflectedType;
    for (var key in json.keys) {
      ref[key] = _deserializeObject(json[key], valType);
    }
  } else {
    for (var key in json.keys) {
      Symbol sym = new Symbol(key);
      var dec = cm.instanceMembers[sym];
      if (dec != null) {
        if (dec is mirrors.VariableMirror && _isSerializableVariable(dec)) {
          instance.setField(sym, _deserializeObject(json[key], dec.type.reflectedType));
        } else if (dec is mirrors.MethodMirror) {
          if (_hasGetter(cm, dec) && _isSerializableGetter(dec)) {
            instance.setField(sym, _deserializeObject(json[key], dec.returnType.reflectedType));
          }
        }
      }

    }
  }
  return ref;
}

*/
/**
 * Returns true if [obj] is a [num], [String], or [bool].
 */ /*

bool _isPrimitiveType(Object obj) {
  return obj is num || obj is String || obj is bool;
}

*/
/**
 * Returns true if the variable is a public instance variable.
 */ /*

bool _isSerializableVariable(mirrors.VariableMirror vm) {
  return !vm.isStatic && !vm.isFinal && !vm.isPrivate;
}

*/
/**
 * Returns true if the method is a public instance getter.
 */ /*

bool _isSerializableGetter(mirrors.MethodMirror mm) {
  return mm.isGetter && !mm.isStatic && !mm.isPrivate;
}

*/
/**
 * Checks if the following [mm] getter method has a corresponding setter method.
 * Returns `true` if one is found, false otherwise.
 */ /*

bool _hasGetter(mirrors.ClassMirror cm, mirrors.MethodMirror mm) {
  var setterDec = cm.instanceMembers[new Symbol(mirrors.MirrorSystem.getName(mm.simpleName) + '=')];
  return setterDec != null && !setterDec.isPrivate && !setterDec.isStatic && setterDec.isSetter;
}*/
