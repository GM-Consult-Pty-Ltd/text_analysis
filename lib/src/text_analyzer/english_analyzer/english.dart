// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

import 'package:text_analysis/type_definitions.dart';
import 'package:text_analysis/text_analysis.dart';
import 'package:porter_2_stemmer/porter_2_stemmer.dart';

part 'english_constants.dart';

/// A [TextAnalyzer] implementation for [English] language analysis.
class English extends LatinLanguageAnalyzer implements TextAnalyzer {
  //

  /// A const constructor to allow an instance to be used as default.
  ///
  /// [termExceptions] is a hashmap of words to token terms for special words
  /// that should not be re-capitalized, stemmed or lemmatized. The default
  /// [termExceptions] is an empty ```dart const <String, String>{}```.
  const English({this.termExceptions = const <String, String>{}});

  /// Matches all instances of a posessive apostrophy, e.g. "Mary's".
  static const rPosessiveApostrophe = _EnglishConstants.rPosessiveApostrophe;

  /// A collection of stop-words excluded from tokenization.
  static const kStopWords = _EnglishConstants.kStopWords;

  /// A list of English abbreviations.
  static const kAbbreviations = _EnglishConstants.kAbbreviations;

  /// Instantiates a static const [English] instance.
  static const TextAnalyzer analyzer = English();

  /// Removes all posessive apostrophies from [text], e.g Mary's returns Mary.
  static String removePossessiveApostrophes(String text) =>
      text.replaceAll(RegExp(rPosessiveApostrophe), '');

  @override
  StringModifier get stemmer => _EnglishConstants.kStemmer;

  @override
  StringModifier get lemmatizer => _EnglishConstants.kLemmatizer;

  @override
  Map<String, String> get abbreviations => _EnglishConstants.kAbbreviations;

  @override
  final Map<String, String> termExceptions;

  @override
  CharacterFilter get characterFilter =>
      (term) => removePossessiveApostrophes(super.characterFilter(term));

  @override
  TermFlag get isStopWord => (term) =>
      _EnglishConstants.kStopWords.contains(term) || super.isStopWord(term);
}
