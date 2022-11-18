// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd
// All rights reserved

// ignore_for_file: unused_local_variable

@Timeout(Duration(minutes: 1))

import 'package:gmconsult_dev/gmconsult_dev.dart';
import 'package:gmconsult_dev/test_data.dart';
// import 'package:gmconsult_dev/type_definitions.dart';
import '../dev/data/lexicon/english_lexicon.dart';
import 'package:text_analysis/extensions.dart';
import 'package:text_analysis/text_analysis.dart';
import 'dart:io';
// import 'package:gmconsult_dev/test_data.dart';
// import 'package:text_analysis/src/_index.dart';
import 'package:test/test.dart';

void main() {
  final sample =
      'The Australian platypus is seemingly a hybrid-mammal and "reptilian '
      'creature". It 100% originates from the U.S.A., roaming the pavé of the Cote '
      'D\'Azure (\$3.25 cigar in hand). He often has (three day\'s old) stubble '
      'on his chin.';
  //
  group('Tokenization', () {
    //

    test('TextDocument', (() async {
      //

      final textDoc = await TextDocument.analyze(
          sourceText: sample,
          analyzer: English.analyzer,
          nGramRange: NGramRange(1, 2));

      print('Average sentence length: ${textDoc.averageSentenceLength()}');

      print(
          'Average syllable count: ${textDoc.averageSyllableCount().toStringAsFixed(2)}');

      print(
          'Flesch Reading Ease: ${textDoc.fleschReadingEaseScore().toStringAsFixed(1)}');
      print('Flesch-Kincaid Grade Level: ${textDoc.fleschKincaidGradeLevel()}');
    }));

    test('TextAnalyzer.tokenizer', () async {
      //

      // final stopWords = StringBuffer();
      // final stopwords = English().stopWords.map((e) => "'${e.stemPorter2()}',");
      // for (final e in stopwords) {
      //   stopWords.writeln(e);
      // }

      // print(stopWords.toString());
      // await SaveAs.text(fileName: 'stopwords', text: stopWords.toString());

      // convert the StringBuffer to a String
      final source = TestData.text;

      final analyzer =
          English(termExceptions: {'alphabet': 'ALPHABET', 'google': 'Google'});

      // tokenize the source
      final tokens = await analyzer.tokenizer(source,
          zone: 'text', nGramRange: NGramRange(1, 2));

      // print the tokens
      _printTokens('TOKENIZE JSON', tokens);
    });

    test('English()', () async {
      //

      // convert the StringBuffer to a String
      final source = TestData.text;

      final analyzer =
          English(termExceptions: {'alphabet': 'ALPHABET', 'google': 'Google'});

      // tokenize the source
      final tokens = await English.analyzer.tokenizer(source);
      // print the tokens
      _printTokens('TOKENIZE JSON ', tokens);
    });

    test('SPLITTERS', () async {
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
      print('${'String'.padRight(21)} ${'Syllables'.toString().padLeft(10)}');
      print('-'.padRight(31, '-'));
      for (final term in terms) {
        final syllableCount = English().syllableCounter(term);
        print('${term.padRight(20)}${syllableCount.toString().padLeft(10)}');
      }
      print('-'.padRight(31, '-'));
    });

    test('TextAnalyzer.JsonTokenizer(fields)', () async {
      //

      // test some exceptions
      final analyzer =
          English(termExceptions: {'tesla': 'Tesla', 'alphabet': 'GOOGLE'});

      // tokenize the json with 3 zones
      final tokens = await analyzer.jsonTokenizer(TestData.json,
          zones: ['name', 'description', 'hashTags']);

      // print the tokens
      _printTokens('TOKENIZE JSON', tokens);
    });

    /// Tokenize JSON with NO zones.
    test('TextAnalyzer.JsonTokenizer', () async {
      // tokenize the json with NO zones
      final tokens = await English.analyzer
          .jsonTokenizer(TestData.json, zones: ['description']);
      // map the document's tokens to a list of terms (strings)

      // print the tokens
      _printTokens('TOKENIZE JSON (${tokens.length})', tokens);
    });

    /// Tokenize JSON with NO zones.
    test('Iterable<String>.kGrams()', () async {
      // tokenize the json with NO zones
      final lexicon = englishLexicon.keys
          .where((element) => !element.contains(RegExp(r'[^a-zA-Z]')))
          .map((e) => e.toLowerCase());
      final kgrams = lexicon.toKGramsMap(2);
      // map the document's tokens to a list of terms (strings)

      // print the tokens
      await saveKgramIndex(kgrams);
    });

    test('TextAnalyzer.JsonTokenizer (performance)', () async {
      //
      final start = DateTime.now();
      // initialize a term dictionary
      final dictionary = <String, int>{};
      // iterate through sampleNews
      await Future.forEach(TestData.stockData.entries,
          (MapEntry<String, Map<String, dynamic>> entry) async {
        final json = entry.value;
        final tokens = await English.analyzer.jsonTokenizer(json,
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
      print('String:    Df');
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
    //

    test('English().nGrammer(sample, NGramRange(1, 3)', (() {
      final nGrams = English().nGrammer(sample, NGramRange(1, 3));
      print(nGrams);
    }));

    test('English().syllableCounter(sample)', (() {
      final analyzer = English.analyzer;
      final results = <Map<String, dynamic>>[];
      final terms = analyzer.termSplitter(sample);
      for (final e in terms) {
        results.add({
          'String': e,
          'Filtered': analyzer.termFilter(e),
          'Syllables': analyzer.syllableCounter(e)
        });
      }
      Console.out(title: 'Syllable Counter', results: results);
    }));
//

    test('English().keywordExtractor(sample).coOccurrenceGraph', (() async {
      final text =
          'Google quietly rolled out a new way for Android users to listen to '
          'podcasts and subscribe to shows they like, and it already works on '
          'your phone. Podcast production company Pacific Content got the '
          'exclusive on it. This text is taken from Google news.';

      final keywords = (await English().tokenizer(sample)).toPhrases();

      final graph =
          TermCoOccurrenceGraph(keywords) as TermCoOccurrenceGraphBase;
      // keyWords.coOccurenceGraph(keyWords.toUniqueTerms().toList());
      // .map((e) => e.join(' '));
      print(sample);
      print(''.padRight(140, '-'));
      for (final e in graph.coOccurrenceGraph.entries) {
        print('${e.key}: ${e.value}');
      }
      print(''.padRight(140, '-'));
      final entries = graph.keywordScores.entries.toList();
      entries.sort(((a, b) => b.value.compareTo(a.value)));
      for (final e in entries) {
        print('${e.key}: ${e.value.toStringAsFixed(2)}');
      }
    }));

    test('TextDocument.analyze(sample)(Keywords)', (() async {
      final example =
          'Google quietly rolled out a new way for Android users to listen to '
          'podcasts and subscribe to shows they like, and it already works on '
          'your phone. Podcast production company Pacific Content got the '
          'exclusive on it. This text is taken from Google news.';

      final document = await TextDocument.analyze(
          sourceText: sample, analyzer: English.analyzer);

      // .map((e) => e.join(' '));
      print(sample);
      print(''.padRight(140, '-'));
      final entries = document.keywords.keywordScores.entries.toList();
      entries.sort(((a, b) => b.value.compareTo(a.value)));
      for (final e in entries) {
        print('${e.key}: ${e.value.toStringAsFixed(1)}');
      }
    }));

    test('English().keywordExtractor(stockData)', (() async {
      // final text =
      //     'Google quietly rolled out a new way for Android users to listen to '
      //     'podcasts and subscribe to shows they like, and it already works on '
      //     'your phone. Podcast production company Pacific Content got the '
      //     'exclusive on it. This text is taken from Google news.';

      final text = TestData.stockData.entries.first.value
          .toSourceText({'name', 'description'});

      final keyWords = (await English().tokenizer(text)).toPhrases();

      // .map((e) => e.join(' '));
      print(text);
      print(''.padRight(140, '-'));
      print(keyWords);
      print(keyWords.toUniqueTerms());
    }));

    //
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

// /// Print the terms in List<[Token]>.
// void _printKeyWords(String title, Iterable<List<String>> keywords) {
//   //

//   // map the tokens to a list of JSON documents
//   final results = keywords
//       .map((e) => {'term': e.term, 'zone': e.zone, 'position': e.termPosition})
//       .toList();

//   // print the results
//   Console.out(title: title, results: results, maxColWidth: 120);

//   //
// }

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
