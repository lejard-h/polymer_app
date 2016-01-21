# Changelog

## 0.7.4
- Fix conflict between ```Serializer``` and ```autonotify```

## 0.7.3
- Update to polymer 1.0.0-rc.14

## 0.7.0
- Implementation of ```polymer_autonotify```
- ```init``` function on ```PolymerService``` class
- Breaking Changes
    * No need to call the constructor of a service.
    * One init function ```initPolymerApp()``` wrapper of:
        + ```initSerializer()```
        + ```initServices()```
        + ```initPolymer()```
    * Use of ```PolymerService.getService(String name)``` to get a service;

## 0.6.1
- fix minor issue on Service

## 0.6.0
- Breaking Changes:
    * commands:
        + ```new_application to app```
        + ```new_element``` to ```element```
        + ```new_route``` to ```route```
        + ```new_behavior``` to ```behavior```
        + ```new_service``` to ```service``` 
        + ```new_model``` to ```model```
        + ```new_config``` to ```config```
    * No more factory constructor for service class. Service class is now a class extending PolymerModel automatically instanciate and assignate to a global.
        + HttpService http_service = new HttpService();
        + It can be serialize and use in the dom.
- Add ```version``` command
- update to ```polymer 1.0.0-rc.13```
           
           

## 0.5.0
- Breaking Change (see [wiki](https://github.com/walletek/polymer_app/wiki))
- Add theme to root_element
- Add ```as_shell``` command
- Multiple Material design layout
    * nav-view
    * nav-header

## 0.4.1
- Add ```serve``` command (do pub get then pub serve)

## 0.4.0
- Breaking Change:
    * polymer_app cli with ```cupid```
    * new commands :
        + new_application
        + new_route
        + new_element
        + new_behavior
        + new_service
        + new_model

## 0.3.1
- Serialize Date

## 0.3.0
- Serializer (first version)
    * ```toJson, fromJson, toMap, fromMap, fromList```
    * Serializer in HttpService
- Use ```reflectable instead of mirror```

## 0.2.0
- New Route
    * No need to instanciate a new ```Page()```
    * Use of ```@PolymerRoute``` and ```PolymerRouterBehavior```

## 0.1.4
- fix route creation
- fix model creation
- fix material toolbar

## 0.1.2
- Clean some code
- Add github buttons

## 0.1.1
- Material Design Template for new app
- Add 'new config' command

## 0.1.0
- Refactor Manager
- Implement --output-folder option

## 0.0.7
- Implement 'polymer_app.json' config

## 0.0.6
- Solid base of tools

## 0.0.1

- Initial version