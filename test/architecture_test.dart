import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Architecture Dependencies', () {
    // Recursively get all .dart files in a directory
    List<File> getDartFiles(String path) {
      final dir = Directory(path);
      if (!dir.existsSync()) return [];
      return dir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList();
    }

    // Extract all package:habits_flow/ imports from a file
    List<String> getInternalImports(File file) {
      final lines = file.readAsLinesSync();
      final imports = <String>[];
      for (final line in lines) {
        final trimmed = line.trim();
        // Support both single and double quotes
        if (trimmed.startsWith('import ') && trimmed.contains('package:habits_flow/')) {
          final match = RegExp(r"package:habits_flow/([^'""" + r'"]+)').firstMatch(trimmed);
          if (match != null) {
            imports.add(match.group(1)!);
          }
        }
      }
      return imports;
    }

    test('Domain layer must not import main, ui, or data', () {
      final domainFiles = getDartFiles('lib/domain');
      
      for (final file in domainFiles) {
        final imports = getInternalImports(file);
        for (final imp in imports) {
          final topLevelDir = imp.split('/').first;
          expect(
            ['main', 'ui', 'data'].contains(topLevelDir),
            isFalse,
            reason: 'File ${file.path} violates architecture rules by importing $imp. Domain layer cannot import main, ui, or data.',
          );
        }
      }
    });

    test('UI layer must only import ui, domain, or core', () {
      final uiFiles = getDartFiles('lib/ui');
      
      for (final file in uiFiles) {
        final imports = getInternalImports(file);
        for (final imp in imports) {
          final topLevelDir = imp.split('/').first;
          expect(
            ['ui', 'domain', 'core'].contains(topLevelDir),
            isTrue,
            reason: 'File ${file.path} violates architecture rules by importing $imp. UI layer can only import ui, domain, or core.',
          );
        }
      }
    });

    test('Data layer must only import data, domain, or core', () {
      final dataFiles = getDartFiles('lib/data');
      
      for (final file in dataFiles) {
        final imports = getInternalImports(file);
        for (final imp in imports) {
          final topLevelDir = imp.split('/').first;
          expect(
            ['data', 'domain', 'core'].contains(topLevelDir),
            isTrue,
            reason: 'File ${file.path} violates architecture rules by importing $imp. Data layer can only import data, domain, or core.',
          );
        }
      }
    });
  });
}
