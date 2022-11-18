// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd

import 'dart:async';
import 'package:text_analysis/text_analysis.dart';

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
    {NGramRange? nGramRange, String? zone, TokenFilter? tokenFilter});

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
