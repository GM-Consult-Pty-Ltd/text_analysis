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
      TokenFilter? tokenFilter,
      TokenizingStrategy strategy = TokenizingStrategy.terms}) async {
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
              zone: zone, nGramRange: nGramRange, strategy: strategy));
        }
      }
    }
    return tokens;
  }

  /// Private [Tokenizer] function implements [TextAnalyzer.tokenizer].
  Future<List<Token>> _tokenize(SourceText text,
      {NGramRange? nGramRange,
      Zone? zone,
      TokenFilter? tokenFilter,
      TokenizingStrategy strategy = TokenizingStrategy.terms}) async {
    List<Token> tokens = [];
    // add term tokens and n-gram tokens
    if (strategy != TokenizingStrategy.keyWords) {
      tokens.addAll(await _nGramAndTermTokens(
          text, _effectiveNGramRange(nGramRange, strategy), zone));
    }
    // add keyword tokens
    if (strategy == TokenizingStrategy.keyWords ||
        strategy == TokenizingStrategy.all) {
      final keywordTokens = _keyWordTokens(text, zone);
      final existingTerms = tokens.map((e) => e.term);
      tokens.addAll(_newKeywordTokens(existingTerms, keywordTokens));
    }
    // remove duplicate tokens
    tokens = _toOrderedSet(tokens);
    // apply the tokenFilter if it is not null and return the tokens collection
    return tokenFilter != null ? await tokenFilter(tokens) : tokens;
  }

  Iterable<Token> _newKeywordTokens(
          Iterable<String> existingTerms, Iterable<Token> keywordTokens) =>
      keywordTokens.where((e) => !existingTerms.contains(e.term));

  List<Token> _toOrderedSet(Iterable<Token> tokens) {
    final set = <String, Token>{};
    for (final e in tokens) {
      final key = '${e.term}_${e.termPosition}'.toLowerCase();
      set[key] = e;
    }
    final retVal = set.values.toList();
    retVal.sort(((a, b) => a.termPosition.compareTo(b.termPosition)));
    return retVal;
  }

  /// Private worker function.
  ///
  /// Splits the text into keywords, applies the termfilter to each word
  /// in the keyword and returns token(s) for each keyword.
  List<Token> _keyWordTokens(String text, Zone? zone) {
    final tokens = <Token>[];
    int position = 0;
    final keyWords = keywordExtractor(text);
    for (final keyWord in keyWords) {
      final List<String> tokenTerms = [];
      for (final term in keyWord) {
        final splitTerms = termFilter(term);
        final oldTerms = List<String>.from(tokenTerms);
        if (oldTerms.isEmpty) {
          oldTerms.add('');
        }
        tokenTerms.clear();
        for (final tokenTerm in oldTerms) {
          if (splitTerms.isNotEmpty) {
            for (var splitTerm in splitTerms) {
              tokenTerms
                  .add('$tokenTerm${tokenTerm.isEmpty ? '' : ' '}$splitTerm');
            }
          } else {
            if (tokenTerm.isNotEmpty) {
              tokenTerms.add(tokenTerm);
            }
          }
        }
      }
      for (var tokenTerm in tokenTerms) {
        tokenTerm = tokenTerm.trim().replaceAll(RegExp(r'\s+'), ' ');
        if (tokenTerm.isNotEmpty) {
          final n = tokenTerm.split(RegExp(r'\s+')).length;
          final token = Token(tokenTerm, n, position, zone);
          tokens.add(token);
        }
      }
      position = position + keyWord.length;
    }
    return tokens;
  }

  /// Private worker function.
  ///
  /// Splits the text into terms, applies the termfilter to the terms then
  /// generates n-grams from the terms.
  Future<List<Token>> _nGramAndTermTokens(
      String text, NGramRange nGramRange, Zone? zone) async {
    // initialize position counter
    int position = 0;
// perform the first punctuation and white-space split
    final terms = <String>[];
    final rawTerms = termSplitter(text.trim());
    for (var term in rawTerms) {
      term = term.trim();
      final exception =
          termExceptions[term] ?? termExceptions[characterFilter(term)];
      if (exception != null) {
        if (exception.isNotEmpty) {
          terms.add(exception);
        }
      } else {
        if (!stopWords.contains(term)) {
          term = characterFilter(term.trim());
          term =
              term.containsNonWordCharacters ? term : stemmer(lemmatizer(term));

          terms.add(term);
        }
      }
    }
    // initialize the tokens collection (return value)
    final tokens = <Token>[];
    // initialize a collection for previous terms to build n-grams from
    final nGramTerms = <List<String>>[];
    // iterate through the terms
    for (var term in terms) {
      // remove white-space at start and end of term
      final splitTerms = termFilter(term);
      if (splitTerms.isNotEmpty) {
        nGramTerms.add(splitTerms.toList());
        if (nGramTerms.length > nGramRange.max) {
          nGramTerms.removeAt(0);
        }
        tokens.addAll(_getNGrams(nGramTerms, nGramRange, position, zone));
      }
      position++;
    }
    return tokens;
  }

  /// Private worker function.
  ///
  /// Returns the effective n-gram range depending on the tokenizing strategy
  /// adopted.
  NGramRange _effectiveNGramRange(
      NGramRange? nGramRange, TokenizingStrategy strategy) {
    int max = 1;
    int min = 1;
    switch (strategy) {
      case TokenizingStrategy.all:
        max = nGramRange?.max ?? 2;
        break;
      case TokenizingStrategy.ngrams:
        max = nGramRange?.max ?? 2;
        min = nGramRange?.min ?? 1;
        break;
      default:
    }
    return NGramRange(min, max);
  }

  /// Private wrker function that pre-pends [words] to existing n-grams.
  static Iterable<List<String>> _prependWords(
      Iterable<List<String>> termNGrams, Iterable<String> words) {
    final nGrams = List<List<String>>.from(termNGrams);
    words = words.map((e) => e.trim()).where((element) => element.isNotEmpty);
    final retVal = <List<String>>[];
    if (nGrams.isEmpty) {
      retVal.addAll(words.map((e) => e.split(RegExp(r'\s+'))));
    }
    for (final word in words) {
      for (final nGram in nGrams) {
        final newNGram = word.split(RegExp(r'\s+')) + List<String>.from(nGram);
        retVal.add(newNGram);
      }
    }
    return retVal;
  }

  /// Private worker function.
  ///
  /// Returns a collection of tokens where the terms are n-grams built from
  /// the [nGramTerms].
  List<Token> _getNGrams(List<List<String>> nGramTerms, NGramRange nGramRange,
      int termPosition, Zone? zone) {
    if (nGramTerms.length > nGramRange.max) {
      nGramTerms = nGramTerms.sublist(nGramTerms.length - nGramRange.max);
    }
    if (nGramTerms.length < nGramRange.min) {
      return <Token>[];
    }
    final nGrams = <List<String>>[];
    var j = 0;
    for (var i = nGramTerms.length - 1; i >= 0; i--) {
      final param = <List<String>>[];
      param.addAll(nGrams
          .where((element) => element.length == j)
          .map((e) => List<String>.from(e)));
      final newNGrams = _prependWords(param, nGramTerms[i]);
      nGrams.addAll(newNGrams);
      j++;
    }
    final tokenGrams = nGrams.where((element) =>
        element.length >= nGramRange.min && element.length <= nGramRange.max);
    final tokens = <Token>[];
    for (final e in tokenGrams) {
      final n = e.length;
      final term = e.join(' ');
      tokens.add(Token(term, n, termPosition - n + 1, zone));
    }
    return tokens;
  }
}
