// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'package:text_analysis/src/_index.dart';

/// Interface for a text analyser class that extracts tokens from text for use
/// in full-text search queries and indexes.
abstract class TextAnalyzerBase {
  //

  // /// A hashmap of terms (keys) with their stem values that will be returned
  // /// rather than being processed by the stemmer.
  // ///
  // /// The default is [Porter2Stemmer.kExceptions].
  // Map<String, String> get stemmerExceptions;

  /// The [TextAnalyzerConfiguration] used by the [TextAnalyzerBase].
  TextAnalyzerConfiguration get configuration;

  /// A filter that returns a subset of tokens.
  ///
  /// Provide a [tokenFilter] if you want to manipulate tokens or restrict
  /// tokenization to tokens that meet criteria for either index or count.
  TokenFilter? get tokenFilter;

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

  /// Hydrates a const TextAnalyzer.
  const TextAnalyzer(
      {this.configuration = English.configuration, this.tokenFilter});

  @override
  TextSource tokenize(String source) {
    final sentenceStrings = configuration.splitIntoSentences(source);
    final sentences = _getSentences(sentenceStrings);
    return TextSource(source, sentences);
  }

  @override
  final TokenFilter? tokenFilter;

  @override
  final TextAnalyzerConfiguration configuration;

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

  /// Extracts tokens from [sentence] for use in full-text search queries and indexes.
  ///
  /// Returns a list of [Token].
  List<Token> _tokenizeSentence(String sentence) {
    // perform the first punctuation and white-space split
    final terms = configuration.splitIntoTerms(sentence);
    // initialize the tokens collection (return value)
    final tokens = <Token>[];
    // initialize the index
    var index = 0;
    // iterate through the terms
    for (var term in terms) {
      // calculate the index increment from the raw term length
      final increment = term.length + 1;
      // remove white-space at start and end of term
      term = term.trim();
      // only tokenize non-empty strings.
      if (term.isNotEmpty) {
        // apply the termFilter if it is not null
        final splitTerms = configuration.termFilter != null
            ? configuration.termFilter!(term)
            : [term];
        // initialize a sub-index for split terms
        var subIndex = 0;
        var i = 0;
        for (var splitTerm in splitTerms) {
          // apply the characterFilter if it is not null
          splitTerm = configuration.characterFilter != null
              ? configuration.characterFilter!(splitTerm)
              : splitTerm;
          // apply the stemmer if it is not null

          tokens.add(Token(splitTerm, index + subIndex));
          // only increment the sub-index after the first term
          if (i > 0) {
            subIndex += splitTerm.length + 1;
          }
          i++;
        }
        // }
      }
      // increment the index
      index = index + increment;
    }
    // apply the tokenFilter if it is not null and return the tokens collection
    return tokenFilter != null ? tokenFilter!(tokens) : tokens;
  }

  // @override
  // Map<String, String> get stemmerExceptions => Porter2Stemmer.kExceptions;

  /// Regular expression String that selects all sentence endings.
  static const kLineEndingSelector = r'';

  /// Returns a regular expression String that selects all sentence endings.
  static const kSentenceEndingSelector = r'';
}
