// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

/// A [Token] represents a [term] (word) present in a text source with its
/// 0-based [index] (position of first character) in the source text.
class Token {
  //

  /// Instantiates [Token] with default values:
  /// - [term] - empty string; and
  /// - [index] - 0.
  static const empty = Token('', 0, 0.0);

  /// Instantiates [Token] with [term] and [index] values.
  const Token(this.term, this.index, this.position);

  /// The term/word associated with this token.
  final String term;

  /// The 0-based position of the start of the first character of [term] in the
  /// source text string.
  final int index;

  /// Returns the position of the term from the start of the source text
  /// as a fraction of the source text length.
  ///
  /// The [position] can be used as a proxy of term relevance in the
  /// source text.
  ///
  /// A position of 0.0 means the term is at the start of the source text.
  final double position;

  /// Compares whether:
  /// - [other] is [Token];
  /// - [position] == [other].position;
  /// - [term] == [other].term; and
  /// - [index] == [other].index.
  @override
  bool operator ==(Object other) =>
      other is Token &&
      term == other.term &&
      index == other.index &&
      position == other.position;

  @override
  int get hashCode => Object.hash(term, index, position);

  //
}

/// Extension methods on a collection of [Token].
extension TokenCollectionExtension on Iterable<Token> {
//

  /// Returns the set of unique terms from the collection of [Token]s.
  Set<String> get terms => Set<String>.from(map((e) => e.term));

  /// Filters the collection for tokens with [Token.term] == [term].
  ///
  /// Orders the filtered [Token]s by [Token.index] in ascending order.
  Iterable<Token> byTerm(String term) {
    final tokens = where((element) => element.term == term).toList();
    tokens.sort((a, b) => a.index.compareTo(b.index));
    return tokens;
  }

  /// Returns the count where [Token.term] == [term].
  int termCount(String term) => byTerm(term).length;

  /// Returns the highest [Token.index] where [Token.term] == [term].
  int maxIndex(String term) => byTerm(term).last.index;

  /// Returns the lowest [Token.index] where [Token.term] == [term].
  int minIndex(String term) => byTerm(term).first.index;
}
