// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

part of '../latin_language_analyzer.dart';

abstract class _TermSplitter implements TextAnalyzer {
  //

  /// The [LatinLanguageAnalyzer] implementation of [termSplitter].
  ///
  /// Splits the [source] into words.
  ///
  /// A word is defined as a sequence of word-characters bound by word
  /// boundaries either side. By definition all non-word characters are
  /// excluded from this definition.
  List<String> _splitToTerms(String source) => source.words;
}
