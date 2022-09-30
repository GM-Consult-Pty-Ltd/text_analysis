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
  ///
  /// Not case-sensitive.
  static int editDistance(Term a, Term b) => a.editDistance(b);

  /// A normalized measure of [editDistance] on a scale of 0.0 to 1.0.
  ///
  /// The [editSimilarity] is defined as the difference between the maximum
  /// edit distance (sum of the length of the [a] and [b]) and the
  /// computed [editDistance], divided by the maximum edit distance
  /// - identical terms with an edit distance of 0 equates to an edit
  ///   similarity of 1.0; and
  /// - terms with no shared characters (edit distance equal to sum of the term
  ///   lengths) have an edit similarity of 0.0.
  ///
  /// Not case-sensitive.
  static double editSimilarity(Term a, Term b) => a.editSimilarity(b);

  /// Returns the absolute value of the difference in length between [a]
  /// and [b].
  static int lengthDistance(Term a, Term b) => a.lengthDistance(b);

  /// Returns the similarity in length between two terms, defined as:
  /// lengthSimilarity = 1 minus the log of the ratio between the term lengths,
  /// with a floor at 0.0:
  ///     `1-(log(this.length/other.length))`
  ///
  /// Returns:
  /// - 1.0 if this and [other] are the same length; and
  /// - 0.0 if the ratio between term lengths is more than 10 or less than 0.1.
  static double lengthSimilarity(Term a, Term b) => a.lengthSimilarity(b);

  /// Returns a hashmap of [terms] to their [lengthSimilarity] with [term] using
  /// a [k]-gram length of [k].
  static Map<Term, double> lengthSimilarityMap(
          Term term, Iterable<Term> terms) =>
      term.lengthSimilarityMap(terms);

  /// Returns the Jaccard Similarity Index between [a] and [b]
  /// using a [k]-gram length.
  ///
  /// Not case-sensitive.
  static double jaccardSimilarity(Term a, Term b, [int k = 2]) =>
      a.jaccardSimilarity(b);

  /// Returns a hashmap of [terms] to Jaccard Similarity Index with [term]
  /// using a [k]-gram length.
  ///
  /// Not case-sensitive.
  static Map<Term, double> jaccardSimilarityMap(Term term, Iterable<Term> terms,
          [int k = 2]) =>
      term.jaccardSimilarityMap(terms, k);

  /// Returns a normalized similarity index value between 0.0 and 1.0 for terms
  /// [a] and [b] using a [k]-gram length of [k].
  ///
  /// The [termSimilarity] is defined as the product of [jaccardSimilarity],
  /// [lengthSimilarity] and [editSimilarity].
  ///
  /// A term similarity of 1.0 means the two terms are identical:
  /// - have the same characters in the same order (edit distance of 0);
  /// - are of equal in length; and
  /// - have an identical collection of [k]-grams.
  ///
  /// Not case-sensitive.
  static double termSimilarity(Term a, Term b, [int k = 2]) =>
      a.termSimilarity(b, k);

  /// Returns a hashmap of [candidates] to [termSimilarity] with [term] using
  /// a [k]-gram length of [k].
  ///
  /// Not case-sensitive.
  static Map<Term, double> termSimilarityMap(
          Term term, Iterable<Term> candidates,
          [int k = 2]) =>
      term.termSimilarityMap(candidates, k);

  /// Returns the best matches for [term] from [candidates], in descending
  /// order of [termSimilarity] (best match first).
  ///
  /// Only matches with a [termSimilarity] > 0.0 are returned.
  ///
  /// The returned matches will be limited to [limit] if more than [limit]
  /// matches are found.
  ///
  /// Not case-sensitive.
  static List<Term> matches(Term term, Iterable<Term> candidates,
          {int k = 2, int limit = 10}) =>
      term.matches(candidates, k: k, limit: limit);

  /// Returns a set of (lower-case) k-grams in the [term].
  static Set<KGram> kGrams(Term term, [int k = 2]) => term.kGrams(k);

  //
}
