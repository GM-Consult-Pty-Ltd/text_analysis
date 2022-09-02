// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

// import 'package:text_analysis/text_analysis.dart';

import 'package:text_analysis/src/_index.dart';

/// Interface for a text analyser class that extracts tokens from text for use
/// in full-text search queries and indexes.
abstract class TextAnalyzerBase {
  //

  /// A filter function remove terms to be excluded from analysis such as
  /// common stopwords that have no relevance in the analysis.
  List<String> excludeStopWords(List<String> terms);

  /// Returns a regular expression String that selects all sentence endings.
  String get sentenceEndingSelector;

  /// Returns a regular expression String that selects all line endings.
  String get lineEndingSelector;

  /// The [AnalysisLanguage] used by the [TextAnalyzerBase].
  AnalysisLanguage get language;

  /// Extracts tokens from text for use in full-text search queries and indexes.
  ///
  /// Returns a [TextSource] with [source] and its component [Sentence]s and
  /// [Token]s
  TextSource tokenize(String source);
}

/// A [TextAnalyzerBase] implementation that extracts tokens from text for use
/// in full-text search queries and indexes.
class TextAnalyzer implements TextAnalyzerBase {
  //

  /// Hydrates a const TextAnalyzer
  const TextAnalyzer({this.language = EnglishAnalysis.instance});

  @override
  final AnalysisLanguage language;

  @override
  List<String> excludeStopWords(List<String> terms) {
    terms.removeWhere((element) => language.stopWords.contains(element));
    return terms;
  }

  /// Regular expression String that selects all sentence endings.
  static const kLineEndingSelector = r'';

  /// Returns a regular expression String that selects all sentence endings.
  static const kSentenceEndingSelector = r'';

  /// Returns a regular expression String that selects all sentence endings.
  @override
  String get sentenceEndingSelector => TextAnalyzer.kLineEndingSelector;

  /// Returns a regular expression String that selects all line endings.
  @override
  String get lineEndingSelector => TextAnalyzer.kSentenceEndingSelector;

  @override
  TextSource tokenize(String source) {
    // TODO: implement tokenize
    throw UnimplementedError();
  }
}
