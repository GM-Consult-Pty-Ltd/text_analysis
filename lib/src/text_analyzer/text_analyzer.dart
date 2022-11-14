// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd

import 'package:text_analysis/src/text_analyzer/n_gram_range.dart';
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
/// - [stemmer] is a language-specific function that returns the stem of a
///   term;
/// - [lemmatizer] is a language-specific function that returns the lemma of a
///   term;
/// - [keywordExtractor] is a splitter function that returns an ordered
///   collection of keyword phrasesfrom text. The text is split at punctuation,
///   line endings and stop-words, resulting in an ordered collection of term
///   sequences of varying length.
/// - [termExceptions] is a hashmap of words to token terms for special words
///   that should not be re-capitalized, stemmed or lemmatized;
/// - [abbreviations] is a hashmap of abbreviations in the analyzed language;
///   and
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

  /// A splitter function that returns an ordered collection of keyword phrases
  /// from text.
  ///
  /// The text is split at punctuation, line endings and stop-words, resulting
  /// in an ordered collection of term sequences of varying length.
  KeywordExtractor get keywordExtractor;

  /// Extracts one or more tokens from text for use in full-text search queries
  /// and indexes.
  Tokenizer get tokenizer;

  /// Extracts tokens from the fields in a JSON document for use in full-text
  /// search queries and indexes.
  JsonTokenizer get jsonTokenizer;

  /// Returns a list of sentences from text.
  SentenceSplitter get sentenceSplitter;

  /// Returns a list of paragraphs from text.
  ParagraphSplitter get paragraphSplitter;

  /// Returns the number of syllables in a string after stripping out all
  /// white-space and punctuation.
  SyllableCounter get syllableCounter;

  /// Language-specific function that returns the stem of a term.
  TermModifier get stemmer;

  /// Language-specific function that returns the lemma of a term.
  TermModifier get lemmatizer;

  /// A language-specific function that generates n-grams from text.
  NGrammer get nGrammer;

  /// A hashmap of words to token terms for special words that should not be
  /// re-capitalized, stemmed or lemmatized.
  Map<String, String> get termExceptions;

  /// A callback that re-cases the terms.
  ///
  /// Re-case is called on individual terms, not phrases or keywords and can be
  /// used to preserve case on identifiers, given names or other case-sensitive
  /// language.
  TermModifier get reCase;

  /// A callback that returns true if the term is a stopword.
  ///
  /// Stopwords are terms that commonly occur in a language and that do not add
  /// material value to the analysis of text.
  ///
  /// Stopwords are used by the [keywordExtractor] and [termFilter].
  TermFlag get isStopWord;

  /// A hashmap of abbreviations in the analyzed language.
  Map<String, String> get abbreviations;
}
