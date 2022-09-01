// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

/// A [Token] represents a [term] (word) present in a text source with its
/// 0-based [index] (position of first character) in the source text.
abstract class Token {
  //

  /// Instantiates [Token] with default values:
  /// - [term] - empty string; and
  /// - [index] - 0.
  static const empty = _TokenImpl('', 0);

  /// Instantiates [Token] with [term] and [index] values.
  factory Token(String term, int index) => _TokenImpl(term, index);

  /// The term for this token.
  ///
  /// Default is an empty String.
  String get term;

  /// The 0-based position of the start of the [term] in the source text
  /// (sentence).
  ///
  /// Default is 0.
  int get index;

  //
}

/// Implementation class for [Token].
class _TokenImpl implements Token {
  //

  @override
  final String term;

  @override
  final int index;

  /// Instantiates a const [_TokenImpl]
  const _TokenImpl(this.term, this.index);

  //
}
