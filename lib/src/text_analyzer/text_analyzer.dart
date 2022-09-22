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
  /// Returns a [TextSource] with [source] and its component [Sentence]s and
  /// [Token]s
  Future<TextSource> tokenize(SourceText source, [Zone? zone]);

  /// Extracts tokens from the [zones] in a JSON [document] for use in
  /// full-text search queries and indexes.
  ///
  /// The required parameter [zones] is the collection of the names of the
  /// zones in [document] that are to be tokenized.
  ///
  /// Returns a [TextSource] with [document] and its component [Sentence]s and
  /// [Token]s
  Future<TextSource> tokenizeJson(Map<String, dynamic> document,
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
  Future<TextSource> tokenizeJson(Map<String, dynamic> document,
      [Iterable<Zone>? zones]) async {
    final sentences = <Sentence>[];
    final sourceBuilder = StringBuffer();
    if (zones == null || zones.isEmpty) {
      final valueBuilder = StringBuffer();
      for (final fieldValue in document.values) {
        valueBuilder.writeln(fieldValue.toString());
      }
      final value = valueBuilder.toString();
      final source = value.toString();
      if (source.isNotEmpty) {
        final doc = await tokenize(source);
        sentences.addAll(doc.sentences);
        sourceBuilder.writeln(document.toString());
      }
    } else {
      zones = Set<String>.from(zones);
      for (final zone in zones) {
        final value = document[zone];
        if (value != null) {
          final source = value.toString();
          if (source.isNotEmpty) {
            final doc = await tokenize(source, zone);
            sentences.addAll(doc.sentences);
            sourceBuilder.writeln('"$zone": "$source"');
          }
        }
      }
    }
    return TextSource(sourceBuilder.toString(), sentences);
  }

  @override
  Future<TextSource> tokenize(SourceText source, [Zone? zone]) async {
    final sentenceStrings = configuration.sentenceSplitter(source);
    final sentences = <Sentence>[];
    // convert [sentenceStrings] into [Sentence]s
    for (final sentence in sentenceStrings) {
      final value =
          await Sentence.fromString(sentence, configuration, tokenFilter, zone);
      sentences.add(value);
    }
    return TextSource(source, sentences);
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
