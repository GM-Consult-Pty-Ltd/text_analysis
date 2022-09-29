abstract class TextAnalysisTestData {
  /// Three paragraphs of text used for testing tokenization.
  ///
  /// Includes numbers, currencies, abbreviations, hyphens and identifiers
  static const text = [
    'The Dow Jones rallied even as U.S. troops were put on alert amid '
        'the Ukraine crisis. Tesla stock fought back while Apple '
        'stock struggled. ',
    '[TSLA.XNGS] Tesla\'s #TeslaMotor Stock Is Getting Hammered.',
    'Among the best EV stocks to buy and watch, Tesla '
        '(TSLA.XNGS) is pulling back from new highs after a failed breakout '
        'above a \$1,201.05 double-bottom entry. ',
    'Meanwhile, Peloton reportedly finds an activist investor from the Cote D\'Azure knocking '
        'on its door.  In a scathing new letter released Monday, activist '
        'Tesla Capital is pushing for Peloton to fire CEO, Chairman and '
        'founder John Foley and explore a sale.'
        'The stock crash has fueled by strong  suspicions of mismanagement.'
  ];

  static const json = {
    'avatarImageUrl':
        'https://firebasestorage.googleapis.com/v0/b/buysellhold-322d1.appspot.com/o/logos%2FTSLA%3AXNGS.png?alt=media&token=c365db47-9482-4237-9267-82f72854d161',
    'description': 'A stock split gave a nice short-term boost to Amazon Inc'
        'in late May and in early June. Alphabet has a planned '
        'stock split for next month. Tesla is also waiting on '
        'shareholder approval for a 3-for-1 stock split. ',
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
}
