// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

// ignore_for_file: camel_case_types

import '_index.dart';
import 'dart:math';

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

  /// Returns a hashmap of [terms] to their [editSimilarity] with [term].
  ///
  /// Not case-sensitive.
  static Map<Term, double> editSimilarityMap(Term term, Iterable<Term> terms) =>
      term.editSimilarityMap(terms);

  /// Returns a hashmap of [terms] to their [editDistance] with this.
  ///
  /// Not case-sensitive.
  static Map<Term, int> editDistanceMap(Term term, Iterable<Term> terms) =>
      term.editDistanceMap(terms);

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

  /// Returns a hashmap of [terms] to their [lengthSimilarity] with [term].
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

/// Extension methods on [Term] that exposes methods for computing similarity
/// of terms.
extension TermSimilarityExtensions on Term {
  //

  /// A normalized measure of [editDistance] on a scale of 0.0 to 1.0.
  ///
  /// The [editSimilarity] is defined as the difference between the maximum
  /// edit distance (sum of the length of the two terms) and the
  /// computed [editDistance], divided by the maximum edit distance:
  /// - identical terms with an edit distance of 0 equates to an edit
  ///   similarity of 1.0; and
  /// - terms with no shared characters (edit distance equal to sum of the term
  ///   lengths) have an edit similarity of 0.0.
  ///
  /// Not case-sensitive.
  double editSimilarity(Term other) =>
      (length + other.length - editDistance(other)) / (length + other.length);

  /// Returns a hashmap of [terms] to their [editSimilarity] with this.
  ///
  /// Not case-sensitive.
  Map<Term, double> editSimilarityMap(Iterable<Term> terms) {
    final retVal = <Term, double>{};
    for (var other in terms) {
      retVal[other] = editSimilarity(other);
    }
    return retVal;
  }

  /// Returns a hashmap of [terms] to their [editDistance] with this.
  ///
  /// Not case-sensitive.
  Map<Term, int> editDistanceMap(Iterable<Term> terms) {
    final retVal = <Term, int>{};
    for (var other in terms) {
      retVal[other] = editDistance(other);
    }
    return retVal;
  }

  /// Returns the `Damerau–Levenshtein distance`, the minimum number of
  /// single-character edits (transpositions, insertions, deletions or
  /// substitutions) required to change one word into another [other].
  ///
  /// Not case-sensitive.
  int editDistance(Term other) {
    //

    // initialize a 1-based array of 26 integers with all values set to 0
    final da = _Da();

    // initialize a 1-based character array for this
    final a = _CharArray(toLowerCase());

    // initialize a 1-based character array for other
    final b = _CharArray(other.toLowerCase());

    // initialize the -1 based edit distance matrix
    final dList = <List<int>>[];
    for (var i = 0; i < b.length + 2; i++) {
      dList.add(List.filled(a.length + 2, i * 0, growable: false));
    }
    final d = _Matrix.from(dList, i: -1, j: -1);

    // compute the maximum distance
    // (remove all the charcters in this and insert with all characters in other)
    final maxDist = a.length + b.length;

    // add maxDist at the top-left of matrix
    d.setAt(-1, -1, maxDist);

    for (var i = 0; i <= a.length; i++) {
      d.setAt(i, -1, maxDist);
      d.setAt(i, 0, i);
    }

    for (var j = 0; j <= b.length; j++) {
      d.setAt(-1, j, maxDist);
      d.setAt(0, j, j);
    }

    for (var i = 1; i <= a.length; i++) {
      var db = 0;
      final charA = a.get(i) - 96;

      for (var j = 1; j <= b.length; j++) {
        final charB = b.get(j) - 96;
        final k = da.get(charB);
        final l = db;
        int cost = 0;
        if (charA == charB) {
          cost = 0;
          db = j;
        } else {
          cost = 1;
        }
        final costs = <int>[
          //substitution cost
          d.get(i - 1, j - 1) + cost,
          //insertion cost
          d.get(i, j - 1) + 1,
          //deletion cost
          d.get(i - 1, j) + 1,
          //transposition cost
          d.get(k - 1, l - 1) + (i - k - 1) + 1 + (j - l - 1)
        ];
        costs.sort(((a, b) => a.compareTo(b)));
        d.setAt(i, j, costs.first);
      }
      da.setAt(charA, i);
    }

    // return the value from the edit distance matrix matrix
    return d.get(a.length, b.length);
  }

  /// Returns the absolute value of the difference in length between two terms.
  int lengthDistance(Term other) => (length - other.length).abs();

  /// Returns the similarity in length between two terms, defined as:
  /// lengthSimilarity = 1 minus the log of the ratio between the term lengths,
  /// with a floor at 0.0:
  ///     `1-(log(this.length/other.length))`
  ///
  /// Returns:
  /// - 1.0 if this and [other] are the same length; and
  /// - 0.0 if the ratio between term lengths is more than 10 or less than 0.1.
  double lengthSimilarity(Term other) {
    final logRatio = isEmpty
        ? other.isEmpty
            ? 0
            : 1
        : other.isEmpty
            ? 1
            : (log(other.length / length)).abs();
    return logRatio > 1 ? 0.0 : 1.0 - logRatio;
  }

  /// Returns a hashmap of [terms] to their [lengthSimilarity] with this.
  Map<Term, double> lengthSimilarityMap(Iterable<Term> terms) {
    final retVal = <Term, double>{};
    for (var other in terms) {
      retVal[other] = lengthSimilarity(other);
    }
    return retVal;
  }

  /// Returns the Jaccard Similarity Index between this term and [other]
  /// using a [k]-gram length of [k].
  ///
  /// Not case-sensitive.
  double jaccardSimilarity(Term other, [int k = 2]) =>
      _jaccardSimilarity(kGrams(k), other, k);

  double _jaccardSimilarity(Set<String> termGrams, Term other, int k) {
    final otherGrams = other.kGrams(k);
    final intersection = termGrams.intersection(otherGrams);
    final union = termGrams.union(otherGrams);
    return intersection.length / union.length;
  }

  /// Returns a hashmap of [terms] to Jaccard Similarity Index with this term
  /// using a [k]-gram length of [k].
  ///
  /// Not case-sensitive.
  Map<Term, double> jaccardSimilarityMap(Iterable<Term> terms, [int k = 2]) {
    final retVal = <Term, double>{};
    final termGrams = kGrams(k);
    for (final other in terms) {
      retVal[other] = _jaccardSimilarity(termGrams, other, k);
    }
    return retVal;
  }

  /// Returns a similarity index value between 0.0 and 1.0 using a [k]-gram
  /// length of [k].
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
  double termSimilarity(Term other, [int k = 2]) =>
      (jaccardSimilarity(other, k) * lengthSimilarity(other)) *
      editSimilarity(other);

  /// Returns a hashmap of [terms] to [termSimilarity] with this term using
  /// a [k]-gram length of [k].
  ///
  /// Not case-sensitive.
  Map<Term, double> termSimilarityMap(Iterable<Term> terms, [int k = 2]) {
    final retVal = <Term, double>{};
    final termGrams = kGrams(k);
    for (final other in terms) {
      retVal[other] =
          (_jaccardSimilarity(termGrams, other, k) * termSimilarity(other)) *
              editSimilarity(other);
    }
    return retVal;
  }

  /// Returns the best matches for a term from [terms], in descending
  /// order of [termSimilarity] (best match first).
  ///
  /// Only matches with a [termSimilarity] > 0.0 are returned.
  ///
  /// The returned matches will be limited to [limit] if more than [limit]
  /// matches are found.
  ///
  /// Not case-sensitive.
  List<Term> matches(Iterable<Term> terms, {int k = 2, int limit = 10}) {
    final similarities = termSimilarityMap(terms);
    final entries =
        similarities.entries.where((element) => element.value > 0).toList();
    entries.sort(((a, b) => b.value.compareTo(a.value)));
    final retVal = entries.map((e) => e.key).toList();
    return retVal.length > limit ? retVal.sublist(0, limit) : retVal;
  }

  /// Returns a set of (lower-case) k-grams in the term.
  Set<KGram> kGrams([int k = 2]) {
    final Set<KGram> kGrams = {};
    final term = toLowerCase();
    if (isNotEmpty) {
      // get the opening k-gram
      kGrams.add(r'$' + term.substring(0, length < k ? null : k - 1));
      // get the closing k-gram
      kGrams.add(length < k ? term : (term.substring(length - k + 1)) + r'$');
      if (length <= k) {
        kGrams.add(term);
      } else {
        for (var i = 0; i <= length - k; i++) {
          kGrams.add(term.substring(i, i + k));
        }
      }
    }
    return kGrams;
  }
}



/// A 1-based, 1-dimensional array of integers, 26 charcters in length.
class _Da extends _Array<int> {
  //

  _Da() : super(List<int>.generate(26, (index) => 0), 1);
}

/// Splits a [Term] into characters and places them in a 1-based array.
class _CharArray extends _Array<int> {
  //

  /// The term used to construct the termChars
  final String term;

  _CharArray(this.term)
      : super(
            term
                .toLowerCase()
                .trim()
                .replaceAll(RegExp(r'[^a-z]'), '')
                .codeUnits
                .map((e) => e.toInt())
                .toList(),
            1);
}

/// A [i]-based, 1-dimensional array of [T].
class _Array<T extends Object> {
  //

  /// The index of the first element of the array.
  final int i;

  /// Returns the number of elements in the array.
  int get length => elements.length;

  /// The elements of the array as a zero-based ordered collection of [T].
  final List<T> elements;

  /// Instantiate a [i]-based [_Array] from the [elements].
  const _Array(this.elements, [this.i = 0]);

  T get(int index) => elements[index - i];

  void setAt(int index, T value) => elements[index - i] = value;
}

/// A two-dimensional array ([i], [j]) - based two dimensional array
class _Matrix<T extends Object> {
  //

  /// The base index of the matrix rows.
  final int j;

  /// the base index of the matrix columns
  final int i;

  /// The number of rows in the matrix.
  int get rowCount => elements.length;

  final _Array<_Array<T>> elements;

  /// The number of columns in the matrix.
  int get columnCount {
    final lengths = elements.elements.map((e) => e.length).toList();
    if (lengths.isNotEmpty) {
      lengths.sort(((a, b) => b.compareTo(a)));
      return lengths.first;
    }
    return 0;
  }

  const _Matrix._(this.elements, this.i, this.j);

  // /// Unnamed factory constructor initializes an empty [_Matrix].
  // factory _Matrix(int i, int j) {
  //   return _Matrix._(_Array([], j), i, j);
  // }

  T get(int x, int y) => elements.get(y).get(x);

  void setAt(int i, int j, T value) {
    final jValue =
        elements.length > j - this.j ? elements.get(j) : _Array(<T>[], this.j);
    jValue.setAt(i, value);
    elements.setAt(j, jValue);
  }

  void setRowAt(int y, List<T> row) {
    elements.setAt(y, _Array(row, i));
  }

  /// Factory [_Matrix.from] initializes a [_Matrix]
  /// and populates it with [value].
  ///
  /// Provide the index of the first element of each dimension (defaults to
  /// i=0 and j=0).
  // ignore: unused_element
  factory _Matrix.from(List<List<T>> value, {int i = 0, int j = 0}) {
    final _Array<_Array<T>> elements = _Array([], j);
    for (final e in value) {
      elements.elements.add(_Array(e, i));
    }
    return _Matrix._(elements, i, j);
  }
}
