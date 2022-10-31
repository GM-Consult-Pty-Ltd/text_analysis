// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd

// ignore_for_file: camel_case_types

import 'package:text_analysis/type_definitions.dart';
import 'package:text_analysis/text_analysis.dart';
import 'package:text_analysis/extensions.dart';
import 'dart:math';

/// Extension methods on [Term] that exposes methods for computing similarity.
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
  double editSimilarity(Term other) {
    final similarity =
        (length + other.length - editDistance(other)) / (length + other.length);
    if (similarity > 1.0) {
      return 1.0;
    }
    return similarity;
  }

  /// Returns a ordered list of [SimilarityIndex] values for the terms, in
  /// descending order of [SimilarityIndex.similarity].
  ///
  /// Not case-sensitive.
  List<SimilarityIndex> editSimilarities(Iterable<Term> terms) =>
      editSimilarityMap(terms)
          .entries
          .map((e) => SimilarityIndex(e.key, e.value))
          .sortBySimilarity();

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
  /// See https://en.wikipedia.org/wiki/Damerau%E2%80%93Levenshtein_distance.
  int editDistance(Term other) {
    //

    // initialize a 1-based array of 26 integers with all values set to 0
    final da = _Da();

    // initialize a 1-based character array for this
    final a = _CharArray(toLowerCase());

    // initialize a 1-based character array for other
    final b = _CharArray(other.toLowerCase());

    // initialize the -1 based edit distance matrix, filling it with zeros
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
      // set the entire top row to maxDist
      d.setAt(i, -1, maxDist);
      // set the second row to [0, 0, 1, 2 ...]
      d.setAt(i, 0, i);
    }

    for (var j = 0; j <= b.length; j++) {
      // set the entire first column to maxDist
      d.setAt(-1, j, maxDist);
      // set the second column to
      d.setAt(0, j, j);
    }

    for (var i = 1; i <= a.length; i++) {
      var db = 0;
      final charA = a.get(i);

      for (var j = 1; j <= b.length; j++) {
        // print('Start with $i - $j');
        final charB = b.get(j);
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
        // print(costs);
        costs.sort(((a, b) => a.compareTo(b)));
        d.setAt(i, j, costs.first);
        // for (var i = 0; i < d.elements.length; i++) {
        //   final arr = d.elements.elements[i];
        //   print(arr.elements);
        // }
        // print('Done with $i - $j');
      }
      da.setAt(charA, i);
    }

    // return the value from the edit distance matrix matrix
    return d.get(a.length, b.length);
  }

  /// Returns the similarity between the collection of letters of this String and
  /// [other] on a scale of 0.0 to 1.0.
  ///
  /// Compares the characters in this and [other] by splitting each string into
  /// a set of its unique characters and finding the intersection between the
  /// two sets of characters.
  /// - Returns 1.0 if the two Strings are the same (this.trim().toLowerCase() ==
  ///   other.trim().toLowerCase()).
  /// - Returns 1.0 if the character set for this and the intersection have the
  ///   same length AND this and [other] are the same length.
  /// - Returns 0.0 if the intersection is empty (no shared characters).
  /// - Returns the intersection length divided by the average length of the two
  ///   character sets multiplied by the length similarity.
  ///
  /// Not case-sensitive.
  double characterSimilarity(Term other) {
    final term = trim().toLowerCase();
    other = other.trim().toLowerCase();
    if (term == other) return 1.0;
    final thisChars = term.split('').toSet();
    final otherChars = other.trim().toLowerCase().split('').toSet();
    final intersection = thisChars.intersection(otherChars);
    final lengthSimilarity = term.lengthSimilarity(other);
    if (intersection.length == thisChars.length &&
        term.lengthDistance(other) == 0) {
      return 1.0;
    }
    return (intersection.length * 2 / (thisChars.length + otherChars.length)) *
        lengthSimilarity;
  }

  /// Returns a ordered list of [SimilarityIndex] values for the [terms], in
  /// descending order of [SimilarityIndex.similarity].
  ///
  /// Not case-sensitive.
  List<SimilarityIndex> characterSimilarities(Iterable<Term> terms) =>
      characterSimilarityMap(terms)
          .entries
          .map((e) => SimilarityIndex(e.key, e.value))
          .sortBySimilarity();

  /// Returns a hashmap of [terms] to their [lengthSimilarity] with this.
  Map<Term, double> characterSimilarityMap(Iterable<Term> terms) {
    final retVal = <Term, double>{};
    for (var other in terms) {
      retVal[other] = characterSimilarity(other);
    }
    return retVal;
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
    final similarity = logRatio > 1 ? 0.0 : 1.0 - logRatio;
    if (similarity > 1.0) {
      return 1.0;
    }
    return similarity;
  }

  /// Returns a ordered list of [SimilarityIndex] values for the [terms], in
  /// descending order of [SimilarityIndex.similarity].
  ///
  /// Not case-sensitive.
  List<SimilarityIndex> lengthSimilarities(Iterable<Term> terms) =>
      lengthSimilarityMap(terms)
          .entries
          .map((e) => SimilarityIndex(e.key, e.value))
          .sortBySimilarity();

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
    final similarity = intersection.length / union.length;
    if (similarity > 1.0) {
      return 1.0;
    }
    return similarity;
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

  /// Returns a ordered list of [SimilarityIndex] values for the [terms], in
  /// descending order of [SimilarityIndex.similarity] using a
  /// [k]-gram length of [k]. [k] defaults to 2.
  ///
  /// Not case-sensitive.
  List<SimilarityIndex> jaccardSimilarities(Iterable<Term> terms,
          [int k = 2]) =>
      jaccardSimilarityMap(terms, k)
          .entries
          .map((e) => SimilarityIndex(e.key, e.value))
          .sortBySimilarity();

  /// Returns a ordered list of [SimilarityIndex] values for the [terms], in
  /// descending order of [SimilarityIndex.similarity].
  /// - [k] is the [k]-gram length used to calculate [jaccardSimilarity],
  ///   defaults to 2.
  /// - [jaccardSimilarityWeight] is the weighting of the [jaccardSimilarity]
  ///   in [TermSimilarity.similarity], defaults to 1.0.
  /// - [lengthSimilarityWeight] is the weighting of the [lengthSimilarity]
  ///   in [TermSimilarity.similarity], defaults to 1.0.
  /// - [editSimilarityWeight] is the weighting of the [editSimilarity]
  ///   in [TermSimilarity.similarity], defaults to 1.0.
  /// - [characterSimilarityWeight] is the weighting of the
  ///   [characterSimilarity] in [TermSimilarity.similarity], defaults to 1.0.
  ///
  /// Not case-sensitive.
  List<TermSimilarity> termSimilarities(Iterable<Term> terms,
          {int k = 2,
          double jaccardSimilarityWeight = 1.0,
          double lengthSimilarityWeight = 1.0,
          double editSimilarityWeight = 1.0,
          double characterSimilarityWeight = 1.0}) =>
      termSimilarityMap(terms,
              k: k,
              jaccardSimilarityWeight: jaccardSimilarityWeight,
              characterSimilarityWeight: characterSimilarityWeight,
              editSimilarityWeight: editSimilarityWeight,
              lengthSimilarityWeight: lengthSimilarityWeight)
          .values
          .sortBySimilarity();

  /// Returns an hashmap of [terms] to [TermSimilarity] with this term.
  ///
  /// - [k] is the [k]-gram length used to calculate [jaccardSimilarity],
  ///   defaults to 2.
  /// - [jaccardSimilarityWeight] is the weighting of the [jaccardSimilarity]
  ///   in [TermSimilarity.similarity], defaults to 1.0.
  /// - [lengthSimilarityWeight] is the weighting of the [lengthSimilarity]
  ///   in [TermSimilarity.similarity], defaults to 1.0.
  /// - [editSimilarityWeight] is the weighting of the [editSimilarity]
  ///   in [TermSimilarity.similarity], defaults to 1.0.
  /// - [characterSimilarityWeight] is the weighting of the
  ///   [characterSimilarity] in [TermSimilarity.similarity], defaults to 1.0.
  ///
  /// Not case-sensitive.
  Map<Term, TermSimilarity> termSimilarityMap(Iterable<Term> terms,
      {int k = 2,
      double jaccardSimilarityWeight = 1.0,
      double lengthSimilarityWeight = 1.0,
      double editSimilarityWeight = 1.0,
      double characterSimilarityWeight = 1.0}) {
    final retVal = <Term, TermSimilarity>{};
    for (final other in terms) {
      retVal[other] = TermSimilarity(this, other,
          k: k,
          jaccardSimilarityWeight: jaccardSimilarityWeight,
          characterSimilarityWeight: characterSimilarityWeight,
          editSimilarityWeight: editSimilarityWeight,
          lengthSimilarityWeight: lengthSimilarityWeight);
    }
    return retVal;
  }

  /// Returns a collection of [SimilarityIndex]s for this String from [terms].
  ///
  /// Suggestions are returned in descending order of
  /// [SimilarityIndex.similarity].
  ///
  /// - If [greaterThan] is not null only matches with
  ///   `[TermSimilarity.similarity] > [greaterThan]` are returned.  ///
  /// - the returned matches will be limited to [limit] if more than [limit]
  ///   matches are found.
  /// - [k] is the [k]-gram length used to calculate [jaccardSimilarity],
  ///   defaults to 2.
  /// - [jaccardSimilarityWeight] is the weighting of the [jaccardSimilarity]
  ///   in [TermSimilarity.similarity], defaults to 1.0.
  /// - [lengthSimilarityWeight] is the weighting of the [lengthSimilarity]
  ///   in [TermSimilarity.similarity], defaults to 1.0.
  /// - [editSimilarityWeight] is the weighting of the [editSimilarity]
  ///   in [TermSimilarity.similarity], defaults to 1.0.
  /// - [characterSimilarityWeight] is the weighting of the
  ///   [characterSimilarity] in [TermSimilarity.similarity], defaults to 1.0.
  ///
  /// Not case-sensitive.
  List<SimilarityIndex> getSuggestions(Iterable<Term> terms,
      {int limit = 10,
      int k = 2,
      double? greaterThan,
      double jaccardSimilarityWeight = 1.0,
      double lengthSimilarityWeight = 1.0,
      double editSimilarityWeight = 1.0,
      double characterSimilarityWeight = 1.0}) {
    final retVal = <SimilarityIndex>[];
    for (final other in terms.toSet()) {
      final similarity = TermSimilarity(this, other,
              k: k,
              jaccardSimilarityWeight: jaccardSimilarityWeight,
              characterSimilarityWeight: characterSimilarityWeight,
              editSimilarityWeight: editSimilarityWeight,
              lengthSimilarityWeight: lengthSimilarityWeight)
          .similarity;
      if (similarity > (greaterThan ?? -1)) {
        retVal.add(SimilarityIndex(other, similarity));
      }
    }
    // sort in descending order of similarity and return only the first [limit]
    // results
    return retVal.sortBySimilarity().limit(limit);
  }

  /// Returns the best matches for a term from [terms], in descending
  /// order of term similarity (best match first).
  ///
  /// Matches are returned in descending order of[SimilarityIndex.similarity].
  ///
  /// - If [greaterThan] is not null only matches with
  ///   `[TermSimilarity.similarity] > [greaterThan]` are returned.  ///
  /// - the returned matches will be limited to [limit] if more than [limit]
  ///   matches are found.
  /// - [k] is the [k]-gram length used to calculate [jaccardSimilarity],
  ///   defaults to 2.
  /// - [jaccardSimilarityWeight] is the weighting of the [jaccardSimilarity]
  ///   in [TermSimilarity.similarity], defaults to 1.0.
  /// - [lengthSimilarityWeight] is the weighting of the [lengthSimilarity]
  ///   in [TermSimilarity.similarity], defaults to 1.0.
  /// - [editSimilarityWeight] is the weighting of the [editSimilarity]
  ///   in [TermSimilarity.similarity], defaults to 1.0.
  /// - [characterSimilarityWeight] is the weighting of the
  ///   [characterSimilarity] in [TermSimilarity.similarity], defaults to 1.0.
  ///
  /// Not case-sensitive.
  List<Term> matches(Iterable<Term> terms,
          {int limit = 10,
          int k = 2,
          double? greaterThan,
          double jaccardSimilarityWeight = 1.0,
          double lengthSimilarityWeight = 1.0,
          double editSimilarityWeight = 1.0,
          double characterSimilarityWeight = 1.0}) =>
      getSuggestions(terms,
              k: k,
              limit: limit,
              greaterThan: greaterThan,
              jaccardSimilarityWeight: jaccardSimilarityWeight,
              characterSimilarityWeight: characterSimilarityWeight,
              editSimilarityWeight: editSimilarityWeight,
              lengthSimilarityWeight: lengthSimilarityWeight)
          .where((element) => element.similarity > 0)
          .map((e) => e.term)
          .toList();

  /// Returns a set of (lower-case) k-grams in the term. Splits phrases into
  /// terms at all non-word characters and generates the k-grams for each word
  /// individually.
  Set<KGram> kGrams([int k = 2]) {
    final Set<KGram> kGrams = {};
    final terms =
        toLowerCase().split(RegExp(r"[^a-zA-Z0-9À-öø-ÿ¥Œ€@™#-\&_\'\-\$]+"));
    for (var term in terms) {
      term = term.trim();
      if (term.isNotEmpty) {
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
                .map((e) => e.toInt() - 96)
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

  /// Return the value from coordinates ([x],[y])
  T get(int x, int y) => elements.get(y).get(x);

  /// Set the value at coordinates ([i],[j])
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
