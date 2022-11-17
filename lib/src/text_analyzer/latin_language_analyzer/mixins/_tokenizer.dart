// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

part of '../latin_language_analyzer.dart';

/// A mixin class that implements [TextAnalyzer.tokenize] and
/// [TextAnalyzer.tokenizeJson].
abstract class _Tokenizer implements TextAnalyzer {
  //

  /// Private [JsonTokenizer] function implements [TextAnalyzer.jsonTokenizer].
  Future<List<Token>> _tokenizeJson(Map<String, dynamic> document,
      {NGramRange? nGramRange,
      bool preserveCase = false,
      Iterable<String>? zones,
      TokenFilter? tokenFilter}) async {
    final tokens = <Token>[];
    zones ??= document.keys;
    zones = zones.toSet();
    for (final zone in zones) {
      final value = document[zone];
      if (value != null) {
        final source = value.toString();
        if (source.isNotEmpty) {
          tokens.addAll(await _tokenize(source,
              preserveCase: preserveCase,
              tokenFilter: tokenFilter,
              zone: zone,
              nGramRange: nGramRange));
        }
      }
    }
    return tokens;
  }

  /// Private [Tokenizer] function implements [TextAnalyzer.tokenizer].
  Future<List<Token>> _tokenize(
    String text, {
    String? zone,
    bool preserveCase = false,
    NGramRange? nGramRange,
    TokenFilter? tokenFilter,
  }) async {
    final tokens = <Token>[];
    int position = 0;
    final phrases = await phraseSplitter(text, zone);
    await Future.forEach(phrases, (String e) async {
      final ngrams =
          (nGramRange == null ? [e] : nGrammer(e, nGramRange)).toSet();
      await Future.forEach(ngrams, (String term) async {
        tokens.add(Token(preserveCase ? term : term.toLowerCase(),
            term.termCount, position, zone));
        if (termExpander != null) {
          final expanded = await termExpander!(term, zone);
          for (final et in expanded) {
            tokens.add(Token(preserveCase ? et : et.toLowerCase(), et.termCount,
                position, zone));
          }
        }
      });
      position = position + e.termCount;
    });
    return tokenFilter != null ? await tokenFilter(tokens) : tokens;
  }
}
