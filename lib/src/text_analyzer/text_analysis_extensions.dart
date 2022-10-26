// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd

// ignore_for_file: camel_case_types

import '../_index.dart';

/// Extension methods on [Term] that exposes methods analysing and tokenizing
/// text.
extension TextAnalysisExtensionsOnString on String {}

/// Extension methods on [Term] that exposes methods analysing and tokenizing
/// text.
extension TextAnalysisExtensionsOnStringList on List<String> {
  //

  /// Returns an ordered collection of n-grams from the list of Strings.
  ///
  /// The n-gram lengths are limited by [range]. If range is NGramRange(1,1)
  /// the list will be returned as is.
  List<String> nGrams(NGramRange range) {
    // return empty list if the collection is empty
    if (isEmpty) return [];

    // initialize the return value collection
    final retVal = <String>[];
    // initialize a rolling n-gram element word-list
    final nGramTerms = <String>[];
    // iterate through the terms
    for (var term in this) {
      // initialize the ngrams collection
      final nGrams = <List<String>>[];
      // remove white-space at start and end of term
      term = term.trim();
      // ignore empty strings
      if (term.isNotEmpty) {
        nGramTerms.add(term);
        if (nGramTerms.length > range.max) {
          nGramTerms.removeAt(0);
        }
        var n = 0;
        for (var i = nGramTerms.length - 1; i >= 0; i--) {
          final param = <List<String>>[];
          param.addAll(nGrams
              .where((element) => element.length == n)
              .map((e) => List<String>.from(e)));
          final newNGrams = _prefixWordTo(param, nGramTerms[i]);
          nGrams.addAll(newNGrams);
          n++;
        }
      }
      final tokenGrams = nGrams.where((element) =>
          element.length >= range.min && element.length <= range.max);
      for (final e in tokenGrams) {
        final nGram = e.join(' ');
        retVal.add(nGram);
      }
    }
    return retVal;
  }

  static Iterable<List<String>> _prefixWordTo(
      Iterable<List<String>> nkGrams, String word) {
    final nGrams = List<List<String>>.from(nkGrams);
    final retVal = <List<String>>[];
    if (nGrams.isEmpty) {
      retVal.add([word]);
    }
    for (final nGram in nGrams) {
      nGram.insert(0, word);
      retVal.add(nGram);
    }
    return retVal;
  }
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

/// String collection extensions to generate k-gram maps.
extension KGramExtensionOnTermCollection on Iterable<String> {
  /// Returns a hashmap of k-grams to terms from the collection of tokens.
  Map<KGram, Set<Term>> toKGramsMap([int k = 2]) {
    final terms = this;
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
}

/// Extensions on List<String> lists.
extension StringCollectionCollectionExtension on Iterable<List<String>> {
//

  /// Returns a set of all the unique terms contained in the Keyword collection.
  Set<String> toUniqueTerms() {
    final retVal = <String>{};
    for (final e in this) {
      retVal.addAll(e);
    }
    return retVal;
  }

  /// Builds a co-occurrency graph for the ordered list of terms from the
  /// elements (keywords) of the collection.
  Map<String, List<int>> coOccurenceGraph(List<String> terms) {
    final Map<String, List<int>> retVal = {};
    for (final rowKey in terms) {
      final row = List<int>.filled(terms.length, 0);
      var x = 0;
      for (final term in terms) {
        final tF = where(
                (element) => element.contains(rowKey) && element.contains(term))
            .length;
        row[x] = tF;
        x++;
      }
      retVal[rowKey] = row;
    }

    return retVal;
  }
}
