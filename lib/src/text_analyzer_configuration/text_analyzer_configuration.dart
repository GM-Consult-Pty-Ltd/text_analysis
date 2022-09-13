// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'package:text_analysis/text_analysis.dart';

/// An interface exposing language properties used in text analysis.
abstract class TextAnalyzerConfiguration {
  //

  /// A function that manipulates text prior to stemming and tokenization.
  ///
  /// Use a [characterFilter] to:
  /// - convert all terms to lower case;
  /// - remove non-word characters from terms.
  CharacterFilter? get characterFilter;

  /// A filter function that returns a collection of terms from term:
  /// - return an empty collection if the term is to be excluded from analysis;
  /// - return multiple terms if the term is split; and/or
  /// - return modified term(s), such as applying a stemmer algorithm.
  TermFilter? get termFilter;

  /// Returns a list of sentences from text.
  SentenceSplitter get sentenceSplitter;

  /// Returns a list of terms from text.
  TermSplitter get termSplitter;
  //List<String> splitIntoTerms(String source);
}
