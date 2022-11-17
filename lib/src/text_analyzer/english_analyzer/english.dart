// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

import 'package:text_analysis/type_definitions.dart';
import 'package:text_analysis/extensions.dart';
import 'package:text_analysis/text_analysis.dart';

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

  /// A collection of stop-words excluded from tokenization.
  static const kStopWords = _EnglishConstants.kStopWords;

  /// A list of English abbreviations.
  static const kAbbreviations = _EnglishConstants.kAbbreviations;

  /// Instantiates a static const [English] instance.
  static const TextAnalyzer analyzer = English();

  @override
  TermModifier get stemmer => _EnglishConstants.kStemmer;

  /// A list of common English abbreviations. This list is not exhaustive.
  Map<String, String> get abbreviations => _EnglishConstants.kAbbreviations;

  @override
  AsyncTermModifier get characterFilter => _filterCharacters;

  @override
  final Map<String, String> termExceptions;

  /// Implements [TextAnalyzer.characterFilter]:
  /// - returns null if the term can be parsed as a number; else
  /// - converts the term to lower-case;
  /// - changes all quote marks to single apostrophe +U0027;
  /// - removes enclosing quote marks;
  /// - changes all dashes to single standard hyphen;
  /// - normalizes all white-space to single space characters.
  Future<String?> _filterCharacters(String term, [String? zone]) async {
    term = term
        .trim()
        .normalizeQuotes()
        .removeEnclosingQuotes()
        .removePossessives()
        .normalizeHyphens()
        .normalizeWhitespace();
    // try parsing the term to a number
    final number = asNumber(term);
    // return the term if it can be parsed as a number
    return number != null
        // return number.toString() if number is not null.
        ? null
        // if the term is all-caps return it unchanged.
        : term;
  }

  @override
  TermExpander? get termExpander => ((source, [zone]) async {
        final abbreviation = kAbbreviations[source];
        return abbreviation == null ? {} : {abbreviation};
      });

  @override
  bool isStopword(String term) {
    return LatinLanguageAnalyzer.isNumberOrAmount(term) ||
        kStopWords.contains(term.toLowerCase());
  }

  @override
  num? asNumber(String term) {
    // remove commas, + signs and whitespace
    // replace "percent" with "%"
    term = term.replaceAll(r',\s\+', '').replaceAll('percent', '%');
    // check for presence of leading dash, multiply by -1.0 if present.
    var x =
        (RegExp(r'(?<=^)-(?=\W\d|[A-Z]{3}|\d)').allMatches(term).length == 1)
            ? -1.0
            : 1.0;
    // remove all dashes
    term = term.replaceAll(r'[\-]', '');
    // if percent then divide by 100
    x = (RegExp(r'(?<=\d)\s?%(?=\Z)').allMatches(term).length == 1)
        ? x / 100
        : x;
    // remove all "%" signs
    term = term.replaceAll(r'[\%]', '');
    // match all numbers where
    // - preceded by the start of the string or
    // - prececed by the start of the string AND a single non-word character or
    //   three/ upper-case letters; AND
    // - AND followed by the end of the string
    final numbers =
        RegExp(r'(?<=^|[A-Z]{3}|\A\W)(\d|((?<=\d)[,.]{1}(?=\d)))+(?=$)')
            .allMatches(term.normalizeWhitespace());
    if (numbers.length != 1) {
      return null;
    }
    final text = numbers.first[0];
    final number = (text != null) ? num.tryParse(text) : null;
    return number == null
        ? null
        : term.endsWith('%')
            ? x * number / 100
            : number * x;
  }
}
