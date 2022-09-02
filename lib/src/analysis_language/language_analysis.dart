// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

/// A base class/interface exposing language properties used in text analysis.
abstract class AnalysisLanguage {
  //

  /// A collection of stop-words excluded from tokenization.
  Iterable<String> get stopWords;

  /// Returns a regular expression String that selects all sentence endings.
  String get sentenceEndingSelector;

  /// Returns a regular expression String that selects all line endings.
  String get lineEndingSelector;

  /// Returns a regular expression String that selects all punctuation.
  String get punctuationSelector;
}
