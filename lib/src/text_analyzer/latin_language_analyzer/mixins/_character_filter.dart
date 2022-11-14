// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

part of '../latin_language_analyzer.dart';

/// Implements [TextAnalyzer.characterFilter].
abstract class _CharacterFilter implements TextAnalyzer {
  //

  /// Implements [TextAnalyzer.characterFilter]:
  /// - returns the term if it can be parsed as a number; else
  /// - converts the term to lower-case;
  /// - changes all quote marks to single apostrophe +U0027;
  /// - removes enclosing quote marks;
  /// - changes all dashes to single standard hyphen;
  /// - normalizes all white-space to single space characters.
  String _filterCharacters(String term) {
    term = term.trim();
    // try parsing the term to a number
    final number = num.tryParse(term);
    // return the term if it can be parsed as a number
    return number != null
        // return number.toString() if number is not null.
        ? number.toString()
        // if the term is all-caps return it unchanged.
        : term
            .normalizeQuotes()
            .removeEnclosingQuotes()
            .removePossessives()
            .normalizeHyphens()
            .normalizeWhitespace();
  }

  //
}

/// String extensions used by the [LatinLanguageAnalyzer]text analyzer.
extension _CharacterFilterExtension on String {
//
  
  /// Replace all punctuation in the String with whitespace.
  String stripPunctuation() => trim()
      // replace all double quote characters with U+0022, and single quote
      // characters with +U0027
      .normalizeQuotes()
      // remove enclosing double and single quotes from start and end of string
      .removeEnclosingQuotes()
      // change all dashes to U+2011
      .normalizeHyphens()
      // replace all line endings with white-space.
      .replaceAll(RegExp(LatinLanguageAnalyzer.rLineEndingSelector), ' ')
      // replace all sentence endings with white-space.
      .replaceAll(RegExp(LatinLanguageAnalyzer.rSentenceEndingSelector), ' ')
      // replace all punctuation with white-space.
      .replaceAll(RegExp(LatinLanguageAnalyzer.rPunctuationSelector), ' ')
      // replace all brackets and carets with white-space.
      .replaceAll(RegExp(LatinLanguageAnalyzer.rBracketsAndCarets), ' ')
      // replace all repeated white-space with a single white-space.
      .normalizeWhitespace();
}
