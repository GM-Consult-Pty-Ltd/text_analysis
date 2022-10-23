// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

// ignore_for_file: unused_local_variable, unused_import

@Timeout(Duration(minutes: 30))

import 'package:text_analysis/src/_index.dart';
import 'package:test/test.dart';
import 'package:gmconsult_dev/gmconsult_dev.dart';

void main() {
  final term = 'bodrer';

  final candidates = [
    'bodrer',
    'board',
    'broad',
    'bord',
    'boarder',
    'border',
    'brother',
    'bored'
  ];
  group('similarity', () {
    //
    test('editDistance', (() {
      final results = <Map<String, dynamic>>[];
      for (final other in candidates) {
        final ed = term.editDistance(other);
        results.add({'other': other, 'Edit Distance': ed});
      }
      results.sort(((b, a) =>
          (b['Edit Distance'] as num).compareTo(a['Edit Distance'] as num)));
      Console.out(
          title: 'EDIT DISTANCE: '
              '$term.editDistance(other)',
          results: results,
          minPrintWidth: 80);
    }));

    test('editDistance(transposition)', (() {
      final results = 'teh'.termSimilarities(['the', 'ted', 'tea', 'there']);
      Console.out(
          title: 'TERM SIMILARITY ("teh" -> "the"): '
              '$term.editDistance(other)',
          results: results.map((e) => e.toJson()),
          minPrintWidth: 80);
    }));

    test('jaccardSimilarity', (() {
      final k = 2;
      final results = <Map<String, dynamic>>[];
      for (final other in candidates) {
        final jCf = term.jaccardSimilarity(other, k);
        results.add({'other': other, 'Jaccard Similarity': jCf});
      }
      results.sort(((a, b) => (b['Jaccard Similarity'] as num)
          .compareTo(a['Jaccard Similarity'] as num)));
      Console.out(
          title: 'JACCARD SIMILARITY INDEX: '
              '$term.jaccardSimilarity(other, $k)',
          results: results,
          minPrintWidth: 80);
    }));

    test('characterSimilarity', (() {
      final results = <Map<String, dynamic>>[];
      for (final other in candidates) {
        final jCf = term.characterSimilarity(other);
        results.add({'other': other, 'Jaccard Similarity': jCf});
      }
      results.sort(((a, b) => (b['Jaccard Similarity'] as num)
          .compareTo(a['Jaccard Similarity'] as num)));
      Console.out(
          title: 'CHARACTER SIMILARITY: '
              '$term.jaccardSimilarity(other)',
          results: results,
          minPrintWidth: 80);
    }));

    test('jaccardSimilarityMap', (() {
      final k = 2;
      final map = term.jaccardSimilarityMap(candidates, k);

      final results = <Map<String, dynamic>>[];
      for (final other in map.entries) {
        results
            .add({'candidates': other.key, 'Jaccard Similarity': other.value});
      }
      results.sort(((a, b) => (b['Jaccard Similarity'] as num)
          .compareTo(a['Jaccard Similarity'] as num)));
      Console.out(
          title: 'JACCARD SIMILARITY INDEX: '
              '$term.jaccardSimilarityMap(candidates, $k)',
          results: results,
          minPrintWidth: 80);
    }));

    test('matches', (() {
      final k = 2;
      final matches = TermSimilarity.matches(term, candidates, k: k);
      final results = <Map<String, dynamic>>[];
      var i = 0;
      for (final other in matches) {
        results.add({'Rank': i, 'Match': other});
        i++;
      }
      Console.out(
          title: 'RANKED MATCHES: '
              '$term.matches(candidates, $k)',
          results: results,
          minPrintWidth: 80);
    }));

    test('TermSimilarity.getSuggestions', (() {
      final k = 2;
      final matches = TermSimilarity.getSuggestions(term, candidates, k: k);
      final results = <Map<String, dynamic>>[];
      var i = 0;
      for (final other in matches) {
        results
            .add({'Rank': i, 'Match': other, 'Similarity': other.similarity});
        i++;
      }
      Console.out(
          title: 'RANKED MATCHES: '
              '$term.matches(candidates, $k)',
          results: results,
          minPrintWidth: 80);
    }));

    test('TermSimilarity.termSimilarities', (() {
      final matches = TermSimilarity.termSimilarities(term, candidates);
      Console.out(
          title: 'RANKED MATCHES: '
              '$term.matches(candidates)',
          results: matches.map((e) => e.toJson()),
          minPrintWidth: 80);
    }));

    test('lengthSimilarity AND lengthDistance', (() {
      final results = <Map<String, dynamic>>[];
      for (var other in candidates) {
        final ld = term.lengthDistance(other);
        final ls = term.lengthSimilarity(other);
        results.add(
            {'Term': other, 'Length Distance': ld, 'Length Similarity': ls});
      }
      results.sort(((a, b) => (b['Length Similarity'] as num)
          .compareTo(a['Length Similarity'] as num)));
      Console.out(
          title: 'LENGTH SIMILARITY', results: results, minPrintWidth: 80);
    }));
  });
}
