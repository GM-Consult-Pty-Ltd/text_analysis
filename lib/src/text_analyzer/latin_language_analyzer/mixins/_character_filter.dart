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
  /// - replaces all non-word characters with a space;
  /// - removes all characters except letters and numbers from the end of
  ///   the term.
  String _filterCharacters(String term) {
    // try parsing the term to a number
    final number = num.tryParse(term);
    // return the term if it can be parsed as a number
    return number != null
        // return number.toString() if number is not null.
        ? number.toString()
        // if the term is all-caps return it unchanged.
        : term
            // change to lower case.
            .toLowerCase()
            // change all quote marks to single apostrophe +U0027
            .replaceAll(RegExp('[\'"“”„‟’‘‛]+'), "'")
            // remove enclosing quote marks
            .replaceAll(RegExp(r"(^'+)|('+(?=$))"), '')
            // change all dashes to single standard hyphen
            .replaceAll(RegExp(r'[\-—]+'), '-')
            // // replace all non-word characters with whitespace
            // .replaceAll(
            //     RegExp('${_LatinLanguageConstants.reNonWordChars}+'), ' ')
            // // remove all characters except letters and numbers at end
            // // of term
            // .replaceAll(RegExp(r'[^a-zA-Z0-9À-öø-ÿ](?=$)'), '')
            // // replace all white-space sequence with single space and trim
            .normalizeWhitespace();
  }

  //
}

/// String extensions used by the [LatinLanguageAnalyzer]text analyzer.
extension _CharacterFilterExtension on String {
//

  /// Returns true if the String contains any non-word characters.
  bool get containsNonWordCharacters =>
      RegExp(_LatinLanguageConstants.reNonWordChars).hasMatch(this);

// Replace all white-space sequence with single space and trim.
  String normalizeWhitespace() => replaceAll(RegExp(r'(\s{2,})'), ' ').trim();

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
      .normalizeWhitespace()
      // remove leading and trailing white-space
      .trim();
}
