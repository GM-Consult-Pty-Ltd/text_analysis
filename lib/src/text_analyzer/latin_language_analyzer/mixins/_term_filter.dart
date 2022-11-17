// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

part of '../latin_language_analyzer.dart';

/// Implements [TextAnalyzer.termFilter].
abstract class _TermFilter implements TextAnalyzer {
//

  /// Returns true if the [term] is a stopword excluded from tokenization.
  bool isStopword(String term);

  /// Attempts to parse the term to a number. Returns null if the term does not
  /// represent a number, amount or percentage
  num? asNumber(String term);

  /// A map of term exceptions
  Map<String, String> get termExceptions;

  /// Language-specific function that returns the stem of a term.
  TermModifier get stemmer;

  /// Implements [TextAnalyzer.termFilter].
  ///
  /// Normalizes the white-space in the term then returns the term if it is
  /// not empty.
  Future<String?> _filterTerm(String term, [String? zone]) async {
    String? retval = term.normalizeWhitespace();
    // check for exceptions
    final ex = termExceptions[retval];
    if (ex != null) {
      return ex.isEmpty ? null : ex;
    }
    if (!isStopword(retval)) {
      retval = retval.isEmpty ? null : retval;
      // stem if single word with only letters
      if (retval != null &&
          retval.termCount == 1 &&
          RegExp(r'[^a-zA-Z\-]').allMatches(retval).isEmpty) {
        retval = stemmer(retval);
        final ex = termExceptions[retval];
        if (ex != null) {
          return ex.isEmpty ? null : ex;
        }
      }
      // check for exceptions in n-grams
      if (retval != null && retval.termCount > 1) {
        final words = retval.splitAtWhitespace();
        final newWords = <String>[];
        for (final e in words) {
          if (!isStopword(e)) {
            newWords.add(termExceptions[e] ?? e);
          }
        }
        retval = newWords.join(' ').normalizeWhitespace();
      }
      return retval == null || retval.trim().isEmpty || isStopword(retval)
          ? null
          : retval;
    }
    return null;
  }

//
}

extension _TermFilterExtension on String {
  //

  // /// Finds the string in [abbreviations].
  // ///
  // /// If found, returns a List of strings containing the abbreviation,
  // /// the value for the abbreviation and a version of the abbreviation
  // /// with all period marks removed.
  // List<String> _abbreviatedVersions(Map<String, String> abbreviations) {
  //   final term = trim();
  //   final abbreviation = abbreviations[term];
  //   return abbreviation == null
  //       ? [term]
  //       : [term, abbreviation, term.replaceAll('.', '').trim()];
  // }

  // /// Removes all hyphenation characters from the string, where followed by a
  // /// word character
  // String get unHyphenated => replaceAll(RegExp(r'-+(?=[\w])'), '').trim();

  // /// Replaces all hyphenation characters with a space, where followed by a
  // /// word character
  // String get spaceHyphenated => replaceAll(RegExp(r'-+(?=[\w])'), ' ').trim();

  // /// Removes all possesive apostrophed "'s" suffixes.
  // String get unApostrophied =>
  //     replaceAll(RegExp(r"('s|'S)(?=[^\w])"), '').trim();

  // /// Splits the term at all non-word characters unless the word starts or
  // /// finishes with a number.
  // ///
  // /// - Removes all stopwords.
  // /// - Replaces all terms in [termExceptions].
  // /// - Removes all terms that are only one character long.
  // /// - Split the term at all non-word characters.
  // /// - Add a phrase by rejoining terms longer than 1 character with
  // ///   white-space.
  // Set<String> _splitTerm(
  //     Map<String, String> termExceptions,
  //     TermFlag isStopWord) {
  //   // final terms = <List<String>>{};
  //   final retVal = <String>{};
  //   // split at all non-word characters if not preceded or followed by a number
  //   // or word boundary
  //   final splitTerms = split(RegExp(
  //           r'(?<=[^0-9\b])[^a-zA-Z0-9À-öø-ÿ]+|[^a-zA-Z0-9À-öø-ÿ]+(?=[^0-9\b])'))
  //       .map((e) => termExceptions[e.trim()]?.trim() ?? e.trim())
  //       .toList()
  //       .where((element) => element.length > 1 && !isStopWord(element))
  //       .toList();
  //   retVal.addAll(splitTerms);
  //   // now reconstitute the split terms with white-s[ace]
  //   for (final term in splitTerms) {
  //     final phrase = <String>[];
  //     if (term.length > 1) {
  //       phrase.add(term);
  //     }
  //     if (phrase.isNotEmpty) {
  //       var term = phrase.join(' ');
  //       term = (termExceptions[term] ?? term).trim();
  //       if (term.length > 1) {
  //         retVal.add(term);
  //       }
  //     }
  //   }
  //   return retVal;
  // }
}
