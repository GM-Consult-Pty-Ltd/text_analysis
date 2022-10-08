// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

// ignore_for_file: unused_local_variable

import 'package:gmconsult_dev/gmconsult_dev.dart';
import 'package:text_analysis/src/_index.dart';
import 'package:test/test.dart';
import 'data/sample_news.dart';
import 'data/sample_stocks.dart';
import 'data/data.dart';

void main() {
  group('TextTokenizer', () {
    //

    test('TextDocument', (() async {
      //
      final sample =
          'The Australian platypus is seemingly a hybrid of a mammal and reptilian creature.';

      final textDoc = await TextDocument.analyze(sourceText: sample);

      print('Average sentence length: ${textDoc.averageSentenceLength()}');

      print(
          'Average syllable count: ${textDoc.averageSyllableCount().toStringAsFixed(2)}');

      print(
          'Flesch Reading Ease: ${textDoc.fleschReadingEaseScore().toStringAsFixed(1)}');
      print('Flesch-Kincaid Grade Level: ${textDoc.fleschKincaidGradeLevel()}');
    }));

    test('TextTokenizer.tokenize', () async {
      //

      // Initialize a StringBuffer to hold the source text
      final sourceBuilder = StringBuffer();

      // Concatenate the elements of [text] using line-endings
      for (final src in TextAnalysisTestData.text) {
        sourceBuilder.writeln(src);
      }

      // convert the StringBuffer to a String
      final source = sourceBuilder.toString();

      final analyzer =
          English(termExceptions: {'tesla': 'Tesla', 'AAPL': 'AAPL'});

      // use a TextTokenizer instance to tokenize the source
      final tokens =
          await TextTokenizer(analyzer: analyzer).tokenize(source, 'text');

      // print the tokens
      _printTokens('TOKENIZE JSON', tokens);
    });

    test('TextTokenizer.split', () async {
      // Initialize a StringBuffer to hold the source text
      final sourceBuilder = StringBuffer();
      // Concatenate the elements of [text] using line-endings
      for (final src in TextAnalysisTestData.text) {
        sourceBuilder.writeln(src);
      }
      // convert the StringBuffer to a String
      final source = sourceBuilder.toString();

// split into terms
      final paragraphs = English().paragraphSplitter(source);

      // split into terms
      final sentences = English().sentenceSplitter(source);

      // split into terms
      final terms = English().termSplitter(source);
      // map the document's tokens to a list of terms (strings)
      // print the terms
      print('-'.padRight(31, '-'));
      print('${'Term'.padRight(21)} ${'Syllables'.toString().padLeft(10)}');
      print('-'.padRight(31, '-'));
      for (final term in terms) {
        final syllableCount = English().syllableCounter(term);
        print('${term.padRight(20)}${syllableCount.toString().padLeft(10)}');
      }
      print('-'.padRight(31, '-'));
    });

    test('TextTokenizer.tokenizeJson(fields)', () async {
      //

      // test some exceptions
      final analyzer =
          English(termExceptions: {'tesla': 'Tesla', 'Alphabet': 'GOOGLE'});

      // use a TextTokenizer instance to tokenize the json with 3 zones
      final tokens = await TextTokenizer(analyzer: analyzer).tokenizeJson(
          TextAnalysisTestData.json, ['name', 'description', 'hashTags']);

      // print the tokens
      _printTokens('TOKENIZE JSON', tokens);
    });

    /// Tokenize JSON with NO zones.
    test('TextTokenizer.tokenizeJson', () async {
      // use a TextTokenizer instance to tokenize the json with NO zones
      final tokens =
          await TextTokenizer().tokenizeJson(TextAnalysisTestData.json);
      // map the document's tokens to a list of terms (strings)

      // print the tokens
      _printTokens('TOKENIZE JSON', tokens);
    });

    test('TextTokenizer.tokenizeJson (performance)', () async {
      //
      final start = DateTime.now();
      // initialize a term dictionary
      final dictionary = <String, int>{};
      // iterate through sampleNews
      await Future.forEach(sampleStocks.entries,
          (MapEntry<String, Map<String, dynamic>> entry) async {
        final json = entry.value;
        final tokens = await TextTokenizer().tokenizeJson(
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
}

/// Print the terms in List<[Token]>.
void _printTokens(String title, Iterable<Token> tokens) {
  //

  // map the tokens to a list of JSON documents
  final results = tokens
      .map((e) => {'term': e.term, 'zone': e.zone, 'position': e.termPosition})
      .toList();

  // print the results
  Console.out(title: title, results: results, maxColWidth: 120);

  //
}
