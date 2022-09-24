// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'package:text_analysis/text_analysis.dart';
import 'package:test/test.dart';
import 'data/sample_news.dart';
import 'data/sample_stocks.dart';

void main() {
  group('TextAnalyzer', () {
    //

    /// Three paragraphs of text used for testing tokenization.
    ///
    /// Includes numbers, currencies, abbreviations, hyphens and identifiers
    final text = [
      'The Dow Jones rallied even as U.S. troops were put on alert amid '
          'the Ukraine crisis. Tesla stock fought back while Apple '
          'stock struggled. ',
      '[TSLA.XNGS] Tesla\'s #TeslaMotor Stock Is Getting Hammered.',
      'Among the best EV stocks to buy and watch, Tesla '
          '(TSLA.XNGS) is pulling back from new highs after a failed breakout '
          'above a \$1,201.05 double-bottom entry. ',
      'Meanwhile, Peloton reportedly finds an activist investor knocking '
          'on its door after a major stock crash fueled by strong indications of '
          'mismanagement. In a scathing new letter released Monday, activist '
          'Tesla Capital is pushing for Peloton to fire CEO, Chairman and '
          'founder John Foley and explore a sale.'
    ];

    final json = {
      'avatarImageUrl':
          'https://firebasestorage.googleapis.com/v0/b/buysellhold-322d1.appspot.com/o/logos%2FTSLA%3AXNGS.png?alt=media&token=c365db47-9482-4237-9267-82f72854d161',
      'description':
          'A 20-for-1 stock split gave a nice short-term boost to Amazon (AMZN) - Get Amazon.com Inc. Report in late May and in early June, while Alphabet (GOOGL) - Get Alphabet Inc. Report (GOOG) - Get Alphabet Inc. Report has a planned 20-for-1 stock split for next month. Tesla  (TSLA) - Get Tesla Inc. Report is also waiting on shareholder approval for a 3-for-1 stock split. ',
      'entityType': 'NewsItem',
      'hashTags': ['#Tesla'],
      'id': 'ee1760a1-a259-50dc-b11d-8baf34d7d1c5',
      'itemGuid':
          'trading-shopify-stock-ahead-of-10-for-1-stock-split-technical-analysis-june-2022?puc=yahoo&cm_ven=YAHOO&yptr=yahoo',
      'linkUrl':
          'https://www.thestreet.com/investing/trading-shopify-stock-ahead-of-10-for-1-stock-split-technical-analysis-june-2022?puc=yahoo&cm_ven=YAHOO&yptr=yahoo',
      'locale': 'Locale.en_US',
      'name': 'Shopify Stock Split What the Charts Say Ahead of 10-for-1 Split',
      'publicationDate': '2022-06-28T17:44:00.000Z',
      'publisher': {
        'linkUrl': 'http://www.thestreet.com/',
        'title': 'TheStreet com'
      },
      'timestamp': 1656464362162
    };

    test('kGram(k)', () async {
      final source = text.first;
      // use a TextAnalyzer instance to tokenize the source
      final tokens = await TextAnalyzer().tokenize(source);
      // get the bi-grams
      final Map<String, Set<Term>> kGramIndex = tokens.kGrams(3);
      // add the tri-grams
      // kGramIndex.addAll(document.tokens.kGrams(3));
      print('${'k-gram'.padRight(8)} Terms Set');
      for (final entry in kGramIndex.entries) {
        print('${entry.key.padRight(8)} ${entry.value}');
      }
    });

    test('TextAnalyzer.tokenize', () async {
      // Initialize a StringBuffer to hold the source text
      final sourceBuilder = StringBuffer();
      // Concatenate the elements of [text] using line-endings
      for (final src in text) {
        sourceBuilder.writeln(src);
      }
      // convert the StringBuffer to a String
      final source = sourceBuilder.toString();
      // use a TextAnalyzer instance to tokenize the source
      final tokens = await TextAnalyzer().tokenize(source);
      // map the document's tokens to a list of terms (strings)
      final terms = tokens.allTerms;
      // print the terms
      print(terms);
    });

    test('TextAnalyzer.tokenizeJson', () async {
      // use a TextAnalyzer instance to tokenize the json with 3 zones
      final tokens = await TextAnalyzer()
          .tokenizeJson(json, ['name', 'description', 'hashTags']);
      // map the document's tokens to a list of terms (strings)
      final terms = tokens.map((e) => e.term).toList();
      // print the terms
      print(terms);
    });

    /// Tokenize JSON with NO zones.
    test('TextAnalyzer.tokenizeJson', () async {
      // use a TextAnalyzer instance to tokenize the json with NO zones
      final tokens = await TextAnalyzer().tokenizeJson(json);
      // map the document's tokens to a list of terms (strings)
      final terms = tokens.map((e) => e.term).toList();
      // print the terms
      print(terms);
    });

    test('TextAnalyzer.tokenizeJson (performance)', () async {
      //
      final start = DateTime.now();
      // initialize a term dictionary
      final dictionary = <String, int>{};
      // iterate through sampleNews
      await Future.forEach(sampleStocks.entries,
          (MapEntry<String, Map<String, dynamic>> entry) async {
        final json = entry.value;
        final tokens = await TextAnalyzer().tokenizeJson(
            json, ['ticker', 'name', 'description', 'hashTag', 'symbol']);
        for (final term in Set<String>.from(tokens.map((e) => e.term))) {
          final tf = (dictionary[term] ?? 0) + 1;
          dictionary[term] = tf;
        }
      });
      final finish = DateTime.now();
      final delta = finish.difference(start).inMilliseconds;

      print('Processed ${sampleNews.length} documents in $delta milliseconds');
      print('=========================');
      final entries = dictionary.entries.toList();
      entries.sort((a, b) => b.value.compareTo(a.value));
      print('Found ${entries.length} terms');
      print('Printing TOP 20 terms');
      print('Term:    Df');
      print('=========================');

      for (final entry
          in entries.length < 20 ? entries : entries.sublist(0, 20)) {
        // print the terms
        print('${entry.key}: ${entry.value}');
      }
      print('=========================');
      print('Processed ${sampleNews.length} documents in $delta milliseconds');
      print('Found ${entries.length} terms');
    });
  });

  group('k-grams', (() {
    //
    test('jaccardSimilarity', (() {
      final k = 2;
      final term = 'bord';
      final candidates = ['board', 'broad', 'boardroom', 'border'];
      print('k-grams with k = $k');
      for (final other in candidates) {
        final jCf = term.jaccardSimilarity(other, k);
        print(
            'Similarity between $term and $other = ${jCf.toStringAsFixed(4)}');
      }
    }));

    test('jaccardSimilarityMap', (() {
      final k = 2;
      final term = 'broder';
      final candidates = ['board', 'broad', 'boardroom', 'border'];
      print('k-grams with k = $k');
      final map = term.jaccardSimilarityMap(candidates, k);

      for (final other in map.entries) {
        print(
            'Similarity between $term and ${other.key} = ${other.value.toStringAsFixed(4)}');
      }
    }));
  }));
}
