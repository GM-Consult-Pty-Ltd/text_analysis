// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

part of '../latin_language_analyzer.dart';

abstract class _ParagraphSplitter implements TextAnalyzer {
  //

  /// The [LatinLanguageAnalyzerMixin] implementation of [paragraphSplitter].
  ///
  /// Algorithm:
  /// - Split the text at line endings.
  /// - Trim leading and trailing white-space from all terms.
  /// - Return only non-empty elements.
  List<String> _splitToParagraphs(String source) => source.splitAtLineEndings();
}

extension _ParagraphSplitterExtension on String {
  /// Split the String at line endings.
  List<String> splitAtLineEndings() {
    final paragraphs =
        trim().split(RegExp(LatinLanguageAnalyzer.rLineEndingSelector));
    final retVal = <String>[];
    for (final e in paragraphs) {
      final paragraph = e.trim();
      if (paragraph.isNotEmpty) {
        retVal.add(paragraph);
      }
    }
    return retVal;
  }
}
