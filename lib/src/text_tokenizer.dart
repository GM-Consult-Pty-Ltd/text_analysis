// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd
// All rights reserved

import '_index.dart';

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
  static const english = _TextTokenizerImpl(English.analyzer, null);

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
  /// Optional parameter [zone] is the name of the zone in a document in
  /// which the term is located.
  ///
  /// Returns a List<[Token]>.
  Future<List<Token>> tokenize(SourceText source, [Zone? zone]);

  /// Extracts tokens from the [zones] in a JSON [document] for use in
  /// full-text search queries and indexes.
  ///
  /// The required parameter [zones] is the collection of the names of the
  /// zones in [document] that are to be tokenized.
  ///
  /// Returns a List<[Token]>.
  Future<List<Token>> tokenizeJson(Map<String, dynamic> document,
      [Iterable<Zone>? zones]);
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
      [Iterable<Zone>? zones]) async {
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
          tokens.addAll(await tokenize(source, zone));
        }
      }
    }
    return tokens;
  }

  @override
  Future<List<Token>> tokenize(SourceText text, [Zone? zone]) async {
    int position = 0;
// perform the first punctuation and white-space split
    final terms = analyzer.termSplitter(text.trim());
    // initialize the tokens collection (return value)
    final tokens = <Token>[];
    // iterate through the terms
    await Future.forEach(terms, (String term) async {
      // remove white-space at start and end of term
      term = term.trim();
      final splitTerms = await analyzer.termFilter(term);
      for (var splitTerm in splitTerms) {
        tokens.add(Token(splitTerm.trim(), position, zone));
      }
      position++;
    });
    // apply the tokenFilter if it is not null and return the tokens collection
    return tokenFilter != null ? await tokenFilter!(tokens) : tokens;
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
