[![Build Status](https://travis-ci.org/lejard-h/polymer_app.svg?branch=master)](https://travis-ci.org/lejard-h/polymer_app)
# polymer_app

## Roadmap
- Create a full website/documentation on the library
- Polymer Theming
- Improve cli

## Installation

    pub global activate polymer_app
    
## Usage

    polymer_app 
        new app "app_name" [-m](Material Desgin Template)
        new element "element-name"
        new model "name"
        new behavior "name"
        new service "name"
        new route "name" "path"
        new config "name"
        -o, --output-folder    (defaults to "./")
        -h, --[no-]help  

### Create a polymer app

    polymer_app new app awesome_app
    pub get
    pub serve

### Create a polymer element

    polymer_app new element my-element
    
### Create a route

    polymer_app new route name path   

### Create a polymer behavior

    polymer_app new behavior name
    
### Create a polymer model (with serialize/deserilize)

    polymer_app new model name
    
### Create a service (class with factory constructor)

    polymer_app new service name
    
### Usage of Router

#### Html

    <polymer-app-router selected="{{selected}}">
        <polymer-app-route name="home" path="" is-default>home</polymer-app-route>
        <polymer-app-route name="one" path="one">one</polymer-app-route>
        <polymer-app-route name="two" path="two">two</polymer-app-route>
    </polymer-app-router>
    
#### Dart

    import 'package:polymer_app_router/polymer_app_router.dart' show PolymerRouter;
    
    PolymerRouter.goToDefault(
          {Map parameters,
          Route startingFrom,
          bool replace: false,
          Map queryParameters,
          bool forceReload: false})
          
    PolymerRouter.goToDefault(
           {Map parameters,
           Route startingFrom,
           bool replace: false,
           Map queryParameters,
           bool forceReload: false})
