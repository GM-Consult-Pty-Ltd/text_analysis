// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'package:text_analysis/text_analysis.dart';

/// A [Sentence] represents a text [source] not containing sentence ending
/// punctuation such as periods, question-marks and exclamations, except where
/// used in tokens, identifiers or other terms.
///
/// In addition to the [source] text, the [Sentence] object also enumerates
/// its [tokens].
abstract class Sentence {
  //

  /// Factory function that returns a Future of [Sentence] from the [sentence]
  /// using the [configuration].
  ///
  /// The sentence [tokens] are filtered using [tokenFilter].
  static Future<Sentence> fromString(String sentence,
          TextAnalyzerConfiguration configuration, TokenFilter? tokenFilter,
          [String? field]) =>
      _SentenceImpl.fromString(sentence, configuration, tokenFilter, field);

  /// The source text of the [Sentence].
  String get source;

  /// All the tokens in the [Sentence].
  List<Token> get tokens;

  /// Compares only whether:
  /// - [other] is [Sentence];
  /// - [source] == [other].source; and
  /// - [tokens].length == [other].tokens.length.
  @override
  bool operator ==(Object other) =>
      other is Sentence &&
      source == other.source &&
      tokens.length == other.tokens.length;

  @override
  int get hashCode => Object.hash(source, tokens);
}

class _SentenceImpl implements Sentence {
  //

  /// Extracts tokens from [sentence] for use in full-text search queries and
  /// indexes.
  ///
  /// Returns a list of [Token].
  static Future<List<Token>> tokenize(
      {required String sentence,
      required TextAnalyzerConfiguration configuration,
      TokenFilter? tokenFilter,
      String? field}) async {
    // perform the first punctuation and white-space split
    final terms = configuration.termSplitter(sentence);
    // initialize the tokens collection (return value)
    final tokens = <Token>[];
    // initialize the index
    var index = 0;
    // iterate through the terms
    for (var term in terms) {
      // calculate the index increment from the raw term length
      final increment = term.length + 1;
      // remove white-space at start and end of term
      term = term.trim();
      // only tokenize non-empty strings.
      if (term.isNotEmpty) {
        // apply the termFilter if it is not null
        final splitTerms = await configuration.termFilter(term);
        // initialize a sub-index for split terms
        var subIndex = 0;
        var i = 0;
        for (var splitTerm in splitTerms) {
          // apply the characterFilter if it is not null
          splitTerm = configuration.characterFilter(splitTerm);
          final tokenIndex = index + subIndex;
          tokens.add(Token(splitTerm, tokenIndex, field));
          // only increment the sub-index after the first term
          if (i > 0) {
            subIndex += splitTerm.length + 1;
          }
          i++;
        }
      }
      // increment the index
      index = index + increment;
    }
    // apply the tokenFilter if it is not null and return the tokens collection
    return tokenFilter != null ? await tokenFilter(tokens) : tokens;
  }

  /// Instantiates a [Sentence] from [source] and [tokens].
  const _SentenceImpl(this.source, this.tokens);

  /// Factory function that returns a Future [Sentence] from the [sentence] text
  /// using the [configuration].
  ///
  /// The sentence [tokens] are filtered using [tokenFilter].
  static Future<Sentence> fromString(String sentence,
      TextAnalyzerConfiguration configuration, TokenFilter? tokenFilter,
      [String? field]) async {
    final tokens = await _SentenceImpl.tokenize(
        sentence: sentence,
        configuration: configuration,
        tokenFilter: tokenFilter,
        field: field);
    return _SentenceImpl(sentence, tokens);
  }

  @override
  final String source;

  @override
  final List<Token> tokens;
}
