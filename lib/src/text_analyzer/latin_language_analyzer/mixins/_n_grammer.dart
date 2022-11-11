// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

part of '../latin_language_analyzer.dart';

/// Implements [TextAnalyzer.nGrammer].
abstract class _NGrammer implements TextAnalyzer {
  //

  /// Splits [text] into terms then converts the terms in to n-grams in [range].
  List<String> _toNGrams(String text, NGramRange range) =>
      termSplitter(text.trim()).nGrams(range)
        ..removeWhere((element) => element.isEmpty);
}
