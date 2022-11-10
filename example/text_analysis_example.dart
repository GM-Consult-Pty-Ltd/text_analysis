// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

/// Add the import(s) at the top of your code file.
///
/// Import the text_analysis package.

import 'package:text_analysis/text_analysis.dart';

/// Import the extensions if you prefer the convenience of calling an extension.
import 'package:text_analysis/extensions.dart';

/// Private import for formatted printing to the console.
import 'package:gmconsult_dev/gmconsult_dev.dart';

void main() async {
  //

  await _readMeExample('README.md EXAMPLE');

  // print a seperator
  _seperator();

  // tokenize the paragraphs and print the terms
  _printTokens('TOKENIZE PARAGRAPHS', await _tokenizeParagraphs(exampleText));

  // print a seperator
  _seperator();

  // tokenize the zones in a json document and print the terms
  _printTokens('TOKENIZE JSON', await _tokenizeJson(json, zones));

  // print a seperator
  _seperator();

  // get a hashmap of tri-gram to terms in exampleText.first
  await _getKgramIndex('CREATE A k-Gram INDEX', exampleText.first, 3);

  // print a seperator
  _seperator();

  // print text statistics and readibility scores for readbilityExample
  await _analyzeText('ANALYZE TEXT', readabilityExample);

  // print a seperator
  _seperator();

  // print term similarity values for term vs candidates
  _similarityExamples('TERM SIMILARITY', term, candidates);

  // print a seperator
  _seperator();

  // print the n-grams in a paragraph of text
  _nGramsExample();

  //
}

// Simple example(s) for the README.md file.
Future<void> _readMeExample(String title) async {
  //
  // print a heading
  print(title);

  // define a misspelt term
  const term = 'bodrer';

  // a collection of auto-correct options
  const candidates = [
    'bord',
    'board',
    'broad',
    'boarder',
    'border',
    'brother',
    'bored'
  ];

  // get a list of the terms orderd by descending similarity
  final matches = term.matches(candidates);
  // same as TermSimilarity.matches(term, candidates))

  // print matches
  print('Ranked matches: $matches');
  // prints:
  //     Ranked matches: [border, boarder, bored, brother, board, bord, broad]
  //

  // Use the static TextTokenizer.english instance to tokenize the text using the
  // English analyzer.
  final tokens = await English().tokenizer(
      readabilityExample,
      strategy: TokenizingStrategy.all,
      nGramRange: NGramRange(1, 2));
  print(tokens.terms);

  // hydrate the TextDocument
  final textDoc = await TextDocument.analyze(
      sourceText: readabilityExample,
      analyzer: English.analyzer,
      nGramRange: NGramRange(1, 3));

  // print the `Flesch reading ease score`
  print(
      'Flesch Reading Ease: ${textDoc.fleschReadingEaseScore().toStringAsFixed(1)}');
}

// Print separator
void _seperator() {
  print(''.padRight(80, '-'));
  print('');
}

/// Print text statistics and readibility scores for [text].
Future<void> _analyzeText(String title, String text) async {
//
  // print a heading
  print(title);

  // hydrate the TextDocument
  final textDoc = await TextDocument.analyze(
      sourceText: text,
      analyzer: English.analyzer,
      nGramRange: NGramRange(1, 3));

  // print the `average sentence length`
  print('Average sentence length:    ${textDoc.averageSentenceLength()}');

  // print the `average syllable count`
  print(
      'Average syllable count:     ${textDoc.averageSyllableCount().toStringAsFixed(2)}');

  // print the `Flesch reading ease score`
  print(
      'Flesch Reading Ease:        ${textDoc.fleschReadingEaseScore().toStringAsFixed(1)}');

  // print the `Flesch-Kincaid grade level`
  print('Flesch-Kincaid Grade Level: ${textDoc.fleschKincaidGradeLevel()}');

  // output:
  //           Average sentence length:    13
  //           Average syllable count:     1.85
  //           Flesch Reading Ease:        37.5
  //           Flesch-Kincaid Grade Level: 11
}

/// Print the terms in List<[Token]>.
void _printTokens(String title, Iterable<Token> tokens) {
  //

  // map the tokens to a list of JSON documents
  final results = tokens
      .map((e) => {'term': e.term, 'zone': e.zone, 'position': e.termPosition})
      .toList();

  // print the results
  Console.out(title: title, results: results);

  //
}

/// Gets the k-grams for the terms in [text] and returns a hashmap of k-gram
/// to term.
Future<Map<String, Set<String>>> _getKgramIndex(
    String title, String text, int k) async {
//

  final tokens = await English().tokenizer(text);
  // get the bi-grams
  final Map<String, Set<String>> kGramIndex = tokens.kGrams(2);

  // initialize the results collection
  final results = <Map<String, dynamic>>[];

  // iterate over the k-Gram index
  for (final entry in kGramIndex.entries) {
    // create a result for each entry
    results.add({'k-Gram': entry.key, 'Terms': entry.value.toString()});
  }

  // print the results to the console
  Console.out(title: title, results: results);

  // return the k-Gram index
  return kGramIndex;
}

/// Tokenize the [zones] in a [json] document.
Future<List<Token>> _tokenizeJson(
    Map<String, dynamic> json, List<String> zones) async {
  // create a custom analyzer with exceptions
  final analyzer =
      English(termExceptions: {'tesla': 'Tesla', 'Alphabet': 'GOOGLE'});

  // use a TextTokenizer instance to tokenize the json
  final tokens =
      await analyzer.jsonTokenizer(json, zones: zones);
  // map the document's tokens to a list of terms (strings)
  return tokens;
}

/// Tokenize [paragraphs] to a List<[Token]>.
Future<List<Token>> _tokenizeParagraphs(Iterable<String> paragraphs) async {
  //

  // Initialize a StringBuffer to hold the source text
  final sourceBuilder = StringBuffer();

  // Concatenate the elements of [text] using line-endings
  for (final src in exampleText) {
    sourceBuilder.writeln(src);
  }

  // convert the StringBuffer to a String
  final source = sourceBuilder.toString();

  // use a TextTokenizer instance to tokenize the source
  final tokens = await English.analyzer
      .tokenizer(source, nGramRange: NGramRange(1, 3));

  return tokens;
}

void _nGramsExample() {
  final nGrams = English().nGrammer(readabilityExample, NGramRange(1, 3));
  print('N-Grams');
  print(nGrams);
}

/// Print term similarity values for [term] vs [candidates].
void _similarityExamples(
    String title, String term, Iterable<String> candidates) {
  //
  // print a heading
  print(title);

  // iterate over candidates
  for (final other in candidates) {
    //
    // print the terms
    print('($term: $other)');

    // print the editDistance
    print(
        '- Edit Distance:       ${term.editDistance(other).toStringAsFixed(3)}');
    // print the lengthDistance
    print(
        '- Length Distance:     ${term.lengthDistance(other).toStringAsFixed(3)}');
    // print the lengthSimilarity
    print(
        '- Length Similarity:   ${term.lengthSimilarity(other).toStringAsFixed(3)}');
    // print the jaccardSimilarity
    print(
        '- Jaccard Similarity:  ${term.jaccardSimilarity(other).toStringAsFixed(3)}');
    // print the editSimilarity
    print(
        '- Edit Similarity:     ${term.editSimilarity(other).toStringAsFixed(3)}');
    // print the characterSimilarity
    print(
        '- Character Similarity:     ${term.characterSimilarity(other).toStringAsFixed(3)}');
    // print the termSimilarity
    // print(
    //     '- String Similarity:     ${term.termSimilarity(other).toStringAsFixed(3)}');

    // print a seperator
    _seperator();
  }

  // get a list of the terms orderd by descending similarity
  // final matches = term.matches(candidates);
  // print('Ranked matches: $matches');
}

final candidates = [
  'bodrer',
  'bord',
  'board',
  'broad',
  'boarder',
  'border',
  'brother',
  'bored'
];

final term = 'bodrer';

final readabilityExample =
    'The Australian platypus is seemingly a hybrid of a mammal and reptilian creature.';

/// For this example we use a few paragraphs of text that contains
/// numbers, currencies, abbreviations, hyphens and identifiers.
const exampleText = [
  'The Dow Jones rallied even as U.S. troops were put on alert amid '
      'the Ukraine crisis. Tesla stock fought back while Apple '
      'stock struggled. ',
  '[TSLA.XNGS] Tesla\'s #TeslaMotor Stock Is Getting Hammered.',
  'Among the best EV stocks to buy and watch, Tesla (TSLA.XNGS) is pulling back '
      r'from new highs after a failed breakout above a $1,201.05 double-bottom '
      'entry. ',
  'Meanwhile, Peloton reportedly finds an activist investor knocking '
      'on its door after a major stock crash fueled by strong indications of '
      'mismanagement. In a scathing new letter released Monday, activist '
      'Tesla Capital is pushing for Peloton to fire CEO, Chairman and '
      'founder John Foley and explore a sale.'
];

/// A JSON document that will be tokenized by [tokenizeJson].
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

/// The zones in [json] to be tokenized.
const zones = ['name', 'description', 'hashTags', 'publicationDate'];
