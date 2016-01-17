/**
 * Created by lejard_h on 24/12/15.
 */

part of polymer_app.cli;

const package_version = "0.7.0";
const polymer_version = ">=1.0.0-rc.12";
const polymer_elements_version = ">=1.0.0-rc.7";
const analyzer_version = ">=0.27.0";
const reflectable_version = ">=0.5.0";
const nav_view_material = "nav-view";
const nav_header_material = "nav-header";
const autonotify_observe = "^1.0.0+7";

abstract class JsonObject {
  Map _obj;

  JsonObject();

  JsonObject.fromMap(this._obj);

  JsonObject.fromJson(String json) {
    _obj = JSON.decode(json);
  }

  get(String key) => _obj[key];

  set(String key, value) => _obj[key] = value;

  Map get toMap => _obj;

  String toString() => toMap.toString();
}

class Manager {
  String appName;
  String libraryPath;
  String libraryName;

  String get libraryTemplate => "";

  Manager(this.appName, this.libraryPath, this.libraryName);

  createLibraryDirectory() async {
    await writeInDartFile(
        "$libraryPath/${toSnakeCase(libraryName)}.dart", libraryTemplate);
  }

  addToLibrary(String name, [String path = "."]) {
    print("Add ${green(name)} to library.\n");
    File lib = new File("$libraryPath/${toSnakeCase(libraryName)}.dart");
    if (!lib.existsSync()) {
      print("$libraryPath/${toSnakeCase(libraryName)}.dart : not found");
      return;
    }

    lib.writeAsStringSync(
        "export '${toSnakeCase(path)}/${toSnakeCase(name)}.dart';\n",
        mode: FileMode.APPEND);
  }
}

class PolymerAppManager extends JsonObject {
  ElementsManager _elements;
  BehaviorsManager _behaviors;
  ServicesManager _services;
  ModelsManager _models;
  RoutesManager _routes;

  String pathOutput;

  String get libraryPath => get("library_path");

  String get elementsPath => "$pathOutput/$libraryPath/${get("elements_path")}";

  String get behaviorsPath =>
      "$pathOutput/$libraryPath/${get("behaviors_path")}";

  String get servicesPath => "$pathOutput/$libraryPath/${get("services_path")}";

  String get routesPath => "$pathOutput/$libraryPath/${get("routes_path")}";

  String get modelsPath => "$pathOutput/$libraryPath/${get("models_path")}";

  String get name => get("name");

  String get webPath => get("web_path");

  RoutesManager get routes => _routes;

  ModelsManager get models => _models;

  ServicesManager get services => _services;

  BehaviorsManager get behaviors => _behaviors;

  ElementsManager get elements => _elements;

  PolymerAppManager.fromJson(String configJson, [this.pathOutput = "./"])
      : super.fromJson(configJson) {
    _parseConfig();
  }

  PolymerAppManager.fromMap(Map config, [this.pathOutput = "./"])
      : super.fromMap(config) {
    _parseConfig();
  }

  _parseConfig() {
    if (toMap == null) {
      throw "No config found.";
    }
    _elements = new ElementsManager(name, elementsPath);
    _behaviors = new BehaviorsManager(name, behaviorsPath);
    _services = new ServicesManager(name, servicesPath);
    _models = new ModelsManager(name, modelsPath);
    _routes = new RoutesManager(name, routesPath);
  }

  _fromJson(String configJson) {
    _obj = JSON.decode(configJson);
    _parseConfig();
  }

  PolymerAppManager(
      [String configPath = "./polymer_app.json", this.pathOutput = './'])
      : super() {
    File configFile = new File(configPath);
    if (!configFile.existsSync()) {
      throw "'polymer_app.json' not found.";
    }

    _fromJson(configFile.readAsStringSync());
  }

  createApplication(
      {material: false, materialLayout: nav_view_material}) async {
    await createPubspec(material: material);
    await createLibrary(material: material);
    await createIndex();
    await createRootElement(material: material, materialLayout: materialLayout);
    await createHomeRoute();
  }

  createLibrary({material: false}) async {
    await elements.createLibraryDirectory();
    await behaviors.createLibraryDirectory();
    await services.createLibraryDirectory();
    await models.createLibraryDirectory();
    await routes.createLibraryDirectory();

    if (material) {
      await writeInDartFile(
          "$pathOutput/$libraryPath/material.dart", materialLibrary());
    }
    await writeInDartFile("$pathOutput/$libraryPath/${toSnakeCase(name)}.dart",
        appLibraryTemplate(material: material));
  }

  createPubspec({material: false}) async {
    File file = new File("$pathOutput//pubspec.yaml");
    if (file.existsSync()) {
      throw "Please create an empty folder";
    }
    await writeInFile(
        "$pathOutput//pubspec.yaml", pubspecTemplate(material: material));
  }

  createIndex() async {
    await writeInFile("$pathOutput/$webPath/index.html", indexHtmlTemplate());
    await writeInDartFile(
        "$pathOutput/$webPath/index.dart", indexDartTemplate());
  }

  createRootElement(
      {material: false, materialLayout: nav_view_material}) async {
    elements.createElement(
        "root-element",
        material
            ? rootMaterialElementDartTemplate()
            : rootElementDartTemplate(),
        null,
        rootElementCssTemplate(),
        material
            ? rootMaterialElementHtmlTemplate(materialLayout)
            : rootElementHtmlTemplate());
    elements.addToLibrary("root-element");
    await writeInFile("$elementsPath/root_element/theme.html", themeHtml);
  }

  createHomeRoute() async {
    await routes.createRoute("Home", "",
        htmlTemplate: githubButton, cssTemplate: routeHomeCssTemplate);
    routes.addToLibrary(toSnakeCase("Home-route"));
  }

  String get themeHtml => '<dom-module id="theme">'
      '<template>'
      '<style>'
      ':root {'
      '--default-primary-color: #b24830;'
      '--background-color: #efefef;'
      '--paper-tab-ink: white;'
      '--paper-tab: {color: white;};'
      '--paper-tabs-selection-bar-color:  white;'
      '--paper-tabs: {'
      'background-color: var(--default-primary-color);'
      '};'
      '}:host {'
      'display: block;'
      'height: 100%;'
      '}'
      '</style>'
      '</template>'
      '</dom-module>';

  String get routeHomeCssTemplate => ":host {"
      "display: flex;"
      "flex-direction: column;"
      "align-items: center;"
      "flex: 1;"
      "height: 100%;"
      "}";

  rootElementHtmlTemplate() => '<style include="theme"></style>'
      '<div header> '
      '<span title>{{selected}}</span>'
      '<span flex ></span> '
      '<template is="dom-repeat" items="{{pages}}"> '
      '<a href="#" on-click="goTo">{{item.name}}</a>'
      '</template>'
      '</div> '
      '<div content> '
      '<polymer-app-router selected="{{selected}}" pages="{{pages}}">'
      '</polymer-app-router>'
      '</div>';

  rootElementCssTemplate() => ":host { "
      "display: block;"
      "height: 100vh;"
      "} "
      "*[flex] {"
      "display: flex;"
      "flex: 1;"
      "}"
      "div[header] span[title] {"
      "margin: 10px;"
      "color: white;"
      "font-weight: 300;"
      "text-transform: capitalize;"
      "}"
      "div[header] {"
      "display: flex;"
      "flex-direction: row;"
      "align-items: center;"
      "position: fixed;"
      "top: 0;"
      "width: 100%;"
      "height: 45px;"
      "background-color: var(--default-primary-color);"
      "}"
      "div[header] a {"
      "margin: 10px;"
      "color: white;"
      "font-size: 12px;"
      "font-weight: 300;"
      "text-decoration: none;"
      "text-transform: capitalize;"
      "}"
      "div[content] {"
      "background-color: var(--background-color);"
      "padding-top: 60px;"
      "padding-right: 15px;"
      "padding-left: 15px;"
      "height: 100vh;"
      "}"
      "/* Material Template */"
      ".content {"
      "background-color: var(--background-color);"
      "height: 100%;"
      "}"
      ".menu-item {"
      "cursor: pointer;"
      "}"
      "#nav {"
      "border-right: 1px solid #e0e0e0;"
      "}"
      "/*********************/";

  rootElementDartTemplate() => '@HtmlImport("theme.html")'
      '@HtmlImport("root_element.html")'
      "library ${toSnakeCase(name)}.elements.root_element;"
      'import "dart:html";'
      'import "package:web_components/web_components.dart" show HtmlImport;'
      'import "package:polymer_app/polymer_app.dart";'
      'import "package:${toSnakeCase(name)}/${toSnakeCase(name)}.dart";'
      '@PolymerRegister("root-element")'
      'class RootElement extends PolymerElement with AutonotifyBehavior, Observable, PolymerRouter {'
      'RootElement.created() : super.created();'
      'String _selected;'
      '@Property()'
      'String get selected => _selected;'
      'set selected(String value) {'
      '_selected = value;'
      'notifyPath("selected", value);'
      '}'
      '@reflectable '
      'void goTo(MouseEvent event, [_]) {'
      'event.stopPropagation();'
      'event.preventDefault();'
      'HtmlElement elem = event.target;'
      'PolymerRouter.goToName(elem.text);'
      '}'
      '@reflectable '
      'void goToDefault(MouseEvent event, [_]) {'
      'event.stopPropagation();'
      'event.preventDefault();'
      'PolymerRouter.goToDefault();'
      '}'
      '}';

  indexHtmlTemplate() => "<!DOCTYPE html>\n"
      "<html>\n"
      "\t<head>\n"
      '\t\t<meta charset="utf-8">\n'
      '\t\t<meta name="viewport" content="width=device-width, minimum-scale=1.0, initial-scale=1.0, user-scalable=yes">\n'
      '\t\t<title>$name</title>\n'
      '\t\t<script src="packages/web_components/webcomponents-lite.min.js"></script>\n'
      '\t\t<script src="packages/web_components/dart_support.js"></script>\n'
      "\t\t<style>body {margin:0;font-family: 'Roboto', 'Noto', sans-serif;font-weight: 300;}</style>\n"
      '\t</head>\n'
      '\t<body unresolved class="fullbleed layout vertical">\n'
      '\t\t<root-element></root-element>\n'
      '\t\t<script type="application/dart" src="index.dart"></script>\n'
      '\t\t<script src="packages/browser/dart.js"></script>\n'
      '\t</body>\n'
      '</html>\n';

  indexDartTemplate() => "import 'package:polymer/polymer.dart';"
      "import 'package:${toSnakeCase(name)}/${toSnakeCase(name)}.dart';"
      'import "package:polymer_app/polymer_app.dart";'
      "main() async {"
      "await initPolymerApp();"
      "}";

  appLibraryTemplate({material: false}) => "library ${toSnakeCase(name)};\n\n"
      "export '${get("routes_path")}/routes.dart';"
      "export '${get("elements_path")}/elements.dart';"
      "export '${get("behaviors_path")}/behaviors.dart';"
      "export '${get("models_path")}/models.dart';"
      "export '${get("services_path")}/services.dart';"
      "${material ? "export 'material.dart';" : ""}";

  pubspecTemplate({material: false}) => "name: ${toSnakeCase(name)}\n"
      "#description:\n"
      "version: 0.0.1\n"
      "#author:\n"
      "#homepage:\n\n"
      "environment:\n"
      "  sdk: '>=1.13.0 <2.0.0'\n\n"
      "dependencies:\n"
      '  analyzer: "$analyzer_version"\n'
      '  polymer: "$polymer_version"\n'
      '  polymer_app: "^$package_version"\n'
      '${material ? "  polymer_elements: '$polymer_elements_version'\n" : ""}'
      '  dart_to_js_script_rewriter: "^0.1.0+4"\n'
      '  web_components: "^0.12.0"\n'
      '  browser: "^0.10.0"\n'
      '  autonotify_observe: "$autonotify_observe"\n'
      '  reflectable: "$reflectable_version"\n\n'
      'transformers:\n'
      '  - autonotify_observe\n'
      '  - polymer:\n'
      '      entry_points:\n'
      '      - web/index.html\n'
      '  - reflectable:\n'
      '      entry_points:\n'
      '      - web/index.dart\n'
      '  - \$dart2js:\n'
      '      minify: true\n'
      "      commandLineOptions: ['--trust-type-annotations', '--trust-primitives', '--enable-experimental-mirrors']\n"
      '  - dart_to_js_script_rewriter\n';

  String get githubButton =>
      '<div style="display: flex; display: flex;flex: 1;align-items: center;">'
      '<a class="github-button\" href=\"https://github.com/walletek/polymer_app\" data-style=\"mega\" data-icon=\"octicon-eye\" data-count-href=\"/walletek/polymer_app/watchers\" data-count-api=\"/repos/walletek/polymer_app#subscribers_count\" data-count-aria-label=\"# watchers on GitHub\" aria-label=\"Watch walletek/polymer_app on GitHub\">Watch</a>'
      '<a class="github-button\" href=\"https://github.com/walletek/polymer_app\" data-style=\"mega\" data-icon=\"octicon-star\" data-count-href=\"/walletek/polymer_app/stargazers\" data-count-api=\"/repos/walletek/polymer_app#stargazers_count\" data-count-aria-label=\"# stargazers on GitHub\" aria-label=\"Star walletek/polymer_app on GitHub\">Star</a>'
      '<a class="github-button\" href=\"https://github.com/walletek/polymer_app/issues\" data-style=\"mega\" data-icon=\"octicon-issue-opened\" data-count-api=\"/repos/walletek/polymer_app#open_issues_count\" data-count-aria-label=\"# issues on GitHub\" aria-label=\"Issue lejard-h/polymer_app on GitHub\">Issue</a>'
      '<script async defer id=\"github-bjs\" src=\"https://buttons.github.io/buttons.js\"></script>'
      '</div>';

  rootMaterialElementDartTemplate() => '@HtmlImport("theme.html")'
      '@HtmlImport("root_element.html")'
      "library ${toSnakeCase(name)}.elements.root_element;"
      'import "dart:html";'
      'import "package:web_components/web_components.dart" show HtmlImport;'
      'import "package:polymer_app/polymer_app.dart";'
      'import "package:${toSnakeCase(name)}/${toSnakeCase(name)}.dart";'
      '@PolymerRegister("root-element")'
      'class RootElement extends PolymerElement with AutonotifyBehavior, Observable, PolymerRouter {'
      'RootElement.created() : super.created();\n\n'
      "PaperDrawerPanel get drawer => \$['drawerPanel'];"
      'String _selected;'
      '@Property()'
      'String get selected => _selected;'
      'set selected(String value) {'
      '_selected = value;'
      ' if (value != null) {'
      'PolymerRouter.goToName(value);'
      '}'
      'notifyPath("selected", value);'
      '}'
      '@reflectable '
      'void goToDefault(MouseEvent event, [_]) {'
      'event.stopPropagation();'
      'event.preventDefault();'
      'drawer.closeDrawer();'
      'PolymerRouter.goToDefault();'
      '}'
      '}';

  get templateNavHeader =>
      '<iron-media-query query-matches="{{_isNotMobile}}" query="(min-width: 780px)"></iron-media-query>'
      '<paper-drawer-panel responsive-width="780px" id="drawerPanel" transition> '
      '<div class="nav layout vertical" drawer id="nav"><!-- Nav Content --> '
      '<paper-toolbar><span>$name</span></paper-toolbar>'
      ' <paper-menu id="menu" valueattr="hash" class="flex" attr-for-selected="hash" selected="{{selected}}">'
      ' <template is="dom-repeat" items="{{pages}}"> '
      '<paper-item class="menu-item" hash\$={{item.name}}><spanclass="layout horizontal">'
      '<span class="flex">{{item.name}}</span>'
      '</span>'
      '</paper-item>'
      '</template>'
      '</paper-menu>'
      '</div>'
      '<paper-header-panel class="main" main mode="waterfall" style="z-index: 0"><!-- Main Toolbar --> '
      '<paper-toolbar> '
      '<template if="{{_isNotMobile}}" is="dom-if"> '
      '<paper-icon-button icon="menu" paper-drawer-toggle></paper-icon-button>'
      '</template> '
      '<div class="flex">{{selected}}</div>'
      '</paper-toolbar><!-- Main Content --> '
      '<div class="content layout vertical fit"> '
      '<template if="{{!_isNotMobile}}" is="dom-if"> '
      '<div class="layout horizontal">'
      ' <paper-tabs attr-for-selected="hash" selected="{{selected}}" class="flex" id="tabs"valueattr="hash"> '
      '<template is="dom-repeat" items="{{pages}}"> <paper-tab hash\$={{item.name}} class="menu-item">'
      ' <span class="layout horizontal"> <span class="flex">{{item.name}}</span>'
      '</span>'
      '</paper-tab>'
      '</template>'
      '</paper-tabs>'
      '</div>'
      '</template>'
      ' <div class="layout vertical flex"> '
      '<polymer-app-router class="flex" selected="{{selected}}" pages="{{pages}}"></polymer-app-router>'
      '</div>'
      '</div>'
      '</paper-header-panel>'
      '</paper-drawer-panel>';

  get templateNavView =>
      '<paper-drawer-panel id="drawerPanel" responsive-width="1280px" transition>'
      '<div class="nav layout vertical" drawer id="nav">'
      '<!-- Nav Content -->'
      '<paper-toolbar>'
      '<span>$name</span>'
      '</paper-toolbar>'
      '<paper-menu id="menu" valueattr="hash" class="flex" attr-for-selected="hash" selected="{{selected}}">'
      '<template is="dom-repeat" items="{{pages}}">'
      '<paper-item class="menu-item" hash\$={{item.name}}>'
      '<span class="layout horizontal">'
      '<span class="flex">{{item.name}}</span>'
      '</span>'
      '</paper-item>'
      '</template>'
      '</paper-menu>'
      '</div>'
      '<paper-header-panel class="main" main mode="waterfall" style="z-index: 0">'
      '<!-- Main Toolbar -->'
      '<paper-toolbar>'
      '<paper-icon-button icon="menu" paper-drawer-toggle></paper-icon-button>'
      '<div class="flex">{{selected}}</div>'
      '</paper-toolbar>'
      '<!-- Main Content -->'
      '<div class="content">'
      '<polymer-app-router class="flex" selected="{{selected}}" pages="{{pages}}"></polymer-app-router>'
      '</div>'
      '</paper-header-panel>'
      '</paper-drawer-panel>';

  rootMaterialElementHtmlTemplate(String type) =>
      '<style include="theme"></style>${(type == nav_header_material ? templateNavHeader : templateNavView)}';

  materialLibrary() => "library polymer_app_test.material;\n\n"
      "export 'package:polymer_elements/iron_icon.dart';"
      "export 'package:polymer_elements/iron_icons.dart';"
      "export 'package:polymer_elements/iron_media_query.dart';"
      "export 'package:polymer_elements/neon_animated_pages.dart';"
      "export 'package:polymer_elements/paper_drawer_panel.dart';"
      "export 'package:polymer_elements/paper_header_panel.dart';"
      "export 'package:polymer_elements/paper_icon_button.dart';"
      "export 'package:polymer_elements/paper_item.dart';"
      "export 'package:polymer_elements/paper_material.dart';"
      "export 'package:polymer_elements/paper_menu.dart';"
      "export 'package:polymer_elements/paper_tab.dart';"
      "export 'package:polymer_elements/paper_tabs.dart';"
      "export 'package:polymer_elements/paper_toolbar.dart';"
      "export 'package:polymer_elements/paper_toast.dart';";
}
