# polymer_app

## Installation

    pub global activate polymer_app
    
## Usage

### Create a polymer app

    polymer_app new app awesome_app
    cd awesome_app
    pub get
    pub serve

### Create a polymer element

    polymer_app new element my-element
    
### Create a polymer behavior

    polymer_app new behavior my-behavior
    
### Create a polymer model (with serialize/deserilize)

    polymer_app new model my-model
    
### Create a service (class with factory constructor)

    polymer_app new service my-service
    
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
   
See [polymer_app_router](https://github.com/lejard-h/polymer_app_router) for more documentation. 