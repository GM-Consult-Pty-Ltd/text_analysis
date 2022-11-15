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
      Iterable<Zone>? zones,
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
              tokenFilter: tokenFilter, zone: zone, nGramRange: nGramRange));
        }
      }
    }
    return tokens;
  }

  /// Private [Tokenizer] function implements [TextAnalyzer.tokenizer].
  Future<List<Token>> _tokenize(
    SourceText text, {
    Zone? zone,
    NGramRange? nGramRange,
    TokenFilter? tokenFilter,
  }) async {
    final tokens = _keyWordTokens(text, zone, nGramRange);
    final retval = tokens.toSet().toList()
      ..sort(((a, b) => a.termPosition.compareTo(b.termPosition)));
    return tokenFilter != null ? await tokenFilter(retval) : retval;
  }

  /// Private worker function.
  ///
  /// Splits the text into keywords, applies the termfilter to each word
  /// in the keyword and returns token(s) for each keyword.
  List<Token> _keyWordTokens(String text, Zone? zone, NGramRange? nGramRange) {
    final tokens = <Token>[];
    int position = 0;
    final keyWords = keywordExtractor(text, nGramRange: nGramRange);
    for (final keyWord in keyWords) {
      final List<String> tokenTerms = [];
      tokenTerms.addAll(termFilter(keyWord.join(' ').normalizeWhitespace()));
      for (var tokenTerm in tokenTerms) {
        tokenTerm = tokenTerm.normalizeWhitespace();
        if (tokenTerm.isNotEmpty) {
          final n = tokenTerm.splitAtWhiteSpace().length;
          if (nGramRange == null ||
              (n >= nGramRange.min && n <= nGramRange.max)) {
            final token = Token(tokenTerm, n, position, zone);
            tokens.add(token);
          }
        }
      }
      position = position + keyWord.length;
    }
    return tokens;
  }
}
