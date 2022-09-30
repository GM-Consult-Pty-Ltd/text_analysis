// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd
// All rights reserved

import 'package:text_analysis/src/_index.dart';
import 'package:porter_2_stemmer/porter_2_stemmer.dart';

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

  /// The default [TokenFilter] used by [TextTokenizer].
  ///
  /// Returns [tokens] with [Token.term] stemmed using the [Porter2Stemmer].
  static Future<List<Token>> defaultTokenFilter(List<Token> tokens) async =>
      tokens
          .map((e) => Token(e.term.stemPorter2(), e.termPosition, e.zone))
          .toList();

  /// Instantiates a const [TextTokenizerBase] instance.
  /// - [analyzer] is used by the [TextTokenizer] to tokenize source text
  ///   (default is [English.analyzer]); and
  /// - provide a custom [tokenFilter] if you want to manipulate tokens or
  ///   restrict tokenization to tokens that meet specific criteria (default is
  ///   [TextTokenizer.defaultTokenFilter], applies [Porter2Stemmer]).
  factory TextTokenizer(
          {TextAnalyzer analyzer = English.analyzer,
          TokenFilter tokenFilter = defaultTokenFilter}) =>
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

  /// Extracts tokens from [source] for use in full-text search queries and
  /// indexes.
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
      // only tokenize non-empty strings.
      if (term.isNotEmpty) {
        // apply the termFilter if it is not null
        final splitTerms = await analyzer.termFilter(term);
        for (var splitTerm in splitTerms) {
          final tokenTerm = splitTerm.trim();
          if (tokenTerm.isNotEmpty) {
            tokens.add(Token(splitTerm.trim(), position, zone));
          }
        }
      }
      // increment the index
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
