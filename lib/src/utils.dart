/**
 * Created by lejard_h on 23/12/15.
 */

library polymer_app.utils;

String green(String value) => "<green>$value</green>";
String white(String value) => "<white>$value</white>";
String red(String value) => "<red>$value</red>";

toSnakeCase(String name) => name
    ?.replaceAll("-", "_")
    ?.replaceAll(" ", "_")
    ?.replaceAllMapped(new RegExp('(?!^)([A-Z])'), (Match g) => "_${g[1]}")
    ?.toLowerCase();

toLispCase(String name) => name
      ?.replaceAll("_", "-")
      ?.replaceAll(" ", "-")
      ?.replaceAllMapped(new RegExp('(?!^)([A-Z])'), (Match g) => "-${g[1]}")
      ?.toLowerCase();

toCamelCase(String str) => toLispCase(str)
    ?.split('-')
    ?.map((e) => e[0].toUpperCase() + e.substring(1))
    ?.join('');
