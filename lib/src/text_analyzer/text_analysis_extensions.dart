// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd

// ignore_for_file: camel_case_types

import 'package:text_analysis/type_definitions.dart';
import 'package:text_analysis/text_analysis.dart';
import 'package:text_analysis/extensions.dart';
import 'dart:math';

/// Extension methods on [Term] that exposes methods analysing and tokenizing
/// text.
extension TextAnalysisExtensionsOnJSON on Map<String, dynamic> {
  /// Parses the JSON to text.
  ///
  /// Calls toString() on the value of every field in [fieldNames] and writes
  /// the text to the return value as a new line, followed by an empty line.
  ///
  /// Every field value is preceded by a token in the format %fieldName%.
  ///
  /// If [fieldNames] is null, all the fields in the JSON will be parsed in
  /// the order of map entries.
  String toSourceText([Iterable<Zone>? fieldNames]) {
    final buffer = StringBuffer();
    if (fieldNames == null) {
      for (final entry in entries) {
        final fieldValue = entry.toString();
        // buffer.writeln('%${entry.key}%');
        buffer.writeln(fieldValue);
        buffer.write('\n');
      }
    } else {
      fieldNames = fieldNames.toSet();
      for (final zone in fieldNames) {
        final value = this[zone];
        if (value != null) {
          // buffer.writeln('%$zone%');
          buffer.writeln(value.toString());
          buffer.write('\n');
        }
      }
    }
    return buffer.toString();
  }
}

/// Extension methods on [Term] that exposes methods analysing and tokenizing
/// text.
extension TextAnalysisExtensionsOnString on String {
//


  /// Split the String at (one or more) white-space characters.
  List<String> splitAtWhitespace() => split(RegExp(r'(\s+)'));

  /// Replace all white-space sequences with single space and trim.
  String normalizeWhitespace() => replaceAll(RegExp(r'(\s{2,})'), ' ').trim();

  /// Replaces all double quote characters with U+0022, and single quote
  /// characters with +U0027
  String normalizeQuotes() => replaceAll(RegExp('$_rSingleQuotes+'), "'")
      .replaceAll(RegExp('$_rDoubleQuotes+'), '"');

  /// Replaces all dashes and hyphens (U+2011 through U+2014) with a standard
  /// hyphen (U+2011).
  String normalizeHyphens() =>
      replaceAll(RegExp('$_rDashesAndHyphens+'), '\u2011');

  static const _rDashesAndHyphens = '[\\\u2011\u2012\u2013\u2014]';

  // /// Selector for all single or double quotation marks and apostrophes.
  // static const _rAllQuotes = '["“”„‟\'’‘‛]';

  /// Selector for all single or double quotation marks and apostrophes.
  static const _rSingleQuotes = "['’‘‛]";

  /// Selector for all double quotation marks and apostrophes.
  static const _rDoubleQuotes = '["“”„‟]';

  static const _rQuotes =
      '(?<=^|[^a-zA-Z])(\'+)|(?<=[^sS])\'+(?=\$|[^a-zA-Z])|["“”„‟’‘‛]+';

  /// Selects all possessive apostrophes:
  /// - selects all instances of "'s" or "'S" where U+0027 is followed by an
  ///   "s", preceded by a letter or digit and followed by a character other
  ///   than a letter or digit.
  /// - selects all instances of "'" where U+0027 is preceded by "s" or "S" and
  ///   followed by a character other than a letter or digit.
  static const rPossessive =
      r"(?<=[a-zA-Z0-9])('s|'S)(?=[^a-zA-Z0-9])|(?<=[sS])(')(?=[^a-zA-Z])";

  /// Removes all posessive apostropes.
  /// - removes all instances of "'s" or "'S" where U+0027 is followed by an
  ///   "s", preceded by a letter or digit and followed by a character other
  ///   than a letter or digit.
  /// - removes all instances of "'" where U+0027 is preceded by "s" or "S" and
  ///   followed by a character other than a letter or digit.
  /// Call [normalizeQuotes] before use.
  String removePossessives() => replaceAll(RegExp(rPossessive), '');

  /// Removes all quote marks from the string, except where within a word
  /// or where it is a apostrophe preceded by n "s" or "S" (possessive plural).
  String removeQuotes() => replaceAll(RegExp(_rQuotes), '');

  /// Trims all forms of quotation marks from start of the String.
  ///
  /// Trims all forms of quotation marks from end of the String if the string
  /// starts with the same quotation mark.
  ///
  /// Only selects for U+0022 and U+0027, so call [normalizeQuotes] first.
  String removeEnclosingQuotes() {
    final term = trim();
    final startingQuote = RegExp('(?<=^)[\'"]+').firstMatch(term)?[0];
    return (startingQuote != null)
        ? term.replaceAll(
            RegExp('(?<=^)$startingQuote|$startingQuote(?=\$)'), '')
        : term;
  }

  /// Returns all the vowels in the String.
  List<String> get vowels => RegExp(r'[aeiouyà-æè-ðò-öø-ÿ]')
      .allMatches(this)
      .map((e) => e.group(0) as String)
      .toList();

  /// Returns all the diphtongs in the String.
  List<String> get diphtongs => RegExp(r'[aeiouyà-æè-ðò-öø-ÿ]{2,}')
      .allMatches(this)
      .map((e) => e.group(0) as String)
      .toList();

  /// Returns all the diphtongs in the String.
  List<String> get triptongs => RegExp(r'[aeiouyà-æè-ðò-öø-ÿ]{3,}')
      .allMatches(this)
      .map((e) => e.group(0) as String)
      .toList();

  /// Returns the number of single vowels, diphtongs and triptongs in the
  /// String.
  int get vowelDipthongAndTriptongCount =>
      RegExp(r'[aeiouyà-æè-ðò-öø-ÿ]+').allMatches(this).length;
}

/// Extension methods on [Term] that exposes methods analysing and tokenizing
/// text.
extension TextAnalysisExtensionsOnStringList on List<String> {
  //

  /// Returns an ordered collection of n-grams from the list of Strings.
  ///
  /// The n-gram lengths are limited by [range]. If range is NGramRange(1,1)
  /// the list will be returned as is.
  List<String> nGrams(NGramRange range) {
    // return empty list if the collection is empty
    if (isEmpty) return [];

    // initialize the return value collection
    final retVal = <String>[];
    // initialize a rolling n-gram element word-list
    final nGramTerms = <String>[];
    // iterate through the terms
    for (var term in this) {
      // initialize the ngrams collection
      final nGrams = <List<String>>[];
      // remove white-space at start and end of term
      term = term.trim();
      // ignore empty strings
      if (term.isNotEmpty) {
        nGramTerms.add(term);
        if (nGramTerms.length > range.max) {
          nGramTerms.removeAt(0);
        }
        var n = 0;
        for (var i = nGramTerms.length - 1; i >= 0; i--) {
          final param = <List<String>>[];
          param.addAll(nGrams
              .where((element) => element.length == n)
              .map((e) => List<String>.from(e)));
          final newNGrams = _prefixWordTo(param, nGramTerms[i]);
          nGrams.addAll(newNGrams);
          n++;
        }
      }
      final tokenGrams = nGrams.where((element) =>
          element.length >= range.min && element.length <= range.max);
      for (final e in tokenGrams) {
        final nGram = e.join(' ');
        retVal.add(nGram);
      }
    }
    return retVal;
  }

  static Iterable<List<String>> _prefixWordTo(
      Iterable<List<String>> nkGrams, String word) {
    final nGrams = List<List<String>>.from(nkGrams);
    final retVal = <List<String>>[];
    if (nGrams.isEmpty) {
      retVal.add([word]);
    }
    for (final nGram in nGrams) {
      nGram.insert(0, word);
      retVal.add(nGram);
    }
    return retVal;
  }
}

/// Extension methods on a collection of [Token].
extension TokenCollectionExtension on Iterable<Token> {
//

  /// Returns a list of unique [Phrase]s from the [terms] in the collection.
  ///
  /// Splits each unique term at white-space and adds it to the set.
  Set<List<String>> toPhrases() {
    final keywords = <List<String>>{};
    for (var term in terms) {
      term = term.normalizeWhitespace();
      final kw = term.split(RegExp(r'\s+'));
      if (kw.isNotEmpty) {
        keywords.add(kw);
      }
    }
    return keywords;
  }

  /// Returns a hashmap of k-grams to terms from the collection of tokens.
  Map<KGram, Set<Term>> kGrams([int k = 2]) => terms.toKGramsMap(k);

  /// Returns the set of unique terms from the collection of [Token]s.
  Set<String> get terms => Set<String>.from(map((e) => e.term.trim()));

  /// Returns a list of all the terms from the collection of [Token]s, in
  /// the same order as they occur in the [SourceText].
  List<String> get allTerms {
    final allTerms = List<Token>.from(this);
    allTerms.sort(((a, b) => a.termPosition.compareTo(b.termPosition)));
    return allTerms.map((e) => e.term).toList();
  }

  /// Filters the collection for tokens with [Token.term] == [term].
  ///
  /// Orders the filtered [Token]s by [Token.termPosition] in ascending order.
  Iterable<Token> byTerm(Term term) {
    final tokens = where((element) => element.term == term).toList();
    tokens.sort((a, b) => a.termPosition.compareTo(b.termPosition));
    return tokens;
  }

  /// Returns the count where [Token.term] == [term].
  int termCount(Term term) => byTerm(term).length;

  /// Returns the highest [Token.termPosition] where [Token.term] == [term].
  @Deprecated('The [maxIndex] extension method will be removed.')
  int lastPosition(Term term) => byTerm(term).last.termPosition;

  /// Returns the lowest [Token.termPosition] where [Token.term] == [term].
  int firstPosition(Term term) => byTerm(term).first.termPosition;
}

/// String collection extensions to generate k-gram maps.
extension KGramExtensionOnTermCollection on Iterable<String> {
  /// Returns a hashmap of k-grams to terms from the collection of tokens.
  Map<KGram, Set<Term>> toKGramsMap([int k = 2]) {
    final terms = this;
    // print the terms
    final Map<String, Set<Term>> kGramIndex = {};
    for (final term in terms) {
      final kGrams = term.kGrams(k);
      for (final kGram in kGrams) {
        final set = kGramIndex[kGram] ?? {};
        set.add(term);
        kGramIndex[kGram] = set;
      }
    }
    return kGramIndex;
  }
}

/// Extensions on List<String> lists.
extension StringCollectionCollectionExtension on Iterable<List<String>> {
//

  /// Returns a set of all the unique terms contained in the Keyword collection.
  Set<String> toUniqueTerms() {
    final retVal = <String>{};
    for (final e in this) {
      retVal.addAll(e);
    }
    return retVal;
  }

  /// Builds a co-occurrency graph for the ordered list of terms from the
  /// elements (keywords) of the collection.
  Map<String, List<int>> coOccurenceGraph(List<String> terms) {
    final Map<String, List<int>> retVal = {};
    for (final rowKey in terms) {
      final row = List<int>.filled(terms.length, 0);
      var x = 0;
      for (final term in terms) {
        final tF = where(
                (element) => element.contains(rowKey) && element.contains(term))
            .length;
        row[x] = tF;
        x++;
      }
      retVal[rowKey] = row;
    }

    return retVal;
  }
}

/// Extensions on Map<String, num>, used for working with vector-space models.
extension VectorSpaceMapExtensions on VectorSpace {
  //

  /// Returns the `cosine similarity` between this vector and [other].
  ///
  /// Calculates the similarity of the vectors measured as the cosine of the
  /// angle between them, i.e. the dot product of the vectors divided by the
  /// product of their euclidian lengths
  double cosineSimilarity(Map<Term, num> other) {
    // initialize square of euclidian length for the document.
    double eLDSq = 0.0;
    // initialize square of euclidian length for query.
    double eLQSq = 0.0;
    double dotProduct = 0.0;
    final terms = keys.toSet().union(other.keys.toSet());
    for (final t in terms) {
      final vQ = other[t] ?? 0.0;
      final vD = this[t] ?? 0.0;
      eLQSq = eLQSq + pow(vQ, 2);
      eLDSq = eLDSq + pow(vD, 2);
      dotProduct = dotProduct + vQ * vD;
    }
    return dotProduct / (sqrt(eLQSq) * sqrt(eLDSq));
  }
}
