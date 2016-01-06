[![Build Status](https://travis-ci.org/walletek/polymer_app.svg?branch=master)](https://travis-ci.org/walletek/polymer_app)
[![pub package](https://img.shields.io/pub/v/polymer_app.svg)](https://pub.dartlang.org/packages/polymer_app)
[![Coverage Status](https://coveralls.io/repos/walletek/polymer_app/badge.svg?branch=master&service=github)](https://coveralls.io/github/walletek/polymer_app?branch=master)
# polymer_app

## Installation

    pub global activate polymer_app
    
## Usage

    polymer_app
    > new_application my_application --output_folder=./app
or
    ls
    

    
### Available commands

    exit                                                                                             Exit the program
    help             [term=String]                                                                   Show help screen
    reload           [arguments=List<String>]                                                        Exit and restart the program
    as_shell                                                                                         Launch polymer_app as_shell
    new_route        name=String path=String --output_folder=String                                  Create new polymer_app route.
    new_model        name=String --output_folder=String                                              Create new polymer_app model.
    new_service      name=String --output_folder=String                                              Create new polymer_app service.
    new_behavior     name=String --output_folder=String                                              Create new polymer behavior.
    new_element      name=String --output_folder=String                                              Create new polymer element.
    new_config       name=String --output_folder=String                                              Create new polymer_app config.
    new_application  name=String --output_folder=String --is_material=bool --material_layout=String  Create new polymer application.

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
