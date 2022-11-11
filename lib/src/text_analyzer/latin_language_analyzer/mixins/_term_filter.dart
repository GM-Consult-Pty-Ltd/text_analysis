// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

part of '../latin_language_analyzer.dart';

/// Implements [TextAnalyzer.termFilter].
abstract class _TermFilter implements TextAnalyzer {
//

  /// Implements [TextAnalyzer.termFilter].
  ///
  /// Returns one or more versions of the String as follows:
  /// - returns an empty set if the String is empty or in [stopWords];
  /// - looks up the text in [termExceptions] and returns the value if the
  ///   key exists;
  /// - looks up the term in [abbreviations] and, if found, returns three
  ///   versions: the abbreviation, the unabbreviated term or phrase and a
  ///   version with no punctuation;
  /// - adds the resulting term if it is longer than 1 and not in stop words;
  /// - add an un-hyphenated version if the term contains hyphens;
  /// - add an un-apostrophied version if the term has a possesive "'s";
  /// - split the term at all other non-word characters (where not preceded or
  ///   followed by numbers to avoid splitting numbers).
  /// - adds all the split terms
  Set<String> _filterTerms(String term) {
    // remove white-space from start and end of term
    term = term.trim();
    final Set<String> retVal = {};
    final exception = termExceptions[term]?.trim();
    if (exception != null) {
      return {exception};
    }
    if (term.isNotEmpty && !stopWords.contains(term)) {
      // exclude empty terms and that are stopwords
      final abbreviationTerms = term._abbreviatedVersions(abbreviations);
      retVal.addAll(abbreviationTerms);
      term = abbreviationTerms.length > 1 ? abbreviationTerms[1] : term;

      term = termExceptions[term] ?? term;
      if (!stopWords.contains(term) && term.length > 1) {
        // - add term and a version without hyphens to the return value
        retVal.addAll([term.unApostrophied, term.unHyphenated]);
        // split the term at non-word characters and add a term (or its
        // exception) for each.
        retVal.addAll(term._splitTerm(termExceptions, stopWords));
      }
    }
    retVal.removeWhere((e) => e.trim().isEmpty);
    return retVal;
  }

//
}

extension _TermFilterExtension on String {
  //

  /// Finds the string in [abbreviations].
  ///
  /// If found, returns a List of strings containing the abbreviation,
  /// the value for the abbreviation and a version of the abbreviation
  /// with all period marks removed.
  List<String> _abbreviatedVersions(Map<String, String> abbreviations) {
    final term = trim();
    final abbreviation = abbreviations[term];
    return abbreviation == null
        ? [term]
        : [term, abbreviation, term.replaceAll('.', '').trim()];
  }

  /// Removes all hyphenation characters from the string, where followed by a
  /// word character
  String get unHyphenated => replaceAll(RegExp(r'-+(?=[\w])'), '').trim();

  /// Removes all possesive apostrophed "'s" suffixes.
  String get unApostrophied =>
      replaceAll(RegExp(r"('s|'S)(?=[^\w])"), '').trim();

  /// Splits the term at all non-word characters unless the word starts or
  /// finishes with a number.
  ///
  /// - Removes all [stopwords].
  /// - Replaces all terms in [termExceptions].
  /// - Removes all terms that are only one character long.
  /// - Split the term at all non-word characters.
  /// - Add a phrase by rejoining terms longer than 1 character with
  ///   white-space.
  Set<String> _splitTerm(
      Map<String, String> termExceptions, Set<String> stopwords) {
    // final terms = <List<String>>{};
    final retVal = <String>{};
    // split at all non-word characters if not preceded or followd by a number
    // or word boundary
    final splitTerms = split(RegExp(
            r'(?<=[^0-9\b])[^a-zA-Z0-9À-öø-ÿ]+|[^a-zA-Z0-9À-öø-ÿ]+(?=[^0-9\b])'))
        .map((e) => termExceptions[e.trim()]?.trim() ?? e.trim())
        .toList()
        .where((element) => element.length > 1 && !stopwords.contains(element))
        .toList();
    retVal.addAll(splitTerms);
    // now reconstitute the split terms with white-s[ace]
    for (final term in splitTerms) {
      final phrase = <String>[];
      if (term.length > 1) {
        phrase.add(term);
      }
      if (phrase.isNotEmpty) {
        var term = phrase.join(' ');
        term = (termExceptions[term] ?? term).trim();
        if (term.length > 1) {
          retVal.add(term);
        }
      }
    }
    return retVal;
  }
}
