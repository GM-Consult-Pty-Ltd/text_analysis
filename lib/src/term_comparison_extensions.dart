// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

// ignore_for_file: camel_case_types

import 'dart:math';
import 'package:text_analysis/src/_index.dart';

/// Extension methods on [Term].
extension TermComparisonExtensions on Term {
  //

  /// Returns the minimum number of single-character edits (transpositions,
  /// insertions, deletions or substitutions) required to change one word into
  /// the other.
  ///
  /// Known as the `Damerau–Levenshtein distance` in information retrieval
  /// theory.
  int editDistance(Term other) {
    //

    // initialize a 1-based array of 26 integers with all values set to 0
    final da = _da();

    // initialize a 1-based character array for this
    final a = _CharArray(this);

    // initialize a 1-based character array for other
    final b = _CharArray(other);

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
  /// lengthSimilarity = 1 - [lengthDistance].
  ///
  /// Returns:
  /// - 1.0 if this and [other] are the same length; and
  /// - 0.0 if [lengthDistance] >= 1.0, i.e when [other].length is less than
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

  /// Returns the Jaccard Similarity Index between this term and [other]
  /// using a [k]-gram length of [k].
  double jaccardSimilarity(Term other, [int k = 3]) =>
      _jaccardSimilarity(kGrams(k), other, k);

  double _jaccardSimilarity(Set<String> termGrams, Term other, int k) {
    final otherGrams = other.kGrams(k);
    final intersection = termGrams.intersection(otherGrams);
    final union = termGrams.union(otherGrams);
    return intersection.length / union.length;
  }

  /// Returns a hashmap of [terms] to Jaccard Similarity Index with this term
  /// using a [k]-gram length of [k].
  Map<Term, double> jaccardSimilarityMap(Iterable<Term> terms, [int k = 3]) {
    final retVal = <Term, double>{};
    final termGrams = kGrams(k);
    for (final other in terms) {
      retVal[other] = _jaccardSimilarity(termGrams, other, k);
    }
    return retVal;
  }

  /// Returns a similarity index value between 0.0 and 1.0, defined as the
  /// product of [jaccardSimilarity] and [lengthSimilarity].
  ///
  /// A term similarity of 1.0 means the two terms are:
  /// - equal in length; and
  /// - have an identical collection of [k]-grams.
  double termSimilarity(Term other, [int k = 3]) =>
      jaccardSimilarity(other, k) * lengthSimilarity(other);

  /// a hashmap of [terms] to [termSimilarity] with this term using a [k]-gram
  /// length of [k].
  Map<Term, double> termSimilarityMap(Iterable<Term> terms, [int k = 3]) {
    final retVal = <Term, double>{};
    final termGrams = kGrams(k);
    for (final other in terms) {
      retVal[other] =
          _jaccardSimilarity(termGrams, other, k) * termSimilarity(other);
    }
    return retVal;
  }

  /// Returns the best matches for the [Term] from [terms], in descending
  /// order of [termSimilarity] (best match first).
  ///
  /// Only matches with a [termSimilarity] > 0.0 are returned.
  ///
  /// The returned matches will be limited to [limit] if more than [limit]
  /// matches are found.
  List<Term> matches(Iterable<Term> terms, {int k = 3, int limit = 10}) {
    final similarities = termSimilarityMap(terms);
    final entries =
        similarities.entries.where((element) => element.value > 0).toList();
    entries.sort(((a, b) => b.value.compareTo(a.value)));
    final retVal = entries.map((e) => e.key).toList();
    return retVal.length > limit ? retVal.sublist(0, limit) : retVal;
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

/// A 1-based, 1-dimensional array of integers, 26 charcters in length.
class _da extends _Array<int> {
  //

  _da() : super(List<int>.generate(26, (index) => 0), 1);
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
                .replaceAll(r'[^a-z]', '')
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

  /// Unnamed factory constructor initializes an empty [_Matrix].
  factory _Matrix(int i, int j, {int? rows, int? columns}) {
    return _Matrix._(_Array([], j), i, j);
  }

  final _Array<_Array<T>> elements;

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
