// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

part of '../latin_language_analyzer.dart';

abstract class _PhraseSplitter implements TextAnalyzer {
  //

  /// The [LatinLanguageAnalyzer] implementation of [termSplitter].
  ///
  /// Splits the [source] into phrases at all line endings and punctuation.
  /// Calls [termFilter] and [characterFilter] on each word in each phrase,
  /// further splitting the phrase into smaller phrases in the [termFilter]
  /// returns null.
  Future<List<String>> _splitToPhrases(String source, [String? zone]) async {
    final retVal = <String>[];
    final split = source
        .normalizeWhitespace()
        .split(RegExp(LatinLanguageAnalyzer.rPhraseDelimiterSelector));
    await Future.forEach(split, (String e) async {
      if (e.isNotEmpty) {
        final terms = e.splitAtWhitespace();
        final buffer = StringBuffer();
        await Future.forEach(terms, (String t) async {
          var filtered = await characterFilter(t.trim(), zone);
          filtered =
              filtered == null ? filtered : await termFilter(filtered, zone);
          buffer.write(filtered != null ? ' $filtered' : '%chunk%');
        });
        final term = buffer.toString().normalizeWhitespace();
        if (term.isNotEmpty) {
          final words = term.split('%chunk%')
            ..removeWhere((element) => e.trim().isEmpty);
          for (String e in words) {
            e = e.normalizeWhitespace();
            if (e.isNotEmpty) {
              retVal.add(e);
            }
          }
        }
      }
    });

    return retVal;
  }
}
