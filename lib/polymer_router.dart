/**
 * Created by lejard_h on 30/12/15.
 */

import 'package:initialize/initialize.dart' as init;
import 'package:polymer/polymer.dart';
import 'package:polymer_app_router/polymer_app_router.dart';
import 'dart:html';
import "package:reflectable/reflectable.dart";

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

Object _getAnnotation(Type element, Type annotation) {
  TypeMirror mir = jsProxyReflectable.reflectType(element);
  for (var dec in mir.metadata) {
    if (dec.runtimeType == annotation) {
      return dec;
    }
  }

  return null;
}

class PolymerRoute implements init.Initializer<Type> {
  final String name;
  final String path;

  const PolymerRoute(this.name, this.path);

  initialize(Type element) {
    PolymerRegister reg = _getAnnotation(element, PolymerRegister);
    if (reg != null) {
      PolymerRouterBehavior.pagesRouter.add(new Page(name, path,
          document.createElement(reg.tagName) as PolymerAppRouteBehavior));
    }
  }
}
