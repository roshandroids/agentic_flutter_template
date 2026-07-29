// Reads template.config.yaml so scripts/*.sh never hardcode what the config
// already states. See docs/reference/PROJECT_CONFIGURATION.md.
//
// Usage:
//   dart run bin/config.dart get <dotted.path>          -> scalar value
//   dart run bin/config.dart list <dotted.path>          -> one item per line
//   dart run bin/config.dart packages                    -> "name path layer" per line
import 'dart:io';

import 'package:yaml/yaml.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('usage: config.dart <get|list|packages> [dotted.path]');
    exit(64);
  }

  final configFile = _findConfigFile();
  final doc = loadYaml(configFile.readAsStringSync()) as YamlMap;

  switch (args.first) {
    case 'get':
      _printScalar(_resolve(doc, args[1]));
    case 'list':
      _printList(_resolve(doc, args[1]));
    case 'packages':
      _printPackages(doc);
    default:
      stderr.writeln('unknown command: ${args.first}');
      exit(64);
  }
}

File _findConfigFile() {
  var dir = Directory.current;
  while (true) {
    final candidate = File('${dir.path}/template.config.yaml');
    if (candidate.existsSync()) return candidate;
    final parent = dir.parent;
    if (parent.path == dir.path) {
      stderr.writeln(
        'template.config.yaml not found above ${Directory.current.path}',
      );
      exit(1);
    }
    dir = parent;
  }
}

dynamic _resolve(dynamic node, String dottedPath) {
  var current = node;
  for (final segment in dottedPath.split('.')) {
    if (current is YamlMap && current.containsKey(segment)) {
      current = current[segment];
    } else {
      stderr.writeln('path not found: $dottedPath');
      exit(1);
    }
  }
  return current;
}

void _printScalar(dynamic value) {
  stdout.writeln(value.toString());
}

void _printList(dynamic value) {
  if (value is! YamlList) {
    stderr.writeln('value is not a list');
    exit(1);
  }
  for (final item in value) {
    stdout.writeln(item.toString());
  }
}

void _printPackages(YamlMap doc) {
  final packages = doc['packages'];
  if (packages is! YamlList) {
    stderr.writeln('no packages: list in config');
    exit(1);
  }
  for (final entry in packages) {
    final map = entry as YamlMap;
    stdout.writeln('${map['name']} ${map['path']} ${map['layer']}');
  }
}
