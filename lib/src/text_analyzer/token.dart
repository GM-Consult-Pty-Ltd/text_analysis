// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'dart:math';
import 'package:text_analysis/text_analysis.dart';

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

/// Extension methods on [Term].
extension KGramParserExtension on Term {
  //

  /// Returns a normalized measure of difference between this [Term] and
  /// [other] on a log (base 2) scale:
  /// - returns 0.0 if [other] and this are the same length;
  /// - returns 0.0 if both this and [other] are empty;
  /// - returns 999.0 if this or [other] is empty, but not both;
  /// - returns 1.0 if [other] is twice as long, or half as long as this;
  ///
  /// `abs(log2(other.length/this.length)`
  double lengthDistance(Term other) => isEmpty
      ? other.isEmpty
          ? 0
          : 999
      : other.isEmpty
          ? 999
          : (log(other.length / length) / log(2)).abs();

  /// Returns the similarity in length between this string and [other] where:
  /// lengthSimilarity = 1 - [lengthDistance] if [lengthDistance].
  ///
  /// Returns:
  /// - 1.0 if this and [other] are the same length; and
  /// - 0.0 if [lengthDistance] >= 1.0, i.e when [other.length] is less than
  ///   50% or more than 200% of [length].
  double lengthSimilarity(Term other) {
    final ld = lengthDistance(other);
    return ld > 1 ? 0 : 1 - ld;
  }

  /// Returns a hashmap of [terms] to their [lengthSimilarity] with this.
  Map<Term, double> lengthSimilarityMap(Iterable<Term> terms) {
    final retVal = <Term, double>{};
    for (var other in terms) {
      retVal[other] = lengthSimilarity(other);
    }
    return retVal;
  }

  /// Returns the Jaccard Similarity Index between this term  and [other]
  /// using a k-gram length of [k].
  double jaccardSimilarity(Term other, [int k = 3]) {
    final termGrams = kGrams(k);
    final otherGrams = other.kGrams(k);
    final intersection = termGrams.intersection(otherGrams);
    final union = termGrams.union(otherGrams);
    return intersection.length / union.length;
  }

  /// Returns a hashmap of [terms] to Jaccard Similarity Index with this term
  /// using a k-gram length of [k].
  Map<Term, double> jaccardSimilarityMap(Iterable<Term> terms, [int k = 3]) {
    final retVal = <Term, double>{};
    final termGrams = kGrams(k);
    for (final other in terms) {
      final otherGrams = other.kGrams(k);
      final intersection = termGrams.intersection(otherGrams);
      final union = termGrams.union(otherGrams);
      retVal[other] = intersection.length / union.length;
    }
    return retVal;
  }

  /// Returns a set of k-grams in the term.
  Set<KGram> kGrams([int k = 3]) {
    final Set<KGram> kGrams = {};
    if (isNotEmpty) {
      // get the opening k-gram
      kGrams.add(r'$' + substring(0, length < k ? null : k - 1));
      // get the closing k-gram
      kGrams.add(length < k ? this : (substring(length - k + 1)) + r'$');
      if (length <= k) {
        kGrams.add(this);
      } else {
        for (var i = 0; i <= length - k; i++) {
          kGrams.add(substring(i, i + k));
        }
      }
    }
    return kGrams;
  }
}

/// Extension methods on a collection of [Token].
extension TokenCollectionExtension on Iterable<Token> {
//

  /// Returns a hashmap of k-grams to terms from the collection of tokens.
  Map<KGram, Set<Term>> kGrams([int k = 3]) {
    final terms = this.terms;
    // print the terms
    final Map<String, Set<Term>> kGramIndex = {};
    for (final term in terms) {
      final kGrams = term.kGrams(k);
      for (final kGram in kGrams) {
        final set = kGramIndex[kGram] ?? {};
        set.add(term);
        kGramIndex[kGram] = set;
      }
    }
    return kGramIndex;
  }

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
