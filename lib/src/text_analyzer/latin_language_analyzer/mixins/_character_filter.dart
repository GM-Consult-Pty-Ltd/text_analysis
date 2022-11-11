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
  /// - removes all non-word characters from the term;
  /// - replaces all characters except letters and numbers from the end of
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
            // remove all non-word characters
            .replaceAll(RegExp(_LatinLanguageConstants.reNonWordChars), '')
            // remove all characters except letters and numbers at end
            // of term
            .replaceAll(RegExp(r'[^a-zA-Z0-9À-öø-ÿ](?=$)'), '')
            .trim();
  }

  //
}
