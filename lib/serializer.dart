/**
 * Created by lejard_h on 02/01/16.
 */

library polymer_app.serializer;

import "dart:convert";
import "package:reflectable/reflectable.dart";

class Serialize {
    Map get toMap => Serializer.toMap(this);

    String toString() => toMap.toString();

    String toJson() => Serializer.toJson(this);
}

class Serializer {
    static final Map<String, ClassMirror> classes = <String, ClassMirror>{};

    static Type max_superclass_type = Object;

    static Map toMap(Object obj) => _toMap(obj);

    static String toJson(Object obj) => _toJson(obj);

    static Object fromJson(String json, Type type) => _fromJson(json, type);

    static Object fromMap(Map json, Type type) => _fromMap(json, type);

    static Object fromList(List json, Type type) => _fromList(json, type);
}

initSerializer() async {
    for (ClassMirror classMirror in serializable.annotatedClasses) {
        Serializer.classes[classMirror.qualifiedName] = classMirror;
    }
}

const String type_info_key = "@dart_type";

class Serializable extends Reflectable {
    const Serializable()
        : super.fromList(const [
        invokingCapability,
        typeCapability,
        typingCapability,
        superclassQuantifyCapability,
        newInstanceCapability,
        reflectedTypeCapability
    ]);
}

const serializable = const Serializable();

bool _isSerializableVariable(DeclarationMirror vm) {
    return !vm.isPrivate;
}

bool _isObjPrimaryType(Object obj) => _isPrimaryType(obj.runtimeType);

bool _isPrimaryType(Type obj) => obj == num || obj == String || obj == bool;

Type _decodeType(String name) {
    ClassMirror classMirror = Serializer.classes[".$name"];
    return classMirror.dynamicReflectedType;
}

List _fromList(List list, Type type) {
    List _list = new List.from(list);
    for (var i = 0; i < _list.length; i++) {
        if (_list[i] is String) {
            _list[i] = JSON.decode(_list[i]);
        }
        Type _type = type;
        if (_list[i] is Map && (_list[i] as Map).containsKey(type_info_key)) {
            _type = _decodeType(_list[i][type_info_key]);
        }
        _list[i] = _decode(_list[i], _type);
    }
    return _list;
}

Object _fromMap(Map json, Type type) {
    if (json == null) {
        return null;
    }
    json.remove(type_info_key);

    if (type == Map) {
        return new Map.from(json);
    }

    ClassMirror cm;
    Object obj;
    InstanceMirror instance;
    Object ref;
    try {
        cm = serializable.reflectType(type);
        obj = cm.newInstance('', []);
        instance = serializable.reflect(obj);
        ref = instance.reflectee;
    } catch (e) {
        return null;
    }

    for (var key in json.keys) {
        MethodMirror dec = cm.instanceMembers[key];
        if (dec != null && _isSerializableVariable(dec)) {
            if (_isPrimaryType(dec.reflectedReturnType)) {
                instance.invokeSetter(key, json[key]);
            } else if (dec.reflectedReturnType == DateTime) {
                instance.invokeSetter(key, DateTime.parse(json[key]));
            } else {
                instance.invokeSetter(key, _decode(json[key], dec.reflectedReturnType));
            }
        }
    }

    return ref;
}

Object _decode(Object decode, Type type) {
    if (decode is Map) {
        return _fromMap(decode, type);
    } else if (decode is List) {
        return _fromList(decode, type);
    }
    return decode;
}

Object _fromJson(String json, Type type) {
    if (json == null) {
        return null;
    }
    return _decode(JSON.decode(json), type);
}

List _convertList(List list) {
    List _list = new List.from(list);
    for (var elem in list) {
        if (elem is List) {
            elem = _convertList(elem);
        } else if (elem is Map || elem is Serialize || _isObjPrimaryType(elem)) {
            elem = _toMap(elem);
        }
    }
    return _list;
}

Map _toMap(Object obj) {
    if (obj == null || obj is List) {
        return null;
    }
    if (obj is Map) {
        Map data = new Map.from(obj);
        data[type_info_key] = obj.runtimeType.toString();
        data.forEach((key, value) {
            if (value is List) {
                data[key] = _convertList(value);
            } else if (value is Map || value.runtimeType is Serialize) {
                data[key] = _toMap(value);
            }
        });
        return data;
    }
    InstanceMirror mir = serializable.reflect(obj);
    ClassMirror cm = mir.type;
    Map data = new Map();

    data[type_info_key] = obj.runtimeType.toString();

    while (cm.superclass != null && cm.reflectedType != Serializer.max_superclass_type) {
        cm.declarations.forEach((String key, DeclarationMirror dec) {
            if (dec is VariableMirror) {
                if (_isSerializableVariable(dec)) {
                    var value = mir.invokeGetter(dec.simpleName);
                    if (_isObjPrimaryType(value)) {
                        data[key] = value;
                    } else if (value is Map || value is Serialize) {
                        data[key] = _toMap(value);
                    } else if (value is List) {
                        data[key] = _convertList(value);
                    } else if (value is DateTime) {
                        data[key] = value.toString();
                    }
                }
            }
        });
        cm = cm.superclass;
    }
    return data;
}

_toJson(Object obj) {
    if (obj == null) {
        return null;
    }
    if (obj is List) {
        return JSON.encode(_convertList(obj));
    }
    return JSON.encode(_toMap(obj));
}