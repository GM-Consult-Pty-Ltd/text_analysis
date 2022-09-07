import 'package:text_analysis/text_analysis.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final List<Map<String, dynamic>> text = [
      {
        'title': 'Ukraine',
        'body': 'The Dow Jones rallied even as U.S. troops were put on alert amid '
            'the Ukraine crisis. Tesla stock fought back while Apple '
            'stock struggled. [TSLA.XNGS] Tesla #TeslaMotor Stock Is Getting Hammered.'
      },
      {
        'title': 'EV',
        'body': r'Among the best EV stocks to buy and watch, Tesla '
            '(TSLA.XNGS) is pulling back from new highs after a failed breakout '
            'above a 1,201.05 double-bottom entry. '
      },
      {
        'title': 'PLTN',
        'body': 'Meanwhile, Peloton reportedly finds an activist investor knocking '
            'on its door after a major stock crash fueled by strong indications of '
            'mismanagement. In a scathing new letter released Monday, activist '
            'Tesla Capital is pushing for Peloton to fire CEO, Chairman and '
            'founder John Foley and explore a sale.'
      }
    ];

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () async {
      final sourceBuilder = StringBuffer();
      for (final src in text) {
        sourceBuilder.writeln(src['body']);
      }
      final source = sourceBuilder.toString();
      final document = await TextAnalyzer().tokenize(source);
      final terms = document.tokens.map((e) => e.term).toList();
      print(terms);
    });
  });
}
