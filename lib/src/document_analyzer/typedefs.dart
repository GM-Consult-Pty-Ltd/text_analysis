// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

/// A stemmer function that returns the stem of [term].
typedef Stemmer = String Function(String term);

/// A splitter function that returns a list of terms from [source].
///
/// Typically, [source] split at punctuation marks and white space.
///
/// The term splitter should avoid splitting numbers, which may contain
/// period marks or other punctuation delimited phrases such as domain names
/// and identifiers and hyphenated words.
///
/// If the [TermSplitter] preserves punctuation delimited phrases, the
/// tokenizer that uses the [TermSplitter] can include both the
/// preserved/delimited term as well as its components as separate tokens.
typedef TermSplitter = List<String> Function(String source);

/// A filter function that returns a subset of [terms].
typedef TermFilter = List<String> Function(List<String> terms);
