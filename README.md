[![Build Status](https://travis-ci.org/lejard-h/polymer_app.svg?branch=master)](https://travis-ci.org/lejard-h/polymer_app)
# polymer_app

## Roadmap
- Create a full website/documentation on the library
- Polymer Theming
- Add some [polymer_app_layout_templates](https://github.com/lejard-h/polymer_app_layout_templates)

## Installation

    pub global activate polymer_app
    
## Usage

    polymer_app
    > new_application --outputFolderPath=./foo
or

    polymer_app new_application --name=awesome_app --outputFolderPath=./foo

### Create a polymer app

    polymer_app
    > new_application --outputFolderPath=./foo
    > serve

### Create a polymer element

    polymer_app new_element --name=my-element
    
### Create a route

    polymer_app new_route --name=foo --path=/foo   

### Create a polymer behavior

    polymer_app new_behavior --name=foo
    
### Create a polymer model (with serialize/deserilize)

    polymer_app new_model --name=foo
    
### Create a service (class with factory constructor)

    polymer_app new_service --name=foo
    
### Available commands

    exit                                                            Exit the program
    help             [term=String]                                  Show help screen
    reload           [arguments=List<String>]                       Exit and restart the program
    new_route        --name=String --path=String                    Create new polymer_app route.
    new_model        --name=String                                  Create new polymer_app model.
    new_service      --name=String                                  Create new polymer_app service.
    new_behavior     --name=String                                  Create new polymer behavior.
    new_element      --name=String                                  Create new polymer element.
    new_config       --name=String --configOutputFolderPath=String  Create new polymer_app config.
    serve                                                           Pub get and pub serve your application
    new_application  --name=String --outputFolderPath=String        Create new polymer application.
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
