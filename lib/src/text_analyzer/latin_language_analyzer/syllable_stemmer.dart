// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

part of 'latin_language_analyzer.dart';

/// English stemmer for counting syllables, performs only steps 0, 1A and 5.
class SyllableStemmer extends Porter2StemmerBase {
  @override
  String stem(String term) {
    // change all forms of apostrophes and quotation marks to [']
    // remove all enclosing quotation marks,
    // then call step 0.
    term = step0(removeEnclosingQuotes(normalizeQuotesAndApostrophes(term)));

    // check if word is identifier and return if true
    if (term.isIdentifier) {
      return term;
    }

    // call Step 1(a) after converting to lower-case and performing
    // y-substitution.
    term = step1A(replaceYs(term.toLowerCase()));

    // check for exceptions at end of Step 1(a) and return if found
    return step1AException(term) ??
        // else, call steps 1(b) through 5
        // then replace all upper-case "Y"s with "y"
        normalizeYs(step5(term));
  }

  @override
  Map<String, String> get exceptions => {};

  /// Search for the the following suffixes, and, if found:
  /// - "e": delete if in R2, or in R1 and not preceded by a short
  ///   syllable; or
  /// - "l": delete if in R2 and preceded by an "l".
  @override
  String step5(String term) {
    final e = exception(term);
    if (e != null) return e;
    final region1 = term.r1;
    final region2 = term.r2;
    if (region1 != null && (term.endsWith('e') || term.endsWith('l'))) {
      final stub = term.substring(0, term.length - 1);
      if (term.endsWith('e') && !term.endsWith('ue')) {
        return stub;
      }
      return ((region2 ?? '').endsWith('l') && stub.endsWith('l'))
          ? stub
          : term;
    }
    return term;
  }
}
