// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

// ignore_for_file: unused_local_variable, unused_import

import 'package:text_analysis/src/_index.dart';
import 'package:test/test.dart';
import 'package:gmconsult_dev/gmconsult_dev.dart';
import 'data/kGramIndex.dart';
// import 'print_json.dart';

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
        final ed = TermSimilarity.editDistance(term, other);
        results.add({'other': other, 'Edit Distance': ed});
      }
      results.sort(((b, a) =>
          (b['Edit Distance'] as num).compareTo(a['Edit Distance'] as num)));
      Echo(
              title: 'EDIT DISTANCE: '
                  '$term.editDistance(other)',
              results: results,
              minPrintWidth: 80)
          .printResults();
    }));

    test('jaccardSimilarity', (() {
      final k = 2;
      final results = <Map<String, dynamic>>[];
      for (final other in candidates) {
        final jCf = TermSimilarity.jaccardSimilarity(term, other, k);
        results.add({'other': other, 'Jaccard Similarity': jCf});
      }
      results.sort(((a, b) => (b['Jaccard Similarity'] as num)
          .compareTo(a['Jaccard Similarity'] as num)));
      Echo(
              title: 'JACCARD SIMILARITY INDEX: '
                  '$term.jaccardSimilarity(other, $k)',
              results: results,
              minPrintWidth: 80)
          .printResults();
    }));

    test('jaccardSimilarityMap', (() {
      final k = 2;
      final map = TermSimilarity.jaccardSimilarityMap(term, candidates, k);

      final results = <Map<String, dynamic>>[];
      for (final other in map.entries) {
        results
            .add({'candidates': other.key, 'Jaccard Similarity': other.value});
      }
      results.sort(((a, b) => (b['Jaccard Similarity'] as num)
          .compareTo(a['Jaccard Similarity'] as num)));
      Echo(
              title: 'JACCARD SIMILARITY INDEX: '
                  '$term.jaccardSimilarityMap(candidates, $k)',
              results: results,
              minPrintWidth: 80)
          .printResults();
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
      Echo(
              title: 'RANKED MATCHES: '
                  '$term.matches(candidates, $k)',
              results: results,
              minPrintWidth: 80)
          .printResults();
    }));

    test('lengthSimilarity AND lengthDistance', (() {
      final results = <Map<String, dynamic>>[];
      for (var other in candidates) {
        final ld = TermSimilarity.lengthDistance(term, other);
        final ls = TermSimilarity.lengthSimilarity(term, other);
        results.add(
            {'Term': other, 'Length Distance': ld, 'Length Similarity': ls});
      }
      results.sort(((a, b) => (b['Length Similarity'] as num)
          .compareTo(a['Length Similarity'] as num)));
      Echo(title: 'LENGTH SIMILARITY', results: results, minPrintWidth: 80)
          .printResults();
    }));
  });
}
