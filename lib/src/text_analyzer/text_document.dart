// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'package:text_analysis/text_analysis.dart';
import 'package:collection/collection.dart';

abstract class TextDocument {
  //

  factory TextDocument(
          {required String sourceText,
          required List<Token> tokens,
          TextAnalyzer configuration = English.configuration}) =>
      _TextDocumentImpl(configuration, sourceText, tokens);

  static Future<TextDocument> tokenize(
      {required String sourceText,
      Zone? zone,
      TextAnalyzer configuration = English.configuration}) async {
    final tokens = await TextTokenizer(configuration: configuration)
        .tokenize(sourceText, zone);
    return _TextDocumentImpl(configuration, sourceText, tokens);
  }

  static Future<TextDocument> tokenizeJson(
      {required Map<String, dynamic> document,
      Iterable<Zone>? zones,
      TextAnalyzer configuration = English.configuration}) async {
    final sourceText = StringBuffer();
    if (zones == null || zones.isEmpty) {
      for (final fieldValue in document.values) {
        sourceText.writeln(fieldValue.toString());
        sourceText.write('\n');
      }
    } else {
      zones = zones.toSet();
      for (final zone in zones) {
        final value = document[zone];
        if (value != null) {
          sourceText.writeln(value.toString());
          sourceText.write('\n');
        }
      }
    }
    final tokens = await TextTokenizer(configuration: configuration)
        .tokenizeJson(document, zones);
    return _TextDocumentImpl(configuration, sourceText.toString(), tokens);
  }

  /// Returns the source text associated with the document.
  String get sourceText;

  /// All the paragraphs in the [sourceText].
  List<String> get paragraphs;

  /// All the sentences in the [sourceText].
  List<String> get sentences;

  /// All the words in the [sourceText].
  List<String> get terms;

  /// The average length of sentences in [sourceText].
  int get averageSentenceLength;

  /// The average number of syllables per word in [terms].
  double get averageSyllableCount;

  /// The number of words in the [sourceText].
  int get wordCount;

  /// The tokens extracted from [sourceText].
  List<Token> get tokens;

  /// Returns the Flesch reading ease score of the [sourceText] on a
  /// 100-point scale.
  ///
  /// The higher the score, the easier it is to understand the document.
  ///
  /// Authors should aim for score above 60.
  double get fleschReadingEaseScore;

  /// Returns the readability score of [sourceText] on a U.S. school grade
  /// level (`Flesch-Kincaid Grade Level test`).
  ///
  /// For example, a score of 8.0 means that an eighth grader can understand
  /// the document.
  ///
  /// A score of 7 to 8 indicates good readibility without being too simple.
  int get fleschKincaidGradeLevel;
}

abstract class TextDocumentMixin implements TextDocument {
  //

  /// The language properties and methods used in text analysis.
  TextAnalyzer get configuration;

  @override
  int get wordCount => terms.length;

  @override
  int get averageSentenceLength => (terms.length / sentences.length).round();

  @override
  double get averageSyllableCount =>
      (terms.map((e) => configuration.syllableCounter(e)).sum / terms.length);

  @override
  double get fleschReadingEaseScore =>
      206.835 - 1.015 * averageSentenceLength - 84.6 * averageSyllableCount;

  @override
  int get fleschKincaidGradeLevel =>
      (0.39 * averageSentenceLength + 11.8 * averageSyllableCount - 15.59)
          .floor();

//
}

class _TextDocumentImpl with TextDocumentMixin {
  @override
  final TextAnalyzer configuration;

  @override
  final List<String> paragraphs;

  @override
  final List<String> sentences;

  @override
  final String sourceText;

  @override
  final List<String> terms;

  @override
  final List<Token> tokens;

  _TextDocumentImpl(this.configuration, this.sourceText, this.tokens)
      : terms = configuration.termSplitter(sourceText),
        sentences = configuration.sentenceSplitter(sourceText),
        paragraphs = configuration.paragraphSplitter(sourceText);
}
