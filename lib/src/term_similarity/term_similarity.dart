// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd

import 'package:text_analysis/type_definitions.dart';
import 'package:text_analysis/text_analysis.dart';
import 'package:text_analysis/extensions.dart';

/// A static/abstract class that exposes methods for computing similarity of
/// terms.
abstract class TermSimilarity {
  //

  /// Returns a immutable TermSimilarity for [term] and [other].
  /// - [k] is the [k]-gram length used to calculate [jaccardSimilarity],
  ///   defaults to 2.
  ///
  /// Not case-sensitive.
  factory TermSimilarity(String term, String other, {int k = 2}) {
    final editDistance = term.editDistance(other);
    final editSimilarity = _getEditSimilarity(term, other, editDistance);
    final jaccardSimilarity = term.jaccardSimilarity(other, k);
    final lengthDistance = term.lengthDistance(other);
    final lengthSimilarity = term.lengthSimilarity(other);
    final characterSimilarity = term.characterSimilarity(other);
    final startsWithSimilarity = term.startsWithSimilarity(other);
    final similarity = editSimilarity *
        jaccardSimilarity *
        lengthSimilarity *
        characterSimilarity;
    return _TermSimilarityImpl(
        term,
        other,
        similarity,
        lengthDistance,
        lengthSimilarity,
        editDistance,
        editSimilarity,
        jaccardSimilarity,
        characterSimilarity,
        startsWithSimilarity);
  }

  /// The term that is being compared to [other].
  Term get term;

  /// The term that is being compared to [term].
  Term get other;

  /// The compound similarity value on a scale of 0.0 to 1.0.
  ///
  /// Calculated as the product of [lengthSimilarity], [editSimilarity],
  /// [jaccardSimilarity] and [characterSimilarity].
  double get similarity;

  /// Compares this to other.
  ///
  /// Returns a negative number if this is less than other, zero if they are
  /// equal, and a positive number if this is greater than other.
  int compareTo(TermSimilarity other);

  /// Serializes the [TermSimilarity] to `Map<String, dynamic>`.
  Map<String, dynamic> toJson();

  /// A normalized measure of [editDistance] on a scale of 0.0 to 1.0.
  ///
  /// The [editSimilarity] is defined as the difference between the maximum
  /// edit distance (sum of the length of the [term] and [other]) and the
  /// computed [editDistance], divided by the maximum edit distance
  /// - identical terms with an edit distance of 0 equates to an edit
  ///   similarity of 1.0; and
  /// - terms with no shared characters (edit distance equal to sum of the term
  ///   lengths) have an edit similarity of 0.0.
  ///
  /// The two strings are converted to lower-case and trimmed for the
  /// comparison.
  ///
  /// Not case-sensitive.
  double get editSimilarity;

  /// Returns the similarity between the collection of letters of [term] and
  /// [other] on a scale of 0.0 to 1.0.
  ///
  /// Compares the characters in [term] and [other] by splitting each string
  /// into a set of its unique characters and finding the intersection between
  /// the two sets of characters.
  /// - Returns 1.0 if the two Strings are the same
  ///   `(term.trim().toLowerCase() == other.trim().toLowerCase())`.
  /// - Returns 1.0 if the character set for [term] and the intersection have
  ///   the same length AND [term] and [other] are the same length.
  /// - Returns 0.0 if the intersection is empty (no shared characters).
  /// - Returns the intersection length divided by the average length of the two
  ///   character sets multiplied by the length similarity.
  ///
  /// The two strings are converted to lower-case and trimmed for the
  /// comparison.
  ///
  /// Not case sensitive.
  double get characterSimilarity;

  /// Returns the similarity in length between two terms, defined as:
  /// lengthSimilarity = 1 minus the log of the ratio between the term lengths,
  /// with a floor at 0.0:
  ///     `1-(log(this.length/other.length))`
  ///
  /// Returns:
  /// - 1.0 if this and [other] are the same length; and
  /// - 0.0 if the ratio between term lengths is more than 10 or less than 0.1.
  ///
  /// The two strings are converted to lower-case and trimmed for the
  /// comparison.
  ///
  /// Not case sensitive.
  double get lengthSimilarity;

  /// Compares the starting charcters of the String with that of [other],
  /// limiting the comparison to a substring of this or [other] that is
  /// the shorter of this.length or other.length.  ///
  /// - returns 1.0 if the two strings are the same;
  /// - returns 0.0 if the two strings do not start with the same character;
  /// - returns 0.0  if either of the strings are empty, unless both are empty
  ///   (equal);
  /// - returns the edit distance between the starting characters in all other
  ///   cases.
  ///
  /// The two strings are converted to lower-case and trimmed for the
  /// comparison.
  ///
  /// Not case sensitive.
  double get startsWithSimilarity;

  /// Returns the Jaccard Similarity Index between [term] and [other].
  ///
  /// The two strings are converted to lower-case and trimmed for the
  /// comparison.
  ///
  /// Not case-sensitive.
  double get jaccardSimilarity;

  /// Returns the absolute value of the difference in length between [term]
  /// and [other].
  ///
  /// The two strings are trimmed for the calculation of lengths.
  int get lengthDistance;

  /// Returns the `Damerau–Levenshtein distance`, the minimum number of
  /// single-character edits (transpositions, insertions, deletions or
  /// substitutions) required to change [term] into [other].
  ///
  /// The two strings are converted to lower-case and trimmed for the
  /// comparison.
  ///
  /// Not case-sensitive.
  int get editDistance;

  /// Returns a ordered list of [SimilarityIndex] values of [term] to the
  /// [terms] in descending order of [SimilarityIndex.similarity].
  ///
  /// The [term] and [terms] are converted to lower-case and trimmed for the
  /// comparison.
  ///
  /// Not case-sensitive.
  static List<SimilarityIndex> editSimilarities(
          Term term, Iterable<Term> terms) =>
      term.editSimilarities(terms);

  /// Returns a hashmap of [terms] to their [editDistance] with this.
  ///
  /// The [term] and [terms] are converted to lower-case and trimmed for the
  /// comparison.
  ///
  /// Not case-sensitive.
  static Map<Term, int> editDistanceMap(Term term, Iterable<Term> terms) =>
      term.editDistanceMap(terms);

  /// Returns a ordered list of [SimilarityIndex] values for the [terms], in
  /// descending order of [SimilarityIndex.similarity].
  ///
  /// The [term] and [terms] are converted to lower-case and trimmed for the
  /// comparison.
  ///
  /// Not case-sensitive.
  static List<SimilarityIndex> lengthSimilarities(
          Term term, Iterable<Term> terms) =>
      term.lengthSimilarities(terms);

  /// Returns a ordered list of [SimilarityIndex] values for the [terms], in
  /// descending order of [SimilarityIndex.similarity].
  ///
  /// The [term] and [terms] are converted to lower-case and trimmed for the
  /// comparison.
  ///
  /// Not case-sensitive.
  static List<SimilarityIndex> startsWithSimilarities(
          Term term, Iterable<Term> terms) =>
      term.startsWithSimilarities(terms);

  /// Returns a ordered list of [SimilarityIndex] values of [term] to the
  /// [terms] in descending order of [SimilarityIndex.similarity] using a
  /// [k]-gram length of [k]. [k] defaults to 2.
  ///
  /// The [term] and [terms] are converted to lower-case and trimmed for the
  /// comparison.
  ///
  /// Not case-sensitive.
  static List<SimilarityIndex> jaccardSimilarities(
          Term term, Iterable<Term> terms,
          [int k = 2]) =>
      term.jaccardSimilarities(terms, k);

  /// Returns a ordered list of [SimilarityIndex] values for the [terms], in
  /// descending order of [SimilarityIndex.similarity].
  ///
  /// The [term] and [terms] are converted to lower-case and trimmed for the
  /// comparison.
  ///
  /// Not case-sensitive.
  static List<SimilarityIndex> characterSimilarities(
          Term term, Iterable<Term> terms) =>
      term.characterSimilarities(terms);

  /// Returns a set of (lower-case) k-grams in the [term].
  static Set<KGram> kGrams(Term term, [int k = 2]) => term.kGrams(k);

  /// Private static function to compute edit similarity from a known
  /// edit distance for two terms. Used by factory constructor.
  static double _getEditSimilarity(Term term, Term other, int editDistance) {
    final similarity = (term.length + other.length - editDistance) /
        (term.length + other.length);
    if (similarity > 1.0) {
      return 1.0;
    }
    return similarity;
  }

  /// Returns a collection of [SimilarityIndex]s for this String from [terms].
  ///
  /// Similarity is calculated for each term in [terms] by starting with 1.0
  /// and iteratively multiplying by [lengthSimilarity], [characterSimilarity],
  /// [jaccardSimilarity] and [editSimilarity], terminating the iteration as
  /// soon as the [greaterThan] threshold is reached.
  ///
  /// The default [greaterThan] is 0.10. A higher value for [greaterThan] can
  /// improve performance as candidates with different lengths to this term
  /// are not evaluated, avoiding costly computation of edit distance and or
  /// Jaccard similarity.
  ///
  /// Suggestions are returned in descending order of similarity.
  ///
  /// The top returned matches will be limited to [limit] if more than [limit]
  /// matches are found.
  ///
  /// Not case-sensitive.
  static List<SimilarityIndex> getSuggestions(String term, Iterable<Term> terms,
          {int limit = 10, int k = 2, double greaterThan = 0.10}) =>
      term.getSuggestions(terms, greaterThan: greaterThan, k: k);

  /// Returns a ordered list of [SimilarityIndex] values for the [terms], in
  /// descending order of [SimilarityIndex.similarity].
  /// - [k] is the [k]-gram length used to calculate [jaccardSimilarity],
  ///   defaults to 2.
  ///
  /// Not case-sensitive.
  static List<TermSimilarity> termSimilarities(
          String term, Iterable<Term> terms,
          {int k = 2}) =>
      term.termSimilarities(terms, k: k);

  /// Returns an hashmap of [terms] to [TermSimilarity] with [term].
  ///
  /// - [k] is the [k]-gram length used to calculate [jaccardSimilarity],
  ///   defaults to 2.
  ///
  /// Not case-sensitive.
  static Map<Term, TermSimilarity> termSimilarityMap(
    String term,
    Iterable<Term> terms, {
    int k = 2,
  }) =>
      term.termSimilarityMap(terms, k: k);

  /// Returns the best matches for a term from [terms], in descending
  /// order of term similarity (best match first).
  ///
  /// The default [greaterThan] is 0.10. A higher value for [greaterThan] can
  /// improve performance as candidates with different lengths to this term
  /// are not evaluated, avoiding costly computation of edit distance and or
  /// Jaccard similarity.
  ///
  /// Suggestions are returned in descending order of similarity.
  ///
  /// The top returned matches will be limited to [limit] if more than [limit]
  /// matches are found.
  ///
  /// Not case-sensitive.
  static List<Term> matches(String term, Iterable<Term> terms,
          {int limit = 10, int k = 2, double greaterThan = 0.10}) =>
      term.matches(terms, k: k, limit: limit, greaterThan: greaterThan);
}

/// Mixin class that implements the `==` operator, [compareTo], [hashCode] and
/// [toJson].
abstract class TermSimilarityMixin implements TermSimilarity {
  //

  /// Returns true if [runtimeType], [term] and [similarity] are equal.
  @override
  bool operator ==(Object other) =>
      other is TermSimilarity &&
      term == other.term &&
      this.other == other.other &&
      characterSimilarity == other.characterSimilarity &&
      editDistance == other.editDistance &&
      editSimilarity == other.editSimilarity &&
      lengthDistance == other.lengthDistance &&
      lengthSimilarity == other.lengthSimilarity &&
      jaccardSimilarity == other.jaccardSimilarity &&
      similarity == other.similarity;

  @override
  int get hashCode => Object.hash(
      term,
      other,
      characterSimilarity,
      editSimilarity,
      editDistance,
      lengthDistance,
      lengthSimilarity,
      jaccardSimilarity,
      similarity);

  @override
  int compareTo(TermSimilarity other) {
    if (term.toLowerCase() == this.other.toLowerCase()) return 0;
    return similarity == other.similarity
        ? 0
        : similarity > other.similarity
            ? 1
            : -1;
  }

  @override
  Map<String, dynamic> toJson() => {
        'term': term,
        'other': other,
        'characterSimilarity': characterSimilarity,
        'editDistance': editDistance,
        'editSimilarity': editSimilarity,
        'lengthDistance': lengthDistance,
        'lengthSimilarity': lengthSimilarity,
        'jaccardSimilarity': jaccardSimilarity,
        'similarity': similarity
      };
}

/// Implementation class for TermSimilarity unnamed factory constructor.
abstract class TermSimilarityBase with TermSimilarityMixin {}

/// Implementation class for TermSimilarity unnamed factory constructor.
class _TermSimilarityImpl extends TermSimilarityBase {
  //

  @override
  final double characterSimilarity;

  @override
  final int editDistance;

  @override
  final double jaccardSimilarity;

  @override
  final int lengthDistance;

  @override
  final double editSimilarity;

  @override
  final double lengthSimilarity;

  @override
  final Term other;

  @override
  final Term term;

  _TermSimilarityImpl(
      this.term,
      this.other,
      this.similarity,
      this.lengthDistance,
      this.lengthSimilarity,
      this.editDistance,
      this.editSimilarity,
      this.jaccardSimilarity,
      this.characterSimilarity,
      this.startsWithSimilarity);

  @override
  final double similarity;

  @override
  final double startsWithSimilarity;

  //
}

/// Extension methods on collection of [SimilarityIndex].
extension TermSimilarityCollectionExtension on Iterable<TermSimilarity> {
//

  /// Returns the first [limit] instances of the collection.
  ///
  /// Returns the entire collection as an ordered list if [limit] is null.
  List<TermSimilarity> limit([int? limit = 10]) {
    final list = List<TermSimilarity>.from(this);
    return (limit != null && list.length > limit)
        ? list.sublist(0, limit)
        : list;
  }

  /// Sorts the collection of [SimilarityIndex] instances in descending
  /// order of [SimilarityIndex.similarity].
  List<TermSimilarity> sortBySimilarity([bool descending = true]) {
    final list = List<TermSimilarity>.from(this);
    if (descending) {
      list.sort(((a, b) => b.compareTo(a)));
    } else {
      list.sort(((a, b) => a.compareTo(b)));
    }
    return list;
  }
}
