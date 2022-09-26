// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'package:text_analysis/src/_index.dart';

/// An interface exposes language-specific properties and methods used in
/// text analysis:
/// - [characterFilter] is a function that manipulates text prior to stemming
///   and tokenization;
/// - [termFilter] is a filter function that returns a collection of terms from
///   a term. It returns an empty collection if the term is to be excluded from
///   analysis or, returns multiple terms if the term is split (e.g. at hyphens)
///   and / or, returns modified term(s), such as applying a stemmer algorithm; and
/// - [termSplitter] returns a list of terms from text;
/// - [sentenceSplitter] splits text into a list of sentences at sentence and
///   line endings;
/// - [paragraphSplitter] splits text into a list of paragraphs at line
///   endings; and
/// - [syllableCounter] returns the number of syllables in a word or text.
abstract class TextAnalyzer {
  //

  /// A function that manipulates text prior to stemming and tokenization.
  ///
  /// Use a [characterFilter] to:
  /// - convert all terms to lower case;
  /// - remove non-word characters from terms.
  CharacterFilter get characterFilter;

  /// A filter function that returns a collection of terms from term:
  /// - return an empty collection if the term is to be excluded from analysis;
  /// - return multiple terms if the term is split; and/or
  /// - return modified term(s), such as applying a stemmer algorithm.
  TermFilter get termFilter;

  /// Returns a list of terms from text.
  TermSplitter get termSplitter;
  //List<String> splitIntoTerms(SourceText source);

  /// Returns a list of sentences from text.
  SentenceSplitter get sentenceSplitter;

  /// Returns a list of paragraphs from text.
  ParagraphSplitter get paragraphSplitter;

  /// Returns the number of syllables in a string after stripping out all
  /// white-space and punctuation.
  SyllableCounter get syllableCounter;
}
