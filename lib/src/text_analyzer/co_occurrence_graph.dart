// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

import 'package:collection/collection.dart';
import '../_index.dart';

/// A RAKE co-occurrence graph for evaluating the score of keywords extracted
/// from text.
abstract class TermCoOccurrenceGraph {
//

  /// Unnamed factory constructor hydrates a [TermCoOccurrenceGraph] from the
  /// [keywords].
  factory TermCoOccurrenceGraph(Iterable<List<String>> keywords) {
    final uniqueTerms = keywords.toUniqueTerms();
    final terms = uniqueTerms.toList();
    final coOccurrenceGraph = keywords.coOccurenceGraph(terms);
    return _TermCoOccurrenceGraphImpl(
        coOccurrenceGraph, keywords, terms, uniqueTerms);
  }

  /// The set of unique terms in the co-occurrence graph.
  Set<String> get uniqueTerms;

  /// The collection of keywords, each as a list of terms.
  Iterable<List<String>> get keywords;

  /// The word frequency for the term.
  int termFrequency(String term);

  /// The word degree of the term
  int termDegree(String term);

  /// The RAKE keyword score for the [keyWord]
  double keyWordScore(List<String> keyWord);

  /// Returns a mapping of the keywords to their RAKE scores.
  Map<String, double> get keywordScores;
}

/// Base class that implements [TermCoOccurrenceGraph] and mixes in
/// [TermCoOccurrenceGraphMixin].
///
/// Includes a default const generative constructor for sub-classes.
abstract class TermCoOccurrenceGraphBase with TermCoOccurrenceGraphMixin {
//

  /// A default const generative constructor for sub-classes.
  const TermCoOccurrenceGraphBase();
}

/// Mixin class that implements [TermCoOccurrenceGraph.termFrequency],
/// [TermCoOccurrenceGraph.termDegree] and
/// [TermCoOccurrenceGraph.keyWordScore].
///
/// Classes that mix in [TermCoOccurrenceGraphMixin] must override:
/// - [coOccurrenceGraph], the map that holds the matrix of terms; and
/// - [terms], the unique terms in the [coOccurrenceGraph].
abstract class TermCoOccurrenceGraphMixin implements TermCoOccurrenceGraph {
  //

  /// The map that holds the matrix of terms.
  Map<String, List<int>> get coOccurrenceGraph;

  /// The unique terms in the [coOccurrenceGraph].
  List<String> get terms;

  @override
  int termFrequency(String term) {
    assert(terms.contains(term), 'The term is not in the keywords.');
    final i = terms.indexOf(term);
    final row = coOccurrenceGraph[term] as List<int>;
    return row[i];
  }

  @override
  int termDegree(String term) {
    assert(terms.contains(term), 'The term is not in the keywords.');
    final row = coOccurrenceGraph[term] as List<int>;
    return row.sum;
  }

  @override
  double keyWordScore(List<String> keyWord) {
    double retVal = 0.0;
    for (final e in keyWord) {
      final tF = termFrequency(e);
      final tD = termDegree(e);
      final tV = tD / tF;
      retVal += tV;
    }
    return retVal;
  }

  @override
  Map<String, double> get keywordScores {
    final Map<String, double> retVal = {};
    for (final e in keywords) {
      final keyword = e.join(' ');
      final score = keyWordScore(e);
      retVal[keyword] = score;
    }
    return retVal;
  }
}

class _TermCoOccurrenceGraphImpl extends TermCoOccurrenceGraphBase {
  @override
  final Map<String, List<int>> coOccurrenceGraph;

  @override
  final Iterable<List<String>> keywords;

  @override
  final List<String> terms;

  @override
  final Set<String> uniqueTerms;

  const _TermCoOccurrenceGraphImpl(
      this.coOccurrenceGraph, this.keywords, this.terms, this.uniqueTerms);
}
