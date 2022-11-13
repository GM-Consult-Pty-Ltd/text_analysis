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
    // try parsing the term to a number
    final number = num.tryParse(term);
    // return the term if it can be parsed as a number
    return number != null
        // return number.toString() if number is not null.
        ? number.toString()
        // if the term is all-caps return it unchanged.
        : term
            // change all quote marks to single apostrophe +U0027
            .replaceAll(RegExp('[\'"“”„‟’‘‛]+'), "'")
            // remove enclosing quote marks
            .replaceAll(RegExp(r"(^'+)|('+(?=$))"), '')
            // change all dashes to single standard hyphen
            .replaceAll(RegExp(r'[\-—]+'), '-')
            // replace all white-space sequence with single space and trim
            .normalizeWhitespace();
  }

  //
}

/// String extensions used by the [LatinLanguageAnalyzer]text analyzer.
extension _CharacterFilterExtension on String {
//

// Replace all white-space sequence with single space and trim.
  String normalizeWhitespace() => replaceAll(RegExp(r'(\s{2,})'), ' ').trim();

  /// Replace all forms of apostrophe or quotation mark with U+0027, then
  /// replace all enclosing single quotes with double quote U+201C
  String normalizeQuotesAndApostrophes() =>
      replaceAll(RegExp(LatinLanguageAnalyzer.rQuotes), "'")
          .replaceAll(RegExp(LatinLanguageAnalyzer.rEnclosingQuotes), '"');

  /// Replace all punctuation in the String with whitespace.
  String stripPunctuation() => trim()
      .normalizeQuotesAndApostrophes()
      // replace all brackets and carets with white-space.
      .replaceAll(RegExp(LatinLanguageAnalyzer.rLineEndingSelector), ' ')
      // replace all brackets and carets with white-space.
      .replaceAll(RegExp(LatinLanguageAnalyzer.rSentenceEndingSelector), ' ')
      // replace all brackets and carets with white-space.
      .replaceAll(RegExp(LatinLanguageAnalyzer.rPunctuationSelector), ' ')
      // replace all brackets and carets with white-space.
      .replaceAll(RegExp(LatinLanguageAnalyzer.rBracketsAndCarets), ' ')
      // replace all repeated white-space with a single white-space.
      .normalizeWhitespace()
      // remove leading and trailing white-space
      .trim();
}
