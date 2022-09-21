// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

/// Import the text_analysis package by adding this line at the top of your
/// code file.
import 'package:text_analysis/text_analysis.dart';

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

void main() async {
  //

  // tokenize the paragraphs and print the terms.
  _printTerms(await _tokenizeParagraphs(exampleText));

  // tokenize the zones in a json document and print the terms.
  _printTerms(await _tokenizeJson(json, zones));

  // get a a hashmap of tri-gram to terms in exampleText.first
  await _getKgramIndex(exampleText.first, 3);
}

/// Print the terms in [textSource].
void _printTerms(TextSource textSource) {
  // map the document's tokens to a list of terms (strings)
  final terms = textSource.tokens.map((e) => e.term).toList();
  // print the terms
  print(terms);

  /// Tokenize the [zones] in a [json] document.
}

/// Gets the k-grams for the terms in [text] and returns a hashmap of k-gram
/// to term.
Future<Map<KGram, Set<Term>>> _getKgramIndex(SourceText text, int k) async {
  final document = await TextAnalyzer().tokenize(text);
  // get the bi-grams
  final Map<String, Set<Term>> kGramIndex = document.tokens.kGrams(3);
  // add the tri-grams
  // kGramIndex.addAll(document.tokens.kGrams(3));
  print('${'k-gram'.padRight(8)} Terms Set');
  for (final entry in kGramIndex.entries) {
    print('${entry.key.padRight(8)} ${entry.value}');
  }
  return kGramIndex;
}

/// Tokenize the [zones] in a [json] document.
Future<TextSource> _tokenizeJson(
    Map<String, dynamic> json, List<Zone> zones) async {
  // use a TextAnalyzer instance to tokenize the json
  final textSource = await TextAnalyzer().tokenizeJson(json, zones);
  // map the document's tokens to a list of terms (strings)
  final terms = textSource.tokens.map((e) => e.term).toList();
  // print the terms
  print(terms);
  return textSource;
}

/// Tokenize [paragraphs] to a [TextSource] that enumerates a collection
/// of [Sentence] objects with their [Token]s
Future<TextSource> _tokenizeParagraphs(Iterable<String> paragraphs) async {
  // Initialize a StringBuffer to hold the source text
  final sourceBuilder = StringBuffer();

  // Concatenate the elements of [text] using line-endings
  for (final src in exampleText) {
    sourceBuilder.writeln(src);
  }

  // convert the StringBuffer to a String
  final source = sourceBuilder.toString();

  // use a TextAnalyzer instance to tokenize the source
  final document = await TextAnalyzer().tokenize(source);

  // map the document's tokens to a list of terms (strings)
  final terms = document.tokens.map((e) => e.term).toList();

  // print the terms
  print(terms);
  return document;
}
