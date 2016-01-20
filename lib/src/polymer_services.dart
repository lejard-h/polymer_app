/**
 * Created by lejard_h on 15/01/16.
 */

part of polymer_app;

class Service extends Reflectable {
  const Service()
      : super.fromList(const [
          invokingCapability,
          typeCapability,
          typingCapability,
          superclassQuantifyCapability,
          newInstanceCapability,
          reflectedTypeCapability,
          instanceInvokeCapability
        ]);
}

const service = const Service();

@service
class PolymerService extends PolymerModel {
  static reset() {
    _services.clear();
  }

  static Map<String, PolymerService> _services = new Map();

  static PolymerService getService(String name) {
    if (_services.containsKey(name)) {
      return _services[name];
    }
    return null;
  }

  static registerService(String name, PolymerService service) {
    if (_services.containsKey(name)) {
      throw "$name already exist";
    }
    _services[name] = service;
  }

  static initAllServices() {
    _services.forEach((name, PolymerService service) {
      service.init();
    });
  }

  init() {}
}

initServices() async {
  PolymerService.reset();
  service.annotatedClasses.forEach((classMirror) {
    if (classMirror != null &&
        classMirror.simpleName != null &&
        classMirror.reflectedType != PolymerModel &&
        !classMirror.isAbstract) {
      var obj = classMirror.newInstance('', []);
      var instance = service.reflect(obj);
      var ref = instance.reflectee;
      if (ref is PolymerService) {
        PolymerService.registerService(
            toSnakeCase(classMirror.simpleName).replaceAll("_service", ""),
            ref);
      }
    }
  });
  PolymerService.initAllServices();
}
