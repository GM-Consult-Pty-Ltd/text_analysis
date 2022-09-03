// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

/// A base class/interface exposing language properties used in text analysis.
abstract class AnalysisLanguage {
  //

  /// Splits [source] into sentences at all sentence endings.
  List<String> splitIntoSentences(String source);

  /// Splits [source] into all the terms.
  List<String> splitIntoTerms(String source);

  /// A collection of words excluded from tokenization, usually common
  /// stop words and adjectives/adverbs that have little or no relevance in
  /// text-analysis.
  Iterable<String> get excludedTerms;
}
