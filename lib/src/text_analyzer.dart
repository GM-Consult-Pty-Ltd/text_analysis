// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import '_index.dart';

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
///   endings;
/// - [stemmer] is a language-specific function that returns the stem of a
///   term;
/// - [lemmatizer] is a language-specific function that returns the lemma of a
///   term;
/// - [termExceptions] is a hashmap of words to token terms for special words
///   that should not be re-capitalized, stemmed or lemmatized;
/// - [stopWords] are terms that commonly occur in a language and that do not add
/// material value to the analysis of text; and
/// - [syllableCounter] returns the number of syllables in a word or text.
abstract class TextAnalyzer {
  //

  /// A const generative constructor for sub-classes.
  const TextAnalyzer();

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

  /// Language-specific function that returns the stem of a term.
  Stemmer get stemmer;

  /// Language-specific function that returns the lemma of a term.
  Lemmatizer get lemmatizer;

  /// A hashmap of words to token terms for special words that should not be
  /// re-capitalized, stemmed or lemmatized.
  Map<String, String> get termExceptions;

  /// Stopwords are terms that commonly occur in a language and that do not add
  /// material value to the analysis of text.
  Iterable<String> get stopWords;
}
