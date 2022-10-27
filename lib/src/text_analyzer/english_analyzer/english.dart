// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

import 'package:text_analysis/type_definitions.dart';
import 'package:text_analysis/text_analysis.dart';
import 'package:text_analysis/implementation.dart';
import 'package:porter_2_stemmer/porter_2_stemmer.dart';

part 'english_constants.dart';

/// A [TextAnalyzer] implementation for [English] language analysis.
class English with LatinLanguageAnalyzerMixin implements TextAnalyzer {
  //

  /// A const constructor to allow an instance to be used as default.
  ///
  /// [termExceptions] is a hashmap of words to token terms for special words
  /// that should not be re-capitalized, stemmed or lemmatized. The default
  /// [termExceptions] is an empty ```dart const <String, String>{}```.
  const English({this.termExceptions = const <String, String>{}});

  /// Instantiates a static const [English] instance.
  static const TextAnalyzer analyzer = English();

  @override
  Stemmer get stemmer => _EnglishConstants.kStemmer;

  @override
  Lemmatizer get lemmatizer => _EnglishConstants.kLemmatizer;

  @override
  Set<String> get stopWords => _EnglishConstants.kStopWords;

  @override
  Map<String, String> get abbreviations => _EnglishConstants.kAbbreviations;

  @override
  final Map<String, String> termExceptions;
}
