// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

// ignore_for_file: camel_case_types

import 'package:text_analysis/type_definitions.dart';
import 'package:text_analysis/extensions.dart';

/// A static/abstract class that exposes methods for computing similarity of
/// terms.
abstract class TermSimilarity {
  //

  /// Returns the `Damerau–Levenshtein distance`, the minimum number of
  /// single-character edits (transpositions, insertions, deletions or
  /// substitutions) required to change one word ([a]) into another [b].
  static int editDistance(Term a, Term b) => a.editDistance(b);

  /// Returns a normalized measure of difference between [a] and
  /// [b] on a log (base 2) scale:
  /// - returns 0.0 if [a] and [b] are the same length;
  /// - returns 0.0 if both [a] and [b] are empty;
  /// - returns 999.0 if [a] or [b] is empty, but not both;
  /// - returns 1.0 if [b] is twice as long, or half as long as [a];
  ///
  /// `abs(log2(b.length/a.length)`
  static double lengthDistance(Term a, Term b) => a.lengthDistance(b);

  /// Returns the similarity in length between strings [a] and [b] where:
  /// lengthSimilarity = 1 - [lengthDistance].
  ///
  /// Returns:
  /// - 1.0 if [a] and [b] are the same length; and
  /// - 0.0 if [lengthDistance] >= 1.0, i.e when [b].length is less than
  ///   50% or more than 200% of [a].length.
  double lengthSimilarity(Term a, Term b) => a.lengthSimilarity(b);

  /// Returns a hashmap of [terms] to their [lengthSimilarity] with [term].
  Map<Term, double> lengthSimilarityMap(Term term, Iterable<Term> terms) =>
      term.lengthSimilarityMap(terms);

  /// Returns the Jaccard Similarity Index between [a] and [b]
  /// using a [k]-gram length.
  double jaccardSimilarity(Term a, Term b, [int k = 2]) =>
      a.jaccardSimilarity(b);

  /// Returns a hashmap of [terms] to Jaccard Similarity Index with [term]
  /// using a [k]-gram length.
  Map<Term, double> jaccardSimilarityMap(Term term, Iterable<Term> terms,
          [int k = 2]) =>
      term.jaccardSimilarityMap(terms, k);

  /// Returns a normalized similarity index value between 0.0 and 1.0 for terms
  /// [a] and [b].
  ///
  /// It is defined as:
  /// - ([jaccardSimilarity] * [lengthSimilarity]) / [editDistance].
  ///
  /// A term similarity of 1.0 means the two terms are:
  /// - equal in length; and
  /// - have an identical collection of [k]-grams (default [k] = 2).
  double termSimilarity(Term a, Term b, [int k = 2]) => a.termSimilarity(b, k);

  /// Returns the best matches for [term] from [candidates], in descending
  /// order of [termSimilarity] (best match first).
  ///
  /// Only matches with a [termSimilarity] > 0.0 are returned.
  ///
  /// The returned matches will be limited to [limit] if more than [limit]
  /// matches are found.
  List<Term> matches(Term term, Iterable<Term> candidates,
          {int k = 2, int limit = 10}) =>
      term.matches(candidates, k: k, limit: limit);

  /// Returns a set of k-grams in the term.
  Set<KGram> kGrams(Term term, [int k = 2]) => term.kGrams(k);

  //
}
