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
              tokenFilter: tokenFilter, zone: zone, nGramRange: nGramRange));
        }
      }
    }
    return tokens;
  }

  /// Private [Tokenizer] function implements [TextAnalyzer.tokenizer].
  Future<List<Token>> _tokenize(
    String text, {
    String? zone,
    NGramRange? nGramRange,
    TokenFilter? tokenFilter,
  }) async {
    final tokens = <Token>[];
    int position = 0;
    final phrases = await phraseSplitter(text, zone);
    await Future.forEach(phrases, (String phrase) async {
      final newTokens = _ngramTokens(phrase, position, zone, nGramRange);
      tokens.addAll(newTokens);
      await Future.forEach(newTokens, (Token token) async {
        if (termExpander != null) {
          final expanded = await termExpander!(token.term, zone);
          for (final et in expanded) {
            tokens.add(Token(et, et.termCount, token.termPosition, zone));
          }
        }
      });
      position = position + phrase.termCount;
    });
    return tokenFilter != null ? await tokenFilter(tokens) : tokens;
  }

  /// Returns an ordered collection of n-grams from the list of Strings.
  ///
  /// The n-gram lengths are limited by [range]. If range is NGramRange(1,1)
  /// the list will be returned as is.
  List<Token> _ngramTokens(
    String phrase,
    int position,
    String? zone,
    NGramRange? nGramRange,
  ) {
    // return empty list if the collection is empty
    if (phrase.isEmpty) return [];
    final range = nGramRange;
    if (range == null) {
      return [Token(phrase, phrase.termCount, position, zone)];
    } else {
      // var termCounter = 0;
      // initialize the return value collection
      final retVal = <Token>[];
      // initialize a rolling n-gram element word-list
      final nGramTerms = <String>[];
      final terms = phrase.splitAtWhitespace();
      // iterate through the terms
      for (var term in terms) {
        position++;
        // initialize the ngrams collection
        final nGrams = <List<String>>[];
        // remove white-space at start and end of term
        term = term.normalizeWhitespace();
        // ignore empty strings
        if (term.isNotEmpty) {
          nGramTerms.add(term);
          if (nGramTerms.length > range.max) {
            nGramTerms.removeAt(0);
          }
          var n = 0;
          for (var i = nGramTerms.length - 1; i >= 0; i--) {
            final param = <List<String>>[];
            param.addAll(nGrams
                .where((element) => element.length == n)
                .map((e) => List<String>.from(e)));
            final newNGrams = _prefixWordTo(param, nGramTerms[i]);
            nGrams.addAll(newNGrams);
            n++;
          }
        }
        final tokenGrams = nGrams.where((element) =>
            element.length >= range.min && element.length <= range.max);
        for (final e in tokenGrams) {
          final n = e.length;
          final termPosition = position - n;
          final nGram = e.join(' ').normalizeWhitespace();
          if (nGram.isNotEmpty) {
            retVal.add(Token(nGram, n, termPosition, zone));
          }
        }
      }
      return retVal;
    }
  }

  static Iterable<List<String>> _prefixWordTo(
      Iterable<List<String>> nkGrams, String word) {
    final nGrams = List<List<String>>.from(nkGrams);
    final retVal = <List<String>>[];
    if (nGrams.isEmpty) {
      retVal.add([word]);
    }
    for (final nGram in nGrams) {
      nGram.insert(0, word);
      retVal.add(nGram);
    }
    return retVal;
  }
}
