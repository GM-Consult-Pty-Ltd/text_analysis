// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd

import '../_index.dart';
import 'package:collection/collection.dart';

/// The [TextDocument] object model enumerates properties for analysing a text
/// document:
/// - [sourceText] is all the analysed text in the document. The text from
///   a JSON document's (analysed) fields is joined with line ending marks;
/// - [paragraphs] is a list of strings after splitting [sourceText] at line
///   ending marks;
/// - [sentences] is a list of strings after splitting [sourceText] at sentence
///   ending punctuation and line ending marks;
/// - [nGrams] is a collection of word sequences generated from the terms;
/// - [terms] is all the words in the [sourceText];
/// - [keywords] is the keywords in the document mapped to their RAKE keyword
///   score in a [TermCoOccurrenceGraph];
/// - [syllableCount] is the total number of syllables in the document; and
/// - [tokens] is all the tokens extracted from [sourceText].
///
/// The following functions return analysis results from the [sourceText]
/// statistics:
/// - [averageSentenceLength] is the average number of words in [sentences];
/// - [averageSyllableCount] is the average number of syllables per word in
///   [terms];
/// - [wordCount] the total number of words in the [sourceText];
/// - [fleschReadingEaseScore] is a readibility measure calculated from
///   sentence length and word length on a 100-point scale. The higher the
///   score, the easier it is to understand the document;
/// - [fleschKincaidGradeLevel] is a readibility measure relative to U.S.
///   school grade level.  It is also calculated from sentence length and word
///   length .
abstract class TextDocument {
  //

  /// Hydrates a const [TextDocument] from the document properties.
  /// - [sourceText] is all the analysed text in the document. The text from
  ///   a JSON document's (analysed) fields is joined with line ending marks;
  /// - [paragraphs] is a list of strings after splitting [sourceText] at line
  ///   ending marks;
  /// - [sentences] is a list of strings after splitting [sourceText] at sentence
  ///   ending punctuation and line ending marks;
  /// - [nGrams] is a collection of word sequences generated from the terms;
  /// - [terms] is all the words in the [sourceText];
  /// - [keywords] is the keywords in the document mapped to their RAKE keyword
  ///   score in a [TermCoOccurrenceGraph];
  /// - [syllableCount] is the total number of syllables in the document; and
  /// - [tokens] is all the tokens extracted from [sourceText].
  factory TextDocument(
          {required String sourceText,
          required List<Token> tokens,
          required List<String> paragraphs,
          required List<String> sentences,
          required List<String> terms,
          required List<String> nGrams,
          required TermCoOccurrenceGraph keywords,
          required int syllableCount}) =>
      _TextDocumentImpl(sourceText, tokens, paragraphs, sentences, terms,
          nGrams, syllableCount, keywords);

  /// Hydrates a [TextDocument] from the [sourceText], [zone] and
  /// [analyzer] parameters:
  /// - [sourceText] is all the analysed text in the document;
  /// - [zone] is the name to be used for all tokens extracted from the
  ///   [sourceText];
  /// - [nGramRange] is the range of N-gram lengths to generate; and
  /// - [analyzer] is a [TextAnalyzer] used to split the [sourceText] into
  ///   [paragraphs], [sentences], [terms] and [nGrams] in the [nGramRange] and
  ///   to extract the keywords in the [sourceText] to a
  ///   [TermCoOccurrenceGraph].
  /// The static factory instantiates a [TextTokenizer] to tokenize the
  /// [sourceText] and populate the [tokens] property.
  static Future<TextDocument> analyze(
      {required String sourceText,
      required TextAnalyzer analyzer,
      NGramRange nGramRange = const NGramRange(1, 1),
      Zone? zone}) async {
    final tokens = await TextTokenizer(analyzer: analyzer)
        .tokenize(sourceText, zone: zone, nGramRange: nGramRange);
    final terms = analyzer.termSplitter(sourceText);
    final nGrams = terms.nGrams(nGramRange);
    final sentences = analyzer.sentenceSplitter(sourceText);
    final paragraphs = analyzer.paragraphSplitter(sourceText);
    final keywords = analyzer.keywordExtractor(sourceText);
    final graph = TermCoOccurrenceGraph(keywords);
    final syllableCount = terms.map((e) => analyzer.syllableCounter(e)).sum;
    return _TextDocumentImpl(sourceText, tokens, paragraphs, sentences, terms,
        nGrams, syllableCount, graph);
  }

  /// Hydrates a [TextDocument] from the [document], [zones] and
  /// [analyzer] parameters. The static factory:
  /// - extracts the [sourceText] from the [zones] in a JSON [document],
  ///   inserting line ending marks between the [zones]; then
  /// - splits the [sourceText] into [paragraphs], [sentences], [terms] and
  ///   [nGrams] in the [nGramRange] using the [analyzer]; and then
  /// - instantiates a [TextTokenizer] to tokenize the [sourceText] and
  ///   populate the [tokens] property.
  static Future<TextDocument> analyzeJson(
      {required Map<String, dynamic> document,
      required TextAnalyzer analyzer,
      NGramRange nGramRange = const NGramRange(1, 1),
      Iterable<Zone>? zones}) async {
    final buffer = StringBuffer();
    if (zones == null || zones.isEmpty) {
      for (final fieldValue in document.values) {
        buffer.writeln(fieldValue.toString());
        buffer.write('\n');
      }
    } else {
      zones = zones.toSet();
      for (final zone in zones) {
        final value = document[zone];
        if (value != null) {
          buffer.writeln(value.toString());
          buffer.write('\n');
        }
      }
    }
    final sourceText = buffer.toString();
    final tokens = await TextTokenizer(analyzer: analyzer)
        .tokenizeJson(document, zones: zones, nGramRange: nGramRange);
    final terms = analyzer.termSplitter(sourceText);
    final nGrams = terms.nGrams(nGramRange);
    final sentences = analyzer.sentenceSplitter(sourceText);
    final paragraphs = analyzer.paragraphSplitter(sourceText);
    final keywords = analyzer.keywordExtractor(sourceText);
    final graph = TermCoOccurrenceGraph(keywords);
    final syllableCount = terms.map((e) => analyzer.syllableCounter(e)).sum;
    return _TextDocumentImpl(sourceText, tokens, paragraphs, sentences, terms,
        nGrams, syllableCount, graph);
  }

  /// The unique keywords in the document mapped to their RAKE keyword score
  /// in a [TermCoOccurrenceGraph].
  TermCoOccurrenceGraph get keywords;

  /// Returns the source text associated with the document.
  String get sourceText;

  /// All the paragraphs in the [sourceText].
  List<String> get paragraphs;

  /// All the sentences in the [sourceText].
  List<String> get sentences;

  /// All the words in the [sourceText].
  List<String> get terms;

  /// The tokens extracted from [sourceText].
  List<Token> get tokens;

  /// A collection of n-grams from the [terms] in the document.
  List<String> get nGrams;

  /// The average number of words in [sentences].
  int averageSentenceLength();

  /// The average number of syllables per word in [terms].
  double averageSyllableCount();

  /// The number of words in the [sourceText].
  int wordCount();

  /// Returns the Flesch reading ease score of the [sourceText] on a
  /// 100-point scale.
  ///
  /// The higher the score, the easier it is to understand the document.
  ///
  /// Authors should aim for score above 60.
  double fleschReadingEaseScore();

  /// Returns the readability score of [sourceText] on a U.S. school grade
  /// level (`Flesch-Kincaid Grade Level test`).
  ///
  /// For example, a score of 8.0 means that an eighth grader can understand
  /// the document.
  ///
  /// A score of 7 to 8 indicates good readibility without being too simple.
  int fleschKincaidGradeLevel();

  /// The total number of syllables in the document.
  int get syllableCount;
}

/// The [TextDocumentMixin] provides implementations of the
/// [TextDocument.averageSentenceLength], [TextDocument.averageSyllableCount],
/// [TextDocument.wordCount], [TextDocument.fleschReadingEaseScore] and
/// [TextDocument.fleschKincaidGradeLevel] methods.
abstract class TextDocumentMixin implements TextDocument {
  //

  @override
  int wordCount() => terms.length;

  @override
  int averageSentenceLength() => (terms.length / sentences.length).round();

  @override
  double averageSyllableCount() => syllableCount / terms.length;

  @override
  double fleschReadingEaseScore() =>
      206.835 - 1.015 * averageSentenceLength() - 84.6 * averageSyllableCount();

  @override
  int fleschKincaidGradeLevel() =>
      (0.39 * averageSentenceLength() + 11.8 * averageSyllableCount() - 15.59)
          .floor();

//
}

/// An abstract implementation of [TextDocument] that uses [TextDocumentMixin].
abstract class TextDocumentBase with TextDocumentMixin {
  //

  /// A const constructor for sub classes.
  const TextDocumentBase();
}

/// Implementation class used by [TextDocument] factories.
class _TextDocumentImpl with TextDocumentMixin {
  //

  @override
  final List<String> paragraphs;

  @override
  final TermCoOccurrenceGraph keywords;

  @override
  final List<String> sentences;

  @override
  final String sourceText;

  @override
  final List<String> terms;

  @override
  final List<String> nGrams;

  @override
  final int syllableCount;

  @override
  final List<Token> tokens;

  const _TextDocumentImpl(
      this.sourceText,
      this.tokens,
      this.paragraphs,
      this.sentences,
      this.terms,
      this.nGrams,
      this.syllableCount,
      this.keywords);
}
