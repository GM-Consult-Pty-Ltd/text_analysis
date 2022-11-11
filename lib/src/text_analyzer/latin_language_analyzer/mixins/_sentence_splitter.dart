// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

part of '../latin_language_analyzer.dart';

abstract class _SentenceSplitter implements TextAnalyzer {
  //

  /// Implements [TextAnalyzer.sentenceSplitter].
  /// - Insert delimiters at sentence breaks.
  /// - Split the text into sentences at delimiters.
  /// - Trim leading and trailing white-space from all terms.
  /// - Return only non-empty elements.
  List<String> _splitToSentences(SourceText source) =>
      source.insertSentenceDelimiters().splitAtSentenceDelimiters();
}

extension _SentenceSplitterExtensionOnString on String {
  //

  /// Insert sentence delimiters into the String at sentence breaks.
  String insertSentenceDelimiters() => trim()
          // replace line feeds and carriage returns with %~%
          .replaceAll(RegExp(_LatinLanguageConstants.reSentenceEndingSelector),
              _LatinLanguageConstants.kSentenceDelimiter)
          // select all sentences and replace the ending punctuation with %~%
          .replaceAllMapped(
              RegExp(_LatinLanguageConstants.reSentenceEndingSelector),
              (match) {
        final sentence = match.group(0) ?? '';
        // remove white-space before delimiter then return the sentence
        return '$sentence$_LatinLanguageConstants.kSentenceDelimiter'
            .replaceAll(RegExp(r'(\s+)(?=%~%)'),
                _LatinLanguageConstants.kSentenceDelimiter);
      });

  /// Split the String at _LatinLanguageConstants.kSentenceDelimiter, trim the elements
  /// and return only non-empty elements.
  List<String> splitAtSentenceDelimiters() {
    // split at _LatinLanguageConstants.kSentenceDelimiter
    final sources = split(RegExp(_LatinLanguageConstants.kSentenceDelimiter));
    final sentences = <String>[];
    for (final e in sources) {
      // trim leading and trailing white-space from all elements
      final sentence = e
          .trim()
          .replaceAll(
              RegExp(_LatinLanguageConstants.reSentenceEndingSelector), '')
          .trim();
      // add only non-empty sentences
      if (sentence.isNotEmpty) {
        sentences.add(sentence);
      }
    }
    // return the sentences
    return sentences;
  }
}
