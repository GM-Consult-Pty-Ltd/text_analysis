// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'package:text_analysis/text_analysis.dart';

/// A [Token] represents a [term] (word) present in a text source:
/// - [term] is the term that will be looked up in the index;
/// - [termPosition] is the zero-based position of the [term] in an ordered
///   list of all the terms in the source text;
/// - [field] is the nullable name of the field the [term] is in;
class Token {
  //

  /// Instantiates [Token] instance.
  static const empty = Token('', 0, null);

  /// Instantiates [Token] instance:
  /// - [term] is the term that will be looked up in the index;
  /// - [termPosition] is the zero-based position of the [term] in an ordered
  ///   list of all the terms in the source text;
  /// - [field] is the nullable / optional name of the field the [term] is in;
  const Token(this.term, this.termPosition, [this.field]);

  /// The term that will be looked up in the index. The [term] is extracted
  /// from the query phrase by [TextAnalyzer] and may not match the String in
  /// the phrase exactly.
  final String term;

  /// The name of the field in the document that the [term] is in.
  final String? field;

  /// The zero-based position of the [term] in an ordered list of all the terms
  /// in the source text.
  final int termPosition;

  /// Compares whether:
  /// - [other] is [Token];
  /// - [field] == [other].field;
  /// - [term] == [other].term; and
  /// - [termPosition] == [other].termPosition.
  @override
  bool operator ==(Object other) =>
      other is Token &&
      term == other.term &&
      field == other.field &&
      termPosition == other.termPosition;

  @override
  int get hashCode => Object.hash(term, field, termPosition);

  //
}

/// Extension methods on a collection of [Token].
extension TokenCollectionExtension on Iterable<Token> {
//

  /// Returns the set of unique terms from the collection of [Token]s.
  Set<String> get terms => Set<String>.from(map((e) => e.term));

  /// Filters the collection for tokens with [Token.term] == [term].
  ///
  /// Orders the filtered [Token]s by [Token.termPosition] in ascending order.
  Iterable<Token> byTerm(String term) {
    final tokens = where((element) => element.term == term).toList();
    tokens.sort((a, b) => a.termPosition.compareTo(b.termPosition));
    return tokens;
  }

  /// Returns the count where [Token.term] == [term].
  int termCount(String term) => byTerm(term).length;

  /// Returns the highest [Token.termPosition] where [Token.term] == [term].
  @Deprecated('The [maxIndex] extension method will be removed.')
  int lastPosition(String term) => byTerm(term).last.termPosition;

  /// Returns the lowest [Token.termPosition] where [Token.term] == [term].
  int firstPosition(String term) => byTerm(term).first.termPosition;
}
