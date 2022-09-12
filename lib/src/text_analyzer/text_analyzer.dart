// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'package:text_analysis/text_analysis.dart';
import 'package:porter_2_stemmer/porter_2_stemmer.dart';

/// Interface for a text analyser class that extracts tokens from text for use
/// in full-text search queries and indexes:
/// - [configuration] is a [TextAnalyzerConfiguration] used by the
///   [ITextAnalyzer] to tokenize source text; and
/// - provide a [tokenFilter] if you want to manipulate tokens or restrict
///   tokenization to tokens that meet criteria for either index or count; and
/// - the [tokenize] function tokenizes source text using the [configuration]
///   and then manipulates the output by applying [tokenFilter].
abstract class ITextAnalyzer {
  //

  /// The [TextAnalyzerConfiguration] used by the [ITextAnalyzer].
  TextAnalyzerConfiguration get configuration;

  /// A filter that returns a subset of tokens.
  ///
  /// Provide a [tokenFilter] if you want to manipulate tokens or restrict
  /// tokenization to tokens that meet criteria for either index or count.
  TokenFilter? get tokenFilter;

  /// Extracts tokens from text for use in full-text search queries and indexes.
  ///
  /// Returns a [TextSource] with [source] and its component [Sentence]s and
  /// [Token]s
  Future<TextSource> tokenize(String source);
}

/// A [ITextAnalyzer] implementation that extracts tokens from text for use
/// in full-text search queries and indexes.
class TextAnalyzer implements ITextAnalyzer {
  //

  /// The default [TokenFilter] used by [TextAnalyzer].
  ///
  /// Returns [tokens] with [Token.term] stemmed using the [Porter2Stemmer].
  static Future<List<Token>> defaultTokenFilter(List<Token> tokens) async =>
      tokens
          .map((e) =>
              Token(e.term.stemPorter2(), e.index, e.position, e.termPosition))
          .toList();

  /// Hydrates a const TextAnalyzer.
  const TextAnalyzer(
      {this.configuration = English.configuration,
      this.tokenFilter = defaultTokenFilter});

  @override
  Future<TextSource> tokenize(String source) async {
    final sentenceStrings = configuration.sentenceSplitter(source);
    final sentences = <Sentence>[];
    // convert [sentenceStrings] into [Sentence]s
    for (final sentence in sentenceStrings) {
      final value =
          await Sentence.fromString(sentence, configuration, tokenFilter);
      sentences.add(value);
    }
    return TextSource(source, sentences);
  }

  @override
  final TokenFilter? tokenFilter;

  @override
  final TextAnalyzerConfiguration configuration;

  /// Regular expression String that selects all sentence endings.
  static const kLineEndingSelector = r'';

  /// Returns a regular expression String that selects all sentence endings.
  static const kSentenceEndingSelector = r'';
}
