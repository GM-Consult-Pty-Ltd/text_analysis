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
      source.stripPunctuation().splitAtWhitespace()
        ..removeWhere((element) => element.isEmpty);
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
