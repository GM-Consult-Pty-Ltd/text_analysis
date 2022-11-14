// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

part of '../latin_language_analyzer.dart';

abstract class _KeyWordExtractor implements TextAnalyzer {
  //

  List<List<String>> _extractKeywords(String source,
      {NGramRange? nGramRange}) {    
    final retVal = <List<String>>[];
    final keyWordSet = <String>{};
    final phrases = _textToChunks(source, reCase);
    for (var e in phrases) {
      final phrase = <String>[];
      e = termExceptions[e] ??
          termExceptions[reCase(e)] ??
          termExceptions[characterFilter(e)] ??
          termExceptions[reCase(characterFilter(e))] ??
          characterFilter(e);
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
    for (final e in retVal) {
      e.removeWhere((element) => element.trim().isEmpty);
    }
    retVal.removeWhere((element) => element.isEmpty);
    return retVal;
  }

  void _addPhraseToKeywords(List<String> phrase, Set<String> keyWordSet,
      List<List<String>> retVal, NGramRange? range) {
    var keyWord = phrase.join(' ').replaceAll(RegExp(r'\s+'), ' ');
    keyWord = termExceptions[keyWord] ?? keyWord;
    if (keyWord.isNotEmpty) {
      phrase = keyWord.split(RegExp(r'\s+'))
        ..removeWhere((element) => element.trim().isEmpty);
      if (phrase.isNotEmpty) {
        if (range == null) {
          final tphrase = List<String>.from(phrase)
            ..removeWhere((element) => element.trim().isEmpty);
          if (tphrase.isNotEmpty) {
            keyWord = phrase.join(' ');
            if (keyWord.isNotEmpty && keyWordSet.add(keyWord)) {
              retVal.add(List<String>.from(phrase));
              if (keyWord.contains('-')) {
                final unHyphenated =
                    keyWord.replaceAll('-', '').normalizeWhitespace();
                if (unHyphenated.isNotEmpty && keyWordSet.add(unHyphenated)) {
                  retVal.add(unHyphenated.splitAtWhiteSpace());
                }
                final spaceHyphenated =
                    keyWord.replaceAll('-', ' ').normalizeWhitespace();
                if (spaceHyphenated.isNotEmpty &&
                    keyWordSet.add(spaceHyphenated)) {
                  retVal.add(spaceHyphenated.splitAtWhiteSpace());
                }
              }
            }
          }
        } else {
          final nGrams =
              phrase.nGrams(range).map((e) => e.split(RegExp(r'\s+')));
          for (var nGram in nGrams) {
            keyWord = nGram.join(' ').normalizeWhitespace();
            keyWord = termExceptions[keyWord] ?? keyWord;
            if (keyWord.isNotEmpty && keyWordSet.add(keyWord)) {
              final nphrase = keyWord.splitAtWhiteSpace();
              if (nphrase.isNotEmpty) {
                retVal.add(nphrase);
                if (LatinLanguageAnalyzer.isHyphenated(keyWord)) {
                  final unHyphenated =
                      LatinLanguageAnalyzer.replaceHyphens(keyWord, '');
                  if (unHyphenated.isNotEmpty && keyWordSet.add(unHyphenated)) {
                    retVal.add(unHyphenated.splitAtWhiteSpace());
                  }
                  final spaceHyphenated =
                      LatinLanguageAnalyzer.replaceHyphens(keyWord, ' ');
                  if (spaceHyphenated.isNotEmpty &&
                      keyWordSet.add(spaceHyphenated)) {
                    retVal.add(spaceHyphenated.splitAtWhiteSpace());
                  }
                }
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
  List<String> _textToChunks(String source, TermModifier reCase) {
    final retVal = <String>[];
    final split = source
        .normalizeWhitespace()
        .split(RegExp(LatinLanguageAnalyzer.rPhraseDelimiterSelector));
    for (final e in split) {
      final phrase = e.normalizeWhitespace().splitMapJoin(
        RegExp(r'\s+'),
        onNonMatch: (p0) {
          p0 = characterFilter(p0.trim()).normalizeWhitespace();
          return p0.isEmpty
              ? p0
              : isStopWord(p0)
                  ? '%chunk%'
                  : reCase(p0);
        },
      );
      final phrases = phrase.split('%chunk%').map((e) {
        e = e.normalizeWhitespace();
        return termExceptions[e] ?? e;
      }).toList();
      phrases.removeWhere((element) => element.trim().isEmpty);
      if (phrases.isNotEmpty) {
        retVal.addAll(phrases);
      }
    }
    return retVal;
  }
}
