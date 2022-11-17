// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd

import 'dart:async';
import 'package:text_analysis/text_analysis.dart';

/// A callback function that returns true or false based on the content of
/// the term.

/// `TextSplitter` - A splitter function that returns a list of paragraphs from [source].
///
/// In English, the [source] text is split at:
/// - `U+000A`, NewLine;
/// - `U+000B`, VerticalTabulation;
/// - `U+000C`, FormFeed; and
/// - `U+000D`, CarriageReturn.

/// `TermFilter` - A filter function that returns a collection of terms from term:
/// - return an empty collection if the term is to be excluded from analysis;
/// - return multiple terms if the term is split; and/or
/// - return modified term(s), such as applying a stemmer algorithm.

/// `SentenceSplitter` - A splitter function that returns a list of sentences from [source].
///
/// In English, the [source] text is split at sentence endings marks such as
/// periods, question marks and exclamation marks. If the [source] contains
/// paragraph ending marks it should also be split at these.
///
/// The sentence splitter should avoid splitting after abbreviations,
/// which may end with period marks.

/// An alias for String, when used in the context of a field or meta data field
/// in the `corpus`. Represents the name of the field/zone.

/// An alias for String, used in the context of a word, term or phrase present
/// in a text source, document or query.

/// Phrase: An alias for `List<String>` when used in the context of the terms of a
/// phrase split to an ordered list of terms.

/// k-Gram: An alias for String, used in the context of a sequence of k characters
/// from a term.
///
/// A k-gram can start with "$", dentoting the start of the term, and end with
/// "$", denoting the end of the term.
///
/// The 3-grams for "castle" are { $ca, cas, ast, stl, tle, le$ }

/// `PhraseExtractor` - a splitter function that returns an ordered collection of keyword phrases
/// from text.
///
/// The text is split at punctuation, line endings and stop-words, resulting
/// in an ordered collection of term sequences of varying length.

/// Alias for `Map<String, Set<String>>`.
///
/// A hashmap of k-Gram to Set<term>, where the value is the set of unique
/// terms that contain the k-Gram in the key.
typedef KGramsMap = Map<String, Set<String>>;

/// Modifies the term and returns the modified version.
typedef TermModifier = String? Function(String term);

/// Modifies the term and returns the modified version.
typedef AsyncTermModifier = Future<String?> Function(String term,
    [String? zone]);

/// A language-specific function that generates n-grams from text.
typedef NGrammer = List<String> Function(
  String text,
  NGramRange range,
);

/// A callback that expands text to a collection of related Strings.
typedef TermExpander = Future<Iterable<String>> Function(String source,
    [String? zone]);

/// A language-specific function that returns the number of syllables in a
/// string after stripping out all white-space and punctuation.
///
/// Intended for use on words or terms, rather than phrases.
///
/// Returns 0 if [term].isEmpty.
typedef SyllableCounter = int Function(String term);

/// A splitter function that returns a list of terms from [source].
typedef TextSplitter = List<String> Function(String source);

/// A splitter function that returns a list of terms from [source].
typedef AsyncTextSplitter = Future<List<String>> Function(String source);

/// A splitter function that returns a list of terms from [source].
typedef PhraseSplitter = Future<List<String>> Function(String source,
    [String? zone]);

/// Type definition of a function that returns a collection of [Token] from
/// the [source] text.
///
/// Extracts one or more tokens from [source] for use in full-text search
/// queries and indexes.
/// - [source] is a String that will be tokenized;
/// - [nGramRange] is the range of N-gram lengths to generate. If [nGramRange]
///   is null, only keyword phrases are generated;
/// - [tokenFilter] is a filter function that returns a subset of a collection
///   of [Token]s; and
/// - [zone] is the of the name of the zone to be appended to the [Token]s.
///
/// Returns a List<[Token]>.
typedef Tokenizer = Future<List<Token>> Function(String source,
    {NGramRange? nGramRange,
    bool preserveCase,
    String? zone,
    TokenFilter? tokenFilter});

/// Type definition of a function that returns a collection of [Token] from
/// the [zones] in a JSON [document].
///
/// Extracts tokens from the [zones] in a JSON [document] for use in
/// full-text search queries and indexes.
/// - [document] is a JSON document containing the [zones] as keys;
/// - [nGramRange] is the range of N-gram lengths to generate. If [nGramRange]
///   is null, only keyword phrases are generated;
/// - [tokenFilter] is a filter function that returns a subset of a collection
///   of [Token]s; and
/// - [zones] is the collection of the names of the zones in [document] that
///   are to be tokenized.
///
/// Returns a List<[Token]>.
typedef JsonTokenizer = Future<List<Token>> Function(
    Map<String, dynamic> document,
    {NGramRange? nGramRange,
    bool preserveCase,
    Iterable<String>? zones,
    TokenFilter? tokenFilter});

/// A filter function that returns a subset of [tokens].
typedef TokenFilter = Future<List<Token>> Function(List<Token> tokens);

/// Type definition of a function that filters characters from the [source]
/// text in preparation of tokenization.
typedef CharacterFilter = String Function(String source, [String? zone]);

/// Type definition for a hashmap of term to value, when used as a
/// n-dimensional vector in calculating cosine similarity between documents.
///
/// Alias for `Map<String, num>`.
typedef VectorSpace = Map<String, num>;
