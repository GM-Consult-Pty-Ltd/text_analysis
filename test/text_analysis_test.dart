// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'package:text_analysis/text_analysis.dart';
import 'package:test/test.dart';

void main() {
  group('TextAnalyzer', () {
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
      final document = await TextAnalyzer().tokenize(source);
      // map the document's tokens to a list of terms (strings)
      final terms = document.tokens.map((e) => e.term).toList();
      // print the terms
      print(terms);
    });
  });
}
