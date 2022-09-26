// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

@Timeout(Duration(seconds: 600))

import 'dart:io';
import 'package:text_analysis/text_analysis.dart';
import 'package:test/test.dart';
import 'data/terms.dart';

void main() {
  group('vocabulary', () {
//

    test('stem vocab', () async {
      final out = File('vocabulary.txt').openWrite();
      out.write('const vocabulary = [\n');
      // final analyzer = TextAnalyzer();
      for (var e in terms) {
        // final splitTerms = await analyzer.configuration.termFilter(term);
        e = e.stemPorter2();
        final entry = '"$e",\n';
        out.write(entry);
      }

      out.write('];\n');
      await out.close();
    });
  });
}
