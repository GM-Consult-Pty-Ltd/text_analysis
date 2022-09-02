// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

// import 'package:text_analysis/text_analysis.dart';

import 'package:porter_2_stemmer/porter_2_stemmer.dart';
import 'package:text_analysis/src/_index.dart';

/// Interface for a text analyser class that extracts tokens from text for use
/// in full-text search queries and indexes.
abstract class TextAnalyzerBase {
  //

  /// A stemmer function that returns the stem of term.
  Stemmer get stemmerFunction;

  /// A hashmap of terms (keys) with their stem values that will be returned
  /// rather than being processed by the stemmer.
  ///
  /// The default is [Porter2Stemmer.kExceptions].
  Map<String, String> get stemmerExceptions;

  /// Returns a regular expression String that selects all sentence endings.
  String get sentenceEndingSelector;

  /// Returns a regular expression String that selects all line endings.
  String get lineEndingSelector;

  /// The [AnalysisLanguage] used by the [TextAnalyzerBase].
  AnalysisLanguage get language;

  /// Extracts tokens from text for use in full-text search queries and indexes.
  ///
  /// Returns a [TextSource] with [source] and its component [Sentence]s and
  /// [Token]s
  TextSource tokenize(String source);
}

/// A [TextAnalyzerBase] implementation that extracts tokens from text for use
/// in full-text search queries and indexes.
class TextAnalyzer implements TextAnalyzerBase {
  //

  /// Hydrates a const TextAnalyzer
  const TextAnalyzer({this.language = EnglishAnalysis.instance});

  @override
  TextSource tokenize(String source) {
    final sentenceStrings = _splitIntoSentences(source);
    final sentences = _getSentences(sentenceStrings);
    return TextSource(source, sentences);
  }

  @override
  final AnalysisLanguage language;

  /// A filter function remove terms to be excluded from analysis such as
  /// common stopwords that have no relevance in the analysis.
  List<String> _excludeStopWords(List<String> terms) {
    terms.removeWhere((element) => language.stopWords.contains(element));
    return terms;
  }

  RegExp get _punctuationRegex {
    return RegExp(language.punctuationSelector);
  }

  /// Splits [source] into all the terms.
  List<String> _splitIntoTerms(String source) {
    // replace all punctuation with whitespace.
    source = source
        .replaceAll(_punctuationRegex, ' ')
        // replace all brackets and carets with _kTokenDelimiter.
        .replaceAll(RegExp(language.bracketsAndCaretsSelector), ' ')
        // replace all repeated white-space with a single white-space.
        .replaceAll(RegExp(r'(\s{2,})'), ' ');
    // split at white-space
    final terms = source.split(RegExp(' '));
    return terms;
  }

  static const _kSentenceDelimiter = r'%~%';

  /// Splits [source] into sentences at all sentence endings.
  List<String> _splitIntoSentences(String source) {
    source = source
        // replace line feeds and carriage returns with %~%
        .replaceAll(RegExp(language.lineEndingSelector), _kSentenceDelimiter)
        // select all sentences and replace the ending punctuation with %~%
        .replaceAllMapped(RegExp(language.sentenceEndingSelector), (match) {
      final sentence = match.group(0) ?? '';
      if (sentence.isNotEmpty) {
        return '$sentence$_kSentenceDelimiter';
      }
      return '';
    });
    // split at sentence tokens
    final sources = source.trim().split(RegExp(_kSentenceDelimiter));
    return sources;
  }

  /// Splits the [source] into [Sentence]s
  List<Sentence> _getSentences(List<String> sentences) {
    final retVal = <Sentence>[];
    for (final sentence in sentences) {
      final tokens = _tokenizeSentence(sentence);
      final value = Sentence(sentence, tokens);
      retVal.add(value);
    }
    return retVal;
  }

  /// Returns a regular expression String that selects all sentence endings.
  @override
  String get sentenceEndingSelector => TextAnalyzer.kLineEndingSelector;

  /// Returns a regular expression String that selects all line endings.
  @override
  String get lineEndingSelector => TextAnalyzer.kSentenceEndingSelector;

  /// Extracts tokens from [sentence] for use in full-text search queries and indexes.
  ///
  /// Returns a list of [Token].
  List<Token> _tokenizeSentence(String sentence) {
    // TODO: remove all sentence ending punctuation? Be careful of destroying identifiers
    sentence = sentence.replaceAll(RegExp(r'[\.|\!|\?](?=$)'), '');
    final terms = _splitIntoTerms(sentence);
    final filteredTerms = _excludeStopWords(terms);
    final tokens = <Token>[];
    var index = 0;
    for (var term in terms) {
      term = term.trim();
      if (filteredTerms.contains(term)) {
        final stem = stemmerFunction(term);
        tokens.add(Token(stem, index));
        final splitTerms = term
            .split(RegExp(r'(?<=[^0-9.])[\.\:\-—](?=[^0-9])'))
            .where((element) => element.isNotEmpty)
            .map((e) => e.replaceAll(RegExp(r'[\.\:\-—](?=$)'), ''));
        if (splitTerms.length > 1 &&
            splitTerms.where((element) => element.length > 1).isNotEmpty) {
          var subIndex = index;
          for (final splitTerm in splitTerms) {
            tokens.add(Token(splitTerm, subIndex));
            subIndex += splitTerm.length + 1;
          }
        }
      }
      index = index + term.length + 1;
    }
    return tokens;
  }

  @override
  Map<String, String> get stemmerExceptions => Porter2Stemmer.kExceptions;

  @override
  Stemmer get stemmerFunction =>
      Porter2Stemmer(exceptions: stemmerExceptions).stem;

  /// Regular expression String that selects all sentence endings.
  static const kLineEndingSelector = r'';

  /// Returns a regular expression String that selects all sentence endings.
  static const kSentenceEndingSelector = r'';
}
