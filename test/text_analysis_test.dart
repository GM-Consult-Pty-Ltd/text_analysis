// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd
// All rights reserved

// ignore_for_file: unused_local_variable

@Timeout(Duration(minutes: 1))

import 'package:gmconsult_dev/gmconsult_dev.dart';
// import '../dev/data/english_vocabulary.dart';
import '../dev/data/lexicon/english_lexicon.dart';
import 'dart:io';
import 'package:gmconsult_dev/test_data.dart';
import 'package:text_analysis/src/_index.dart';
import 'package:test/test.dart';

void main() {
  final sample =
      'The Australian platypus is seemingly a hybrid-mammal and reptilian '
      'creature. It orignates from the U.S.A, roaming the pavé of the Cote '
      'D\'Azure. He often has stubble on his chin.';
  group('TextTokenizer', () {
    //

    test('TextDocument', (() async {
      //

      final textDoc = await TextDocument.analyze(
          sourceText: sample,
          analyzer: English.analyzer,
          nGramRange: NGramRange(1, 3));

      print('Average sentence length: ${textDoc.averageSentenceLength()}');

      print(
          'Average syllable count: ${textDoc.averageSyllableCount().toStringAsFixed(2)}');

      print(
          'Flesch Reading Ease: ${textDoc.fleschReadingEaseScore().toStringAsFixed(1)}');
      print('Flesch-Kincaid Grade Level: ${textDoc.fleschKincaidGradeLevel()}');
    }));

    test('TextTokenizer.tokenize', () async {
      //

      // convert the StringBuffer to a String
      final source = TestData.text;

      final analyzer =
          English(termExceptions: {'alphabet': 'ALPHABET', 'google': 'Google'});

      // use a TextTokenizer instance to tokenize the source
      final tokens = await TextTokenizer(analyzer: analyzer)
          .tokenize(source, zone: 'text');

      // print the tokens
      _printTokens('TOKENIZE JSON', tokens);
    });

    test('TextTokenizer.split', () async {
      // convert the StringBuffer to a String
      final source = TestData.text;

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
          TestData.json,
          zones: ['name', 'description', 'hashTags']);

      // print the tokens
      _printTokens('TOKENIZE JSON', tokens);
    });

    /// Tokenize JSON with NO zones.
    test('TextTokenizer.tokenizeJson', () async {
      // use a TextTokenizer instance to tokenize the json with NO zones
      final tokens = await TextTokenizer.english.tokenizeJson(TestData.json,
          nGramRange: NGramRange(1, 2), zones: ['description']);
      // map the document's tokens to a list of terms (strings)

      // print the tokens
      _printTokens('TOKENIZE JSON (${tokens.length})', tokens);
    });

    /// Tokenize JSON with NO zones.
    test('Iterable<String>.kGrams()', () async {
      // use a TextTokenizer instance to tokenize the json with NO zones
      final lexicon = englishLexicon.keys
          .where((element) => !element.contains(RegExp(r'[^a-zA-Z]')))
          .map((e) => e.toLowerCase());
      final kgrams = lexicon.toKGramsMap(2);
      // map the document's tokens to a list of terms (strings)

      // print the tokens
      await saveKgramIndex(kgrams);
    });

    test('TextTokenizer.tokenizeJson (performance)', () async {
      //
      final start = DateTime.now();
      // initialize a term dictionary
      final dictionary = <String, int>{};
      // iterate through sampleNews
      await Future.forEach(TestData.stockData.entries,
          (MapEntry<String, Map<String, dynamic>> entry) async {
        final json = entry.value;
        final tokens = await TextTokenizer.english.tokenizeJson(json,
            zones: ['ticker', 'name', 'description', 'hashTag', 'symbol']);
        for (final term in Set<String>.from(tokens.map((e) => e.term))) {
          final tf = (dictionary[term] ?? 0) + 1;
          dictionary[term] = tf;
        }
      });
      final finish = DateTime.now();
      final delta = finish.difference(start).inMilliseconds;

      print('Processed ${TestData.stockNews.length} documents in $delta '
          'milliseconds');
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
      print(
          'Processed ${TestData.stockNews.length} documents in $delta milliseconds');
      print('Found ${entries.length} terms');
    });
  });

  group('TextAnalyzer', (() {
    test('English().nGrammer(sample, NGramRange(1, 3)', (() {
      final nGrams = English().nGrammer(sample, NGramRange(1, 3));
      print(nGrams);
    }));
  }));
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

Future<void> saveKgramIndex(Map<String, Set<String>> value,
    [String fileName = 'kGramIndex']) async {
  final buffer = StringBuffer();
  buffer.writeln('const kGrams = {');
  for (final entry in value.entries) {
    buffer.write(entry.key.contains('\$') ? 'r' : '');
    buffer.write("'${entry.key}': {");
    var i = 0;
    for (final term in entry.value) {
      buffer.write(i > 0 ? ', ' : '');
      buffer.write("'$term'");
      i++;
    }
    buffer.writeln('},');
  }
  buffer.writeln('};');
  final out = File(r'dev\data\kGramIndex.dart').openWrite();
  out.writeln(buffer.toString());
  await out.close();
}
