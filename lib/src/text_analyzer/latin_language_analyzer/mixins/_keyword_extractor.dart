// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

part of '../latin_language_analyzer.dart';

abstract class _KeyWordExtractor implements TextAnalyzer {
  //

  List<List<String>> _extractKeywords(String source, {NGramRange? nGramRange}) {
    final retVal = <List<String>>[];
    final keyWordSet = <String>{};
    final phrases = _textToChunks(source);
    for (var e in phrases) {
      final phrase = <String>[];
      e = e.stripPunctuation();
      e = termExceptions[e] ?? e;
      if (e.isNotEmpty) {
        final terms = e.splitAtWhiteSpace();
        for (var w in terms) {
          w = w.trim();
          if (w.length > 1) {
            final exception = termExceptions[w];
            final alt = exception;
            if (exception != null) {
              final words = exception.split(RegExp(r'\s+'));
              w = words.join(' ');
            } else {
              w = (stemmer(w)).trim();
              w = alt ?? w;
            }
            if (w.isNotEmpty) {
              phrase.add(w);
            } else {
              _addPhraseToKeywords(phrase, keyWordSet, retVal, nGramRange);
              phrase.clear();
            }
          }
        }
        _addPhraseToKeywords(phrase, keyWordSet, retVal, nGramRange);
      }
    }

    return retVal;
  }

  void _addPhraseToKeywords(List<String> phrase, Set<String> keyWordSet,
      List<List<String>> retVal, NGramRange? range) {
    var keyWord = phrase.join(' ').replaceAll(RegExp(r'\s+'), ' ');
    keyWord = termExceptions[keyWord] ?? keyWord;
    phrase = keyWord.split(RegExp(r'\s+'))
      ..removeWhere((element) => element.trim().isEmpty);
    if (phrase.isNotEmpty) {
      if (!keyWordSet.contains(keyWord)) {
        if (range == null) {
          final tphrase = List<String>.from(phrase)
            ..removeWhere((element) => element.trim().isEmpty);
          if (tphrase.isNotEmpty) {
            retVal.add(List<String>.from(phrase));
            keyWordSet.add(keyWord);
          }
        } else {
          final nGrams =
              phrase.nGrams(range).map((e) => e.split(RegExp(r'\s+')));
          for (var nGram in nGrams) {
            keyWord = nGram.join(' ').replaceAll(RegExp(r'\s+'), ' ');
            keyWord = termExceptions[keyWord] ?? keyWord;
            if (!keyWordSet.contains(keyWord)) {
              final nphrase = keyWord.split(RegExp(r'\s+'))
                ..removeWhere((element) => element.trim().isEmpty);
              if (nphrase.isNotEmpty) {
                retVal.add(nphrase);
                keyWordSet.add(keyWord);
              }
            }
          }
        }
      }
    }
  }

  /// Splits the String into phrases at phrase delimiters:
  /// - punctuation not part of abbreviations or numbers;
  /// - line endings;
  /// - phrase delimiters such as double quotes, brackets and carets.
  List<String> _textToChunks(String source) {
    final retVal = <String>[];
    final split = source
        .trim()
        .split(RegExp(_LatinLanguageConstants.rPhraseDelimiterSelector));
    for (final e in split) {
      final phrase = e.replaceAll(RegExp(r'\s+'), ' ').trim().splitMapJoin(
        RegExp(r'\s+'),
        onNonMatch: (p0) {
          p0 = characterFilter(p0.trim());
          return stopWords.contains(p0) ? '%chunk%' : p0;
        },
      );
      final phrases =
          phrase.split('%chunk%').map((e) => termExceptions[e] ?? e).toList();
      phrases.removeWhere((element) => element.trim().isEmpty);
      if (phrases.isNotEmpty) {
        retVal.addAll(phrases);
      }
    }
    return retVal;
  }
}
