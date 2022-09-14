// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'dart:async';
import 'package:text_analysis/text_analysis.dart';

/// A stemmer function that returns the stem of [term].
typedef Stemmer = String Function(String term);

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
typedef TermSplitter = List<String> Function(String source);

/// A splitter function that returns a list of sentences from [source].
///
/// In English, the [source] text is split at sentence endings marks such as
/// periods, question marks and exclamation marks.
///
/// The sentence splitter should avoid splitting after abbreviations,
/// which may end with period marks.
typedef SentenceSplitter = List<String> Function(String source);

/// A filter function that returns a collection of terms from term:
/// - return an empty collection if the term is to be excluded from analysis;
/// - return multiple terms if the term is split; and/or
/// - return modified term(s), such as applying a stemmer algorithm.
typedef TermFilter = Future<List<String>> Function(String term);

/// A filter function that returns a subset of [tokens].
typedef TokenFilter = Future<List<Token>> Function(List<Token> tokens);

/// Type definition of a function that filters characters from the [source]
/// text in preparation of tokenization.
typedef CharacterFilter = String Function(String source);

/// Type definition of a function that returns a collection of [Token] from
/// the [source] text.
///
/// Optional parameter [field] is the name of the field in a document in
/// which the term is located.
typedef Tokenizer = Future<Iterable<Token>> Function(String source,
    [String? field]);

/// Type definition of a function that returns a collection of [Token] from
/// the [fields] in a [json] document.
typedef JsonTokenizer = Future<Iterable<Token>> Function(
    Map<String, dynamic> json, List<String> fields);
