// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

part of '../latin_language_analyzer.dart';

/// Implements [TextAnalyzer.syllableCounter].
abstract class _SyllableCounter implements TextAnalyzer {
  //

  /// Implements [TextAnalyzer.syllableCounter]:
  /// - Trim leading and trailing white-space from term.
  /// - Return 0 if resulting term is empty.
  /// - Return 1 if the term length is 2 or less.
  /// - Split term into terms at one or more non-word characters
  /// - For each split term:
  ///   - add 1 if split term length is 2 or less; else
  ///   - stem each split term with the _SyllableStemmer to remove e's have
  ///     and convert vowel "y"s to "i"
  ///   - count apostropied syllables like "d'Azure" and remove the
  ///     apostrophied prefix
  ///   - add one for add each single vowel, diphtong and triptong if the word
  ///     ends with one or more consonants or ys.
  ///   - add one if stemmed word ends in 3 or more consonants.
  /// - if count is 0, return 1 because a word must have at least one syllable!
  int _countSyllables(String term) {
    term = term.trim();
    // return 0 if term is empty
    if (term.isEmpty) return 0;
    // return 1 if term length is less than 3
    if (term.length < 3) {
      return 1;
    } else {
      // initialize the return value
      var count = 0;
      // split term into terms at one or more non-word characters
      final terms =
          term.split(RegExp('${_LatinLanguageConstants.reNonWordChars}+'));
      for (var e in terms) {
        if (e.isNotEmpty) {
          if (e.length < 3) {
            count++;
          } else {
            // stem each term with the _SyllableStemmer.
            // DO NOT USE the analyzer stemmer as it may be overridden and we
            // must make sure the trailing silent e's are removed and vowel "y"s
            // are converted to "i"
            e = _SyllableStemmer().stem(e);
            // count apostropied syllables like "d'Azure" and remove the
            // apostrophied prefix
            e = e.replaceAllMapped(RegExp(r"(?<=\b)([a-zA-Z]')"), (match) {
              count++;
              return '';
            });

            // add all the single vowels, diphtongs and triptongs.
            // As e has been stemmed by the Porter2 stemmer, we know trailing
            // silent e's have been removed and vowel "y"s converted to "i"
            e = e.toLowerCase();
            if (e.contains(RegExp(r"[^aeiou\s\-\']+(?=\b)"))) {
              // term ends in one or more consonants or ys, count vowels,
              // diphtongs and triptongs.
              count += RegExp(r'[aeiouyà-æè-ðò-öø-ÿ]+').allMatches(e).length;
              // check for stemmed words ending in 3 or more consonants
              count +=
                  e.contains(RegExp(r"[^aeiouyà-æè-ðò-öø-ÿ\s\-\']{3,}(?=\b)"))
                      ? 1
                      : 0;
            } else {
              count += RegExp(r'[aeiouyà-æè-ðò-öø-ÿ]+').allMatches(e).length;
            }
          }
        }
      }
      // if count is 0, return 1 because a word must have at least one syllable
      return count < 1 ? 1 : count;
    }
  }

  //
}
