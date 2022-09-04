// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

/// A [Token] represents a [term] (word) present in a text source with its
/// 0-based [index] (position of first character) in the source text.
class Token {
  //

  /// Instantiates [Token] with default values:
  /// - [term] - empty string; and
  /// - [index] - 0.
  static const empty = Token('', 0);

  /// Instantiates [Token] with [term] and [index] values.
  const Token(this.term, this.index);

  /// The term for this token.
  ///
  /// Default is an empty String.
  final String term;

  /// The 0-based position of the start of the [term] in the source text
  /// (sentence).
  ///
  /// Default is 0.
  final int index;

  //
}
