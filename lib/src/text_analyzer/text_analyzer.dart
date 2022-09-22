// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd
// All rights reserved

import 'package:text_analysis/text_analysis.dart';

/// Interface for a text analyser class that extracts tokens from text for use
/// in full-text search queries and indexes:
/// - [configuration] is a [TextAnalyzerConfiguration] used by the
///   [ITextAnalyzer] to tokenize source text; and
/// - provide a [tokenFilter] if you want to manipulate tokens or restrict
///   tokenization to tokens that meet criteria for either index or count; and
/// - the [tokenize] function tokenizes source text using the [configuration]
///   and then manipulates the output by applying [tokenFilter]; and
/// - the [tokenizeJson] function extracts tokens from the zones in a JSON
///   document.
abstract class ITextAnalyzer {
  //

  /// The [TextAnalyzerConfiguration] used by the [ITextAnalyzer].
  TextAnalyzerConfiguration get configuration;

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

/// A [ITextAnalyzer] implementation that extracts tokens from text for use
/// in full-text search queries and indexes:
/// - [configuration] is used by the [TextAnalyzer] to tokenize source text
///   (default is [English.configuration]); and
/// - provide a custom [tokenFilter] if you want to manipulate tokens or
///   restrict tokenization to tokens that meet specific criteria (default is
///   [TextAnalyzer.defaultTokenFilter], applies [Porter2Stemmer]); and
/// - the [tokenize] function tokenizes source text using the [configuration]
///   and then manipulates the output by applying [tokenFilter]; and
/// - the [tokenizeJson] function extracts tokens from the zones in a JSON
///   document.
abstract class TextAnalyzerBase implements ITextAnalyzer {
  //

  /// Instantiates a const [TextAnalyzerBase] instance.
  const TextAnalyzerBase();

  @override
  Future<List<Token>> tokenizeJson(Map<String, dynamic> document,
      [Iterable<Zone>? zones]) async {
    final tokens = <Token>[];
    if (zones == null || zones.isEmpty) {
      final valueBuilder = StringBuffer();
      for (final fieldValue in document.values) {
        valueBuilder.writeln(fieldValue.toString());
      }
      final value = valueBuilder.toString();
      final source = value.toString();
      if (source.isNotEmpty) {
        tokens.addAll(await tokenize(source));
      }
    } else {
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
    }
    return tokens;
  }

  @override
  Future<List<Token>> tokenize(SourceText text, [Zone? zone]) async {
    int position = 0;
// perform the first punctuation and white-space split
    final terms = configuration.termSplitter(text.trim());
    // initialize the tokens collection (return value)
    final tokens = <Token>[];

    // iterate through the terms
    await Future.forEach(terms, (String term) async {
      // remove white-space at start and end of term
      term = term.trim();
      // only tokenize non-empty strings.
      if (term.isNotEmpty) {
        // apply the termFilter if it is not null
        final splitTerms = await configuration.termFilter(term);
        for (var splitTerm in splitTerms) {
          if (splitTerm.isNotEmpty) {
            tokens.add(Token(splitTerm, position, zone));
          }
        }
      }
      // increment the index
      position = position++;
    });
    // apply the tokenFilter if it is not null and return the tokens collection
    return tokenFilter != null ? await tokenFilter!(tokens) : tokens;
  }
}

/// A [ITextAnalyzer] implementation that extracts tokens from text for use
/// in full-text search queries and indexes:
/// - [configuration] is used by the [TextAnalyzer] to tokenize source text
///   (default is [English.configuration]); and
/// - provide a custom [tokenFilter] if you want to manipulate tokens or
///   restrict tokenization to tokens that meet specific criteria (default is
///   [TextAnalyzer.defaultTokenFilter], applies [Porter2Stemmer]); and
/// - the [tokenize] function tokenizes source text using the [configuration]
///   and then manipulates the output by applying [tokenFilter]; and
/// - the [tokenizeJson] function extracts tokens from the zones in a JSON
///   document.
class TextAnalyzer extends TextAnalyzerBase {
  //

  /// The default [TokenFilter] used by [TextAnalyzer].
  ///
  /// Returns [tokens] with [Token.term] stemmed using the [Porter2Stemmer].
  static Future<List<Token>> defaultTokenFilter(List<Token> tokens) async =>
      tokens
          .map((e) => Token(e.term.stemPorter2(), e.termPosition, e.zone))
          .toList();

  /// Instantiates a const [TextAnalyzerBase] instance.
  /// - [configuration] is used by the [TextAnalyzer] to tokenize source text
  ///   (default is [English.configuration]); and
  /// - provide a custom [tokenFilter] if you want to manipulate tokens or
  ///   restrict tokenization to tokens that meet specific criteria (default is
  ///   [TextAnalyzer.defaultTokenFilter], applies [Porter2Stemmer]).
  const TextAnalyzer(
      {this.configuration = English.configuration,
      this.tokenFilter = defaultTokenFilter});

  @override
  final TokenFilter? tokenFilter;

  @override
  final TextAnalyzerConfiguration configuration;
}
