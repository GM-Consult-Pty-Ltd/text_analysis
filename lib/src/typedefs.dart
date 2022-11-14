// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd

import 'dart:async';
import 'package:text_analysis/text_analysis.dart';

/// An alias for String.
typedef SourceText = String;

/// An alias for String, when used in the context of a field or meta data field
/// in the `corpus`. Represents the name of the field/zone.
typedef Zone = String;

/// An alias for String, used in the context of a word, term or phrase present
/// in a text source, document or query.
typedef Term = String;

/// An alias for `List<String>` when used in the context of the terms of a
/// phrase split to an ordered list of terms.
typedef Phrase = List<String>;

/// An alias for String, used in the context of a sequence of k characters
/// from a [Term].
///
/// A k-gram can start with "$", dentoting the start of the [Term], and end with
/// "$", denoting the end of the [Term].
///
/// The 3-grams for "castle" are { $ca, cas, ast, stl, tle, le$ }
typedef KGram = String;

/// Alias for `Map<String, Set<String>>`.
///
/// A hashmap of [KGram] to Set<[Term]>, where the value is the set of unique
/// [Term]s that contain the [KGram] in the key.
typedef KGramsMap = Map<KGram, Set<Term>>;

/// An alias for a [Set] of [String], when used in the context of a collection
/// of [Term] that are excluded from tokenization.
typedef StopWords = Set<Term>;

// /// A language-specific function that returns the stem of [term].
// typedef Stemmer = String Function(Term term);

/// A language-specific function that returns the stem of [term].
typedef TermModifier = String Function(String term);

// /// A language-specific function that returns the lemma of [term].
// typedef Lemmatizer = String Function(Term term);

/// A language-specific function that generates n-grams from text.
typedef NGrammer = List<String> Function(
  String text,
  NGramRange range,
);

/// A language-specific function that returns the number of syllables in a
/// string after stripping out all white-space and punctuation.
///
/// Intended for use on words or terms, rather than phrases.
///
/// Returns 0 if [term].isEmpty.
typedef SyllableCounter = int Function(Term term);

/// A splitter function that returns a list of terms from [source].
///
/// Typically, [source] is split at punctuation marks and white-space.
///
/// The term splitter should avoid splitting numbers, which may contain
/// period marks or other punctuation delimited phrases such as domain names
/// and identifiers and hyphenated words.
///
/// If the [TermSplitter] preserves punctuation delimited phrases, the
/// tokenizer that uses the [TermSplitter] can include both the
/// preserved/delimited term as well as its components as separate tokens.
typedef TermSplitter = List<String> Function(SourceText source);

/// A splitter function that returns a list of sentences from [source].
///
/// In English, the [source] text is split at sentence endings marks such as
/// periods, question marks and exclamation marks. If the [source] contains
/// paragraph ending marks it should also be split at these.
///
/// The sentence splitter should avoid splitting after abbreviations,
/// which may end with period marks.
typedef SentenceSplitter = List<String> Function(SourceText source);

/// A splitter function that returns an ordered collection of keyword phrases
/// from text.
///
/// The text is split at punctuation, line endings and stop-words, resulting
/// in an ordered collection of term sequences of varying length.
typedef KeywordExtractor = List<List<String>> Function(
  SourceText source);

/// Type definition of a function that returns a collection of [Token] from
/// the [source] text.
///
/// Extracts one or more tokens from [source] for use in full-text search
/// queries and indexes.
/// - [source] is a String that will be tokenized;
/// - [tokenFilter] is a filter function that returns a subset of a collection
///   of [Token]s; and
/// - [zone] is the of the name of the zone to be appended to the [Token]s.
///
/// Returns a List<[Token]>.
typedef Tokenizer = Future<List<Token>> Function(SourceText source,
    {Zone? zone,
    TokenFilter? tokenFilter});

/// Type definition of a function that returns a collection of [Token] from
/// the [zones] in a JSON [document].
///
/// Extracts tokens from the [zones] in a JSON [document] for use in
/// full-text search queries and indexes.
/// - [document] is a JSON document containing the [zones] as keys;
/// - [tokenFilter] is a filter function that returns a subset of a collection
///   of [Token]s; and
/// - [zones] is the collection of the names of the zones in [document] that
///   are to be tokenized.
///
/// Returns a List<[Token]>.
typedef JsonTokenizer = Future<List<Token>> Function(
    Map<String, dynamic> document,
    {Iterable<Zone>? zones,
    TokenFilter? tokenFilter});

/// A splitter function that returns a list of paragraphs from [source].
///
/// In English, the [source] text is split at:
/// - `U+000A`, NewLine;
/// - `U+000B`, VerticalTabulation;
/// - `U+000C`, FormFeed; and
/// - `U+000D`, CarriageReturn.
typedef ParagraphSplitter = List<String> Function(String source);

/// A filter function that returns a collection of terms from term:
/// - return an empty collection if the term is to be excluded from analysis;
/// - return multiple terms if the term is split; and/or
/// - return modified term(s), such as applying a stemmer algorithm.
typedef TermFilter = Set<String> Function(Term term);

/// A filter function that returns a subset of [tokens].
typedef TokenFilter = Future<List<Token>> Function(List<Token> tokens);

/// Type definition of a function that filters characters from the [source]
/// text in preparation of tokenization.
typedef CharacterFilter = String Function(SourceText source);

/// A callback function that returns true or false based on the content of
/// the term.
typedef TermFlag = bool Function(Term term);

// {NGramRange nGramRange = const NGramRange(1, 1), TokenizingStrategy strategy = TokenizingStrategy.terms, Zone? zone}

/// Type definition for a hashmap of [Term] to value, when used as a
/// n-dimensional vector in calculating cosine similarity between documents.
///
/// Alias for `Map<String, num>`.
typedef VectorSpace = Map<String, num>;
