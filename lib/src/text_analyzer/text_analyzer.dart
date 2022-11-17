// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd

// import 'package:text_analysis/src/text_analyzer/n_gram_range.dart';
import 'package:text_analysis/type_definitions.dart';

/// An interface exposes language-specific properties and methods used in
/// text analysis.
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
/// - [syllableCounter] returns the number of syllables in a word or text.
abstract class TextAnalyzer {
  //

  /// A function that filters out unwanted characters or replaces them with
  /// other characters.
  AsyncTermModifier get characterFilter;

  /// A filter function that returns a modified term or null.
  AsyncTermModifier get termFilter;

  /// Expands text to a collection of related Strings, e.g. synonyms,
  /// abbreviations or spelling suggestions.
  ///
  /// Used during tokenization and keyword extraction.
  TermExpander? get termExpander;

  /// Returns a list of keywords from text.
  ///
  /// A keyword is a word or phrase seperated from other words/phrases by
  /// punctuation, stopwords and/or other language delimiters.
  PhraseSplitter get phraseSplitter;

  /// Returns a list of words from text.
  ///
  /// A word is defined as a sequence of word-characters bound by word
  /// boundaries either side. By definition all non-word characters are
  /// excluded from this definition.
  TextSplitter get termSplitter;

  /// Extracts one or more tokens from text for use in full-text search queries
  /// and indexes.
  Tokenizer get tokenizer;

  /// Extracts tokens from the fields in a JSON document for use in full-text
  /// search queries and indexes.
  JsonTokenizer get jsonTokenizer;

  /// Returns a list of sentences from text.
  TextSplitter get sentenceSplitter;

  /// Returns a list of paragraphs from text.
  TextSplitter get paragraphSplitter;

  /// Returns the number of syllables in a string after stripping out all
  /// white-space and punctuation.
  SyllableCounter get syllableCounter;

  /// A language-specific function that generates n-grams from text.
  NGrammer get nGrammer;

  // /// A hashmap of words to token terms for special words that should not be
  // /// re-capitalized, stemmed or lemmatized.
  // Map<String, String> get termExceptions;

  // /// A hashmap of abbreviations in the analyzed language.
  // Map<String, String> get abbreviations;
}
