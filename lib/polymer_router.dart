/**
 * Created by lejard_h on 30/12/15.
 */

import 'package:initialize/initialize.dart' as init;
import 'package:polymer/polymer.dart';
import 'package:polymer_app_router/polymer_app_router.dart';
import 'dart:mirrors';
import 'dart:html';

@behavior
abstract class PolymerRouterBehavior {
  List<Page> _pages = [];

  static List<Page> pagesRouter = [];

  @Property() List<Page> get pages => _pages;
  set pages(List<Page> value) {
    _pages = value;
    notifyPath("pages", value);
  }

  ready() {
    init.run().then((_) {
      pages = pagesRouter;
    });
  }
}

Object _getAnnotation(DeclarationMirror declaration, Type annotation) {
  for (var instance in declaration.metadata) {
    if (instance.hasReflectee) {
      var reflectee = instance.reflectee;
      if (reflectee.runtimeType == annotation) {
        return reflectee;
      }
    }
  }

  return null;
}

class PolymerRoute implements init.Initializer<Type> {
  final String name;
  final String path;

  const PolymerRoute(this.name, this.path);

  initialize(Type element) {
    TypeMirror mir = reflectType(element);
    PolymerRegister reg = _getAnnotation(mir, PolymerRegister);

    if (reg != null) {
      PolymerRouterBehavior.pagesRouter.add(new Page(name, path,
          document.createElement(reg.tagName) as PolymerAppRouteBehavior));
    }
  }
}
