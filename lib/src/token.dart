// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd

import '_index.dart';

/// A [Token] represents a [term] (word) present in a text source:
/// - [term] is the term that will be looked up in the index;
/// - [termPosition] is the zero-based position of the [term] in an ordered
///   list of all the terms in the source text;
/// - [zone] is the nullable name of the zone the [term] is in;
class Token {
  //

  /// Instantiates [Token] instance.
  static const empty = Token('', 0, null);

  /// Instantiates [Token] instance:
  /// - [term] is the term that will be looked up in the index;
  /// - [termPosition] is the zero-based position of the [term] in an ordered
  ///   list of all the terms in the source text;
  /// - [zone] is the nullable / optional name of the zone the [term] is in;
  const Token(this.term, this.termPosition, [this.zone]);

  /// The term that will be looked up in the index. The [term] is extracted
  /// from the query phrase by [TextTokenizer] and may not match the String in
  /// the phrase exactly.
  final Term term;

  /// The name of the zone in the document that the [term] is in.
  final Zone? zone;

  /// The zero-based position of the [term] in an ordered list of all the terms
  /// in the source text.
  final int termPosition;

  /// Compares whether:
  /// - [other] is [Token];
  /// - [zone] == [other].zone;
  /// - [term] == [other].term; and
  /// - [termPosition] == [other].termPosition.
  @override
  bool operator ==(Object other) =>
      other is Token &&
      term == other.term &&
      zone == other.zone &&
      termPosition == other.termPosition;

  @override
  int get hashCode => Object.hash(term, zone, termPosition);

  //
}

/// Extension methods on a collection of [Token].
extension TokenCollectionExtension on Iterable<Token> {
//

  /// Returns a hashmap of k-grams to terms from the collection of tokens.
  Map<KGram, Set<Term>> kGrams([int k = 2]) => terms.toKGramsMap(k);

  /// Returns the set of unique terms from the collection of [Token]s.
  Set<String> get terms => Set<String>.from(map((e) => e.term));

  /// Returns a list of all the terms from the collection of [Token]s, in
  /// the same order as they occur in the [SourceText].
  List<String> get allTerms {
    final allTerms = List<Token>.from(this);
    allTerms.sort(((a, b) => a.termPosition.compareTo(b.termPosition)));
    return allTerms.map((e) => e.term).toList();
  }

  /// Filters the collection for tokens with [Token.term] == [term].
  ///
  /// Orders the filtered [Token]s by [Token.termPosition] in ascending order.
  Iterable<Token> byTerm(Term term) {
    final tokens = where((element) => element.term == term).toList();
    tokens.sort((a, b) => a.termPosition.compareTo(b.termPosition));
    return tokens;
  }

  /// Returns the count where [Token.term] == [term].
  int termCount(Term term) => byTerm(term).length;

  /// Returns the highest [Token.termPosition] where [Token.term] == [term].
  @Deprecated('The [maxIndex] extension method will be removed.')
  int lastPosition(Term term) => byTerm(term).last.termPosition;

  /// Returns the lowest [Token.termPosition] where [Token.term] == [term].
  int firstPosition(Term term) => byTerm(term).first.termPosition;
}
