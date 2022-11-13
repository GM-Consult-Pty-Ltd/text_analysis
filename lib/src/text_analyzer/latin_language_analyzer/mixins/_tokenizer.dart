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
      StringModifier? reCase,
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
              tokenFilter: tokenFilter,
              reCase: reCase,
              zone: zone,
              nGramRange: nGramRange));
        }
      }
    }
    return tokens;
  }

  /// Private [Tokenizer] function implements [TextAnalyzer.tokenizer].
  Future<List<Token>> _tokenize(SourceText text,
      {NGramRange? nGramRange,
      Zone? zone,
      StringModifier? reCase,
      TokenFilter? tokenFilter,      
      }) async {
    List<Token> tokens = _keyWordTokens(text, zone, nGramRange);
    // add term tokens and n-gram tokens
    // if (strategy != TokenizingStrategy.keyWords) {
    //   tokens.addAll(await _nGramAndTermTokens(
    //       text, _effectiveNGramRange(nGramRange, strategy), zone));
    // }
    // add keyword tokens
    // if (strategy == TokenizingStrategy.keyWords ||
    //     strategy == TokenizingStrategy.all) {
    // final keywordTokens = _keyWordTokens(text, zone);
    // final existingTerms = tokens.map((e) => e.term);
    // tokens.addAll(_newKeywordTokens(existingTerms, keywordTokens));
    // }
    // remove duplicate tokens
    tokens = _toOrderedSet(tokens, reCase);
    // apply the tokenFilter if it is not null and return the tokens collection
    return tokenFilter != null ? await tokenFilter(tokens) : tokens;
  }

  // Iterable<Token> _newKeywordTokens(
  //         Iterable<String> existingTerms, Iterable<Token> keywordTokens) =>
  //     keywordTokens.where((e) => !existingTerms.contains(e.term));

  List<Token> _toOrderedSet(
    Iterable<Token> tokens,
    StringModifier? reCase,
  ) {
    reCase = reCase ?? (term) => term;
    final set = <String, Token>{};
    for (final e in tokens) {
      final key = '${e.term}_${e.termPosition}'.toLowerCase();
      set[key] = Token(reCase(e.term), e.n, e.termPosition, e.zone);
    }
    final retVal = set.values.toList();
    retVal.sort(((a, b) => a.termPosition.compareTo(b.termPosition)));
    return retVal;
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
      tokenTerms.addAll(termFilter(
          keyWord.join(' ').trim().replaceAll(RegExp(r'\s+'), ' ').trim()));
      for (var tokenTerm in tokenTerms) {
        tokenTerm = tokenTerm.trim().replaceAll(RegExp(r'\s+'), ' ');
        if (tokenTerm.isNotEmpty) {
          final n = tokenTerm.split(RegExp(r'\s+')).length;
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
