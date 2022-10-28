// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

import 'package:text_analysis/type_definitions.dart';
import 'package:text_analysis/text_analysis.dart';

/// Interface for a text analyser class that extracts tokens from text for use
/// in full-text search queries and indexes:
/// - [analyzer] is a [TextAnalyzer] used by the
///   [TextTokenizer] to tokenize source text; and
/// - provide a [tokenFilter] if you want to manipulate tokens or restrict
///   tokenization to tokens that meet criteria for either index or count; and
/// - the [tokenize] function tokenizes source text using the [analyzer]
///   and then manipulates the output by applying [tokenFilter]; and
/// - the [tokenizeJson] function extracts tokens from the zones in a JSON
///   document.
abstract class TextTokenizer {
  //

  /// Returns a static const [TextTokenizer] using the [English] analyzer.
  static const english = _TextTokenizerImpl(English(), null);

  /// Instantiates a const [TextTokenizerBase] instance.
  /// - [analyzer] is used by the [TextTokenizer] to tokenize source text
  ///   (default is [English.analyzer]); and
  /// - provide a custom [tokenFilter] if you want to manipulate tokens or
  ///   restrict tokenization to tokens that meet specific criteria.
  factory TextTokenizer(
          {required TextAnalyzer analyzer, TokenFilter? tokenFilter}) =>
      _TextTokenizerImpl(analyzer, tokenFilter);

  // /// Splits the [source] into paragraphs at line ending marks.
  // List<String> paragraphs(SourceText source);

  // /// Splits the [source] into sentences at sentence ending punctuation.
  // List<String> sentences(SourceText source);

  /// The [TextAnalyzer] used by the [TextTokenizer].
  TextAnalyzer get analyzer;

  /// A filter that returns a subset of tokens.
  ///
  /// Provide a [tokenFilter] if you want to manipulate tokens or restrict
  /// tokenization to tokens that meet criteria for either index or count.
  TokenFilter? get tokenFilter;

  /// Extracts one or more tokens from [source] for use in full-text search
  /// queries and indexes.
  ///
  /// - [nGramRange] is the range of N-gram lengths to generate; and
  /// - [zone] is the name of the zone in a document in which the term is
  ///   located.
  ///
  /// Returns a List<[Token]>.
  Future<List<Token>> tokenize(SourceText source,
      {NGramRange nGramRange = const NGramRange(1, 1),
      Zone? zone,
      TokenizingStrategy strategy = TokenizingStrategy.terms});

  /// Extracts tokens from the [zones] in a JSON [document] for use in
  /// full-text search queries and indexes.
  ///
  /// - [nGramRange] is the range of N-gram lengths to generate; and
  /// - [zones] is the collection of the names of the zones in [document] that
  ///   are to be tokenized.
  ///
  /// Returns a List<[Token]>.
  Future<List<Token>> tokenizeJson(Map<String, dynamic> document,
      {NGramRange nGramRange = const NGramRange(1, 1),
      Iterable<Zone>? zones,
      TokenizingStrategy strategy = TokenizingStrategy.terms});
}

/// A [TextTokenizer] implementation that mixes in [TextTokenizerMixin], which
/// implements [TextTokenizer.tokenize] and [TextTokenizer.tokenizeJson].
abstract class TextTokenizerBase with TextTokenizerMixin {
  //

  /// Instantiates a const [TextTokenizerBase] instance.
  const TextTokenizerBase();
}

/// A mixin class that implements [TextTokenizer.tokenize] and
///  [TextTokenizer.tokenizeJson].
abstract class TextTokenizerMixin implements TextTokenizer {
  //

  @override
  Future<List<Token>> tokenizeJson(Map<String, dynamic> document,
      {NGramRange? nGramRange,
      Iterable<Zone>? zones,
      TokenizingStrategy strategy = TokenizingStrategy.terms}) async {
    final tokens = <Token>[];
    if (zones == null || zones.isEmpty) {
      zones = document.keys;
    }
    zones = zones.toSet();
    for (final zone in zones) {
      final value = document[zone];
      if (value != null) {
        final source = value.toString();
        if (source.isNotEmpty) {
          tokens.addAll(await tokenize(source,
              zone: zone, nGramRange: nGramRange, strategy: strategy));
        }
      }
    }
    return tokens;
  }

  @override
  Future<List<Token>> tokenize(SourceText text,
      {NGramRange? nGramRange,
      Zone? zone,
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
    return tokenFilter != null ? await tokenFilter!(tokens) : tokens;
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
    final keyWords = analyzer.keywordExtractor(text);
    for (final keyWord in keyWords) {
      final List<String> tokenTerms = [];
      for (final term in keyWord) {
        final splitTerms = analyzer.termFilter(term);
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
          final n = tokenTerm.split(' ').length;
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
    final terms = analyzer.termSplitter(text.trim());
    // initialize the tokens collection (return value)
    final tokens = <Token>[];
    // initialize a collection for previous terms to build n-grams from
    final nGramTerms = <List<String>>[];
    // iterate through the terms
    for (var term in terms) {
      // remove white-space at start and end of term
      term = term.trim();
      final splitTerms = analyzer.termFilter(term);
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
      retVal.addAll(words.map((e) => e.split(' ')));
    }
    for (final word in words) {
      for (final nGram in nGrams) {
        final newNGram = word.split(' ') + List<String>.from(nGram);
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
      tokens.add(Token(term, n, termPosition - n, zone));
    }
    return tokens;
  }
}

/// A [TextTokenizer] implementation that extracts tokens from text for use
/// in full-text search queries and indexes:
/// - [analyzer] is used by the [TextTokenizer] to tokenize source text
///   (default is [English.analyzer]); and
/// - provide a custom [tokenFilter] if you want to manipulate tokens or
///   restrict tokenization to tokens that meet specific criteria (default is
///   [TextTokenizer.defaultTokenFilter], applies [Porter2Stemmer]); and
/// - the [tokenize] function tokenizes source text using the [analyzer]
///   and then manipulates the output by applying [tokenFilter]; and
/// - the [tokenizeJson] function extracts tokens from the zones in a JSON
///   document.
class _TextTokenizerImpl with TextTokenizerMixin {
  //

  /// Instantiates a const [TextTokenizerBase] instance.
  /// - [analyzer] is used by the [TextTokenizer] to tokenize source text
  ///   (default is [English.analyzer]); and
  /// - provide a custom [tokenFilter] if you want to manipulate tokens or
  ///   restrict tokenization to tokens that meet specific criteria (default is
  ///   [TextTokenizer.defaultTokenFilter], applies [Porter2Stemmer]).
  const _TextTokenizerImpl(this.analyzer, this.tokenFilter);

  @override
  final TokenFilter? tokenFilter;

  @override
  final TextAnalyzer analyzer;

  // @override
  // List<String> paragraphs(SourceText source) =>
  //     analyzer.paragraphSplitter(source);

  // @override
  // List<String> sentences(SourceText source) =>
  //     analyzer.sentenceSplitter(source);
}
