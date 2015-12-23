/**
 * Created by lejard_h on 23/12/15.
 */

///
/// Run this script with pub run:
///
///     pub run polymer_app:new_app app_name [-o output_dir]
///
library polymer.bin.new_element;

import 'dart:io';
import 'package:args/args.dart';
import 'templates.dart';
import 'package:ansicolor/ansicolor.dart';

final AnsiPen green = new AnsiPen()..green(bold: true);

Directory createDirectory(String path) {
  print("Creating '${green(path)}' directory.");
  Directory dir = new Directory(path);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
  return dir;
}

File createFile(String path) {
  print("Creating '${green(path)}' file.");
  File file = new File(path);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
  return file;
}

String getAppName(ArgResults results, ArgParser parser) {
  String appName;
  if (results.rest == null || results.rest.isEmpty) {
    print('No app_ame specified');
    usage(parser);
    exit(1);
  }
  appName = results.rest[0];
  return appName;
}

Directory getDirectory(ArgResults results, ArgParser parser) {
  String outputDir = results['output-dir'];

  Directory dir = createDirectory(outputDir != null ? outputDir : ".");
  if (dir.listSync().isNotEmpty) {
    print('Directory must be empty.');
    usage(parser);
    exit(1);
  }
  return dir;
}

Directory createWebDirectory(Directory root, String appName) {
  print("");
  Directory webDirectory =
      createDirectory("${root.resolveSymbolicLinksSync()}/web");

  File indexHtmlFile =
      createFile("${webDirectory.resolveSymbolicLinksSync()}/index.html");
  indexHtmlFile.createSync(recursive: true);
  indexHtmlFile.writeAsStringSync(indexHtmlContent(appName));

  File indexDartFile =
      createFile("${webDirectory.resolveSymbolicLinksSync()}/index.dart");
  indexDartFile.createSync(recursive: true);
  indexDartFile.writeAsStringSync(indexDartContent(appName));

  return webDirectory;
}

Directory createModelsDirectory(Directory root, String appName) {
  Directory modelsDirectory = createDirectory("${root.resolveSymbolicLinksSync()}/models");
  File file = createFile("${modelsDirectory.resolveSymbolicLinksSync()}/models.dart");
  file.writeAsStringSync(modelsLibContent(appName));
  return modelsDirectory;
}

Directory createBehaviorsDirectory(Directory root, String appName) {
  Directory behaviorsDirectory = createDirectory("${root.resolveSymbolicLinksSync()}/behaviors");
  File file = createFile("${behaviorsDirectory.resolveSymbolicLinksSync()}/behaviors.dart");
  file.writeAsStringSync(behaviorsLibContent(appName));
  return behaviorsDirectory;
}

Directory createServicesDirectory(Directory root, String appName) {
  Directory servicesDirectory = createDirectory("${root.resolveSymbolicLinksSync()}/services");
  File file = createFile("${servicesDirectory.resolveSymbolicLinksSync()}/services.dart");
  file.writeAsStringSync(servicesLibContent(appName));
  return servicesDirectory;
}

Directory createElementsDirectory(Directory root, String appName) {
  Directory elementsDirectory = createDirectory("${root.resolveSymbolicLinksSync()}/elements");
  File file = createFile("${elementsDirectory.resolveSymbolicLinksSync()}/elements.dart");
  file.writeAsStringSync(elementsLibContent(appName));
  return elementsDirectory;
}


Directory createLibDirectory(Directory root, String appName) {
  print("");
  Directory libDirectory = createDirectory("${root.resolveSymbolicLinksSync()}/lib");

  createModelsDirectory(libDirectory, appName);
  createServicesDirectory(libDirectory, appName);
  createBehaviorsDirectory(libDirectory, appName);
  createElementsDirectory(libDirectory, appName);

  File appNameFile = createFile("${libDirectory.resolveSymbolicLinksSync()}/$appName.dart");
  appNameFile.createSync(recursive: true);
  appNameFile.writeAsStringSync(appLibraryContent(appName));

  return libDirectory;
}

createPubspec(Directory directory, String appName) {
  print("");
  File pubspecFile = createFile("${directory.resolveSymbolicLinksSync()}/pubspec.yaml");
  pubspecFile.createSync(recursive: true);
  pubspecFile.writeAsStringSync(pubspecContent(appName));
}

void main(List<String> args) {
  ArgParser parser = new ArgParser(allowTrailingOptions: true);

  parser.addOption('output-dir', abbr: 'o', help: 'Output directory');
  parser.addFlag('help', abbr: 'h');

  ArgResults results = parser.parse(args);

  if (results['help']) {
    usage(parser);
    return;
  }

  String appName = getAppName(results, parser);
  print("Creating '${green(appName)}' application");

  Directory directory = getDirectory(results, parser);

  createPubspec(directory, appName);
  createLibDirectory(directory, appName);
  createWebDirectory(directory, appName);

  print("\npub get");
  Process
      .run('pub', ['get'],
          runInShell: true,
          workingDirectory: directory.resolveSymbolicLinksSync())
      .then((ProcessResult result) {
    print(result.stdout);
  });
}

void usage(ArgParser parser) {
  print('pub run polymer_app:new_app [-o output_dir]'
      'app_name');
  print(parser.usage);
}
