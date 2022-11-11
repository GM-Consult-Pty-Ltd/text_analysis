// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

part of '../latin_language_analyzer.dart';

abstract class _TermSplitter implements TextAnalyzer {
  //

  /// The [LatinLanguageAnalyzerMixin] implementation of [termSplitter].
  ///
  /// Algorithm:
  /// - Replace all punctuation, brackets and carets with white-space.
  /// - Split into terms at any sequence of white-space characters.
  /// - Trim leading and trailing white-space from all terms.
  /// - Return only non-empty terms.
  List<String> _splitToTerms(SourceText source) =>
      source.stripPunctuation().splitAtWhiteSpace()
        ..removeWhere((element) => element.isEmpty);
}

/// String extensions used by the [LatinLanguageAnalyzer]text analyzer.
extension _TermSplitterExtension on String {
//

  /// Split the String at (one or more) white-space characters.
  List<String> splitAtWhiteSpace() => split(RegExp(r'(\s+)'));

  /// Replace all forms of apostrophe or quotation mark with U+0027, then
  /// replace all enclosing single quotes with double quote U+201C
  String normalizeQuotesAndApostrophes() =>
      replaceAll(RegExp(_LatinLanguageConstants.rQuotes), "'")
          .replaceAll(RegExp(_LatinLanguageConstants.rEnclosingQuotes), '"');

  /// Replace all punctuation in the String with whitespace.
  String stripPunctuation() => trim()
      .normalizeQuotesAndApostrophes()
      // replace all brackets and carets with white-space.
      .replaceAll(RegExp(_LatinLanguageConstants.reLineEndingSelector), ' ')
      // replace all brackets and carets with white-space.
      .replaceAll(RegExp(_LatinLanguageConstants.reSentenceEndingSelector), ' ')
      // replace all brackets and carets with white-space.
      .replaceAll(RegExp(_LatinLanguageConstants.rePunctuationSelector), ' ')
      // replace all brackets and carets with white-space.
      .replaceAll(RegExp(_LatinLanguageConstants.reBracketsAndCarets), ' ')
      // replace all repeated white-space with a single white-space.
      .replaceAll(RegExp(r'(\s{2,})'), ' ')
      // remove leading and trailing white-space
      .trim();
}

/// LatinLanguage language specific extensions on String collections.
extension LatinLanguageStringCollectionExtension on Iterable<String> {
//

  /// Returns a set of all the unique terms contained in the String collection.
  Set<String> toUniqueTerms(TermSplitter splitter) {
    final retVal = <String>{};
    for (final e in this) {
      retVal.addAll(splitter(e));
    }
    return retVal;
  }
}
