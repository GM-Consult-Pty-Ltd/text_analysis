// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'package:text_analysis/text_analysis.dart';

/// [AnalysisLanguage] implementation for English.
class EnglishAnalysis implements AnalysisLanguage {
  //

  /// A const constructor to allow an instance to be used as default.
  const EnglishAnalysis();

  /// A static const [EnglishAnalysis] instance.
  static const instance = EnglishAnalysis();

  @override
  Iterable<String> get stopWords => kStopWords;

  @override
  String get lineEndingSelector => EnglishAnalysis.reLineEndingSelector;

  @override
  String get sentenceEndingSelector => EnglishAnalysis.reSentenceEndingSelector;

  @override
  String get punctuationSelector => EnglishAnalysis.rePunctuationSelector;

  @override
  String get bracketsAndCaretsSelector => EnglishAnalysis.reBracketsAndCarets;

  /// Returns a regular expression String that selects all brackets and carets.
  static const reBracketsAndCarets = r'\(|\)|\[|\]|\{|\}|\<|\>';

  /// A collection of stop-words excluded from tokenization.
  static const kStopWords = {
    'a',
    'about',
    'above',
    'across',
    'after',
    'against',
    'all',
    'along',
    'although',
    'among',
    'an',
    'and',
    'another',
    'any',
    'anybody',
    'anyone',
    'anything',
    'anywhere',
    'are',
    'around',
    'as',
    'at',
    'aught',
    'be',
    'because',
    'before',
    'behind',
    'between',
    'beyond',
    'both',
    'but',
    'by',
    'case',
    'certain',
    'concerning',
    'despite',
    'down',
    'during',
    'each',
    'either',
    'enough',
    'even',
    'event',
    'every',
    'everybody',
    'everyone',
    'everything',
    'everywhere',
    'except',
    'few',
    'fewer',
    'fewest',
    'following',
    'for',
    'from',
    'he',
    'her',
    'hers',
    'herself',
    'him',
    'himself',
    'his',
    'I',
    'idem',
    'if',
    'in',
    'including',
    'into',
    'is',
    'it',
    'its',
    'itself',
    'last',
    'least',
    'less',
    'lest',
    'like',
    'little',
    'long',
    'many',
    'me',
    'mine',
    'more',
    'most',
    'much',
    'my',
    'myself',
    'naught',
    'near',
    'neither',
    'next',
    'no',
    'nobody',
    'none',
    'nor',
    'not',
    'nothing',
    'nought',
    'now',
    'nowhere',
    'of',
    'off',
    'on',
    'once',
    'one',
    'only',
    'onto',
    'or',
    'order',
    'other',
    'others',
    'ought',
    'our',
    'ours',
    'ourself',
    'ourselves',
    'out',
    'over',
    'past',
    'plus',
    'provided',
    'said',
    'several',
    'she',
    'since',
    'so',
    'some',
    'somebody',
    'someone',
    'something',
    'somewhat',
    'somewhere',
    'soon',
    'such',
    'suchlike',
    'sufficient',
    'supposing',
    'than',
    'that',
    'the',
    'thee',
    'their',
    'theirs',
    'theirself',
    'theirselves',
    'them',
    'themself',
    'themselves',
    'there',
    'these',
    'they',
    'thine',
    'this',
    'those',
    'thou',
    'though',
    'throughout',
    'thy',
    'thyself',
    'till',
    'time',
    'to',
    'towards',
    'under',
    'unless',
    'until',
    'up',
    'upon',
    'us',
    'was',
    'we',
    'were',
    'what',
    'whatever',
    'whatnot',
    'whatsoever',
    'when',
    'whence',
    'whenever',
    'where',
    'whereas',
    'whereby',
    'wherefrom',
    'wherein',
    'whereinto',
    'whereof',
    'whereon',
    'wheresoever',
    'whereto',
    'whereunto',
    'wherever',
    'wherewith',
    'wherewithal',
    'whether',
    'which',
    'whichever',
    'whichsoever',
    'while',
    'who',
    'whoever',
    'whom',
    'whomever',
    'whomso',
    'whomsoever',
    'whose',
    'whosesoever',
    'whosever',
    'whoso',
    'whosoever',
    'with',
    'within',
    'without',
    'ye',
    'yet',
    'yon',
    'yonder',
    'you',
    'your',
    'yours',
    'yourself',
    'yourselves',
  };

  /// Matches all words that contain only letters and periods and end with
  /// a period.
  ///
  /// Use for finding acronyms and abbreviations.
  static const reWordEndsWithPeriod = r'(?)([a-zA-Z.]+)(?=([.]))';

  /// Does not match characters used to write words, including:
  ///   - numbers 0-9;
  ///   - letters a-z;
  ///   - letters A-Z;
  ///   - ampersand, apostrophe, underscore and hyhpen ("&", "'", "_", "-")
  static const reNonWordChars = r"[^a-zA-Z0-9¥Œ€@™#-\&_'-]";

  /// Matches characters used to write words, including:
  ///   - numbers 0-9;
  ///   - letters a-z;
  ///   - letters A-Z;
  ///   - ampersand, apostrophe, underscore and hyhpen ("&", "'", "_", "-")
  static const wordChars = r"[a-zA-Z0-9¥Œ€@™#-\&_'-]";

  /// Returns a regular expression String that selects all line endings.
  static const reLineEndingSelector = r'[\r|\n|\r\n]';

  /// Returns a regular expression String that selects all line endings.
  static const reSentenceEndingSelector =
      r"(?<=[a-zA-Z0-9-¥Œ€@™#-\&_'-]|\s)(\. )(?=([^a-z])|\s+|$)|(\.)(?=$)|(?<=[^([{])([?!])(?=([^)]}])|\s+|$)";

  /// Returns a regular expression String that selects all line endings.
  static const rePunctuationSelector =
      r"(?<=[a-zA-Z0-9¥Œ€@™#-\&_'-]|\s)[:;,\-—]+(?=[\s])|(\.{2,})";
}
