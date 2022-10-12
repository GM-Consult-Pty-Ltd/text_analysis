// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd
// All rights reserved

part of 'english.dart';

/// String extensions used by the [English] text analyzer.
extension EnglishStringExtensions on String {
//

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

  /// Replace all punctuation in the String with whitespace.
  String replacePunctuationWithWhiteSpace() =>
      replaceAll(RegExp(EnglishConstants.reSentenceEndingSelector), ' ')
          .replaceAll(RegExp(EnglishConstants.rePunctuationSelector), ' ')
          // replace all brackets and carets with _kTokenDelimiter.
          .replaceAll(RegExp(EnglishConstants.reBracketsAndCarets), ' ')
          // replace all repeated white-space with a single white-space.
          .replaceAll(RegExp(r'(\s{2,})'), ' ');

  /// Split the String at (one or more) white-space characters.
  List<String> splitAtWhiteSpace(Map<String, String> abbreviations) {
    final terms = split(RegExp(r'(\s+)')).map((e) {
      e = e.trim();
      if (abbreviations.keys.contains(e)) {
        return e;
      }
      return e
          .replaceAll(RegExp('${EnglishConstants.reNonWordChars}(?=\$)'), '')
          .trim();
    }).toList(); // convert to list

    terms.removeWhere((element) => element.isEmpty);
    return terms;
  }

  /// Split the String at EnglishConstants.kSentenceDelimiter, trim the elements
  /// and return only non-empty elements.
  List<String> splitAtSentenceDelimiters() {
    // split at EnglishConstants.kSentenceDelimiter
    final sources = split(RegExp(EnglishConstants.kSentenceDelimiter));
    final sentences = <String>[];
    for (final e in sources) {
      // trim leading and trailing white-space from all elements
      final sentence = e
          .trim()
          .replaceAll(RegExp(EnglishConstants.reSentenceEndingSelector), '')
          .trim();
      // add only non-empty sentences
      if (sentence.isNotEmpty) {
        sentences.add(sentence);
      }
    }
    // return the sentences
    return sentences;
  }

  /// Split the String at line endings.
  List<String> splitAtLineEndings() {
    final paragraphs =
        trim().split(RegExp(EnglishConstants.reLineEndingSelector));
    final retVal = <String>[];
    for (final e in paragraphs) {
      final paragraph = e.trim();
      if (paragraph.isNotEmpty) {
        retVal.add(paragraph);
      }
    }
    return retVal;
  }

  /// Insert sentence delimiters into the String at sentence breaks.
  String insertSentenceDelimiters() => trim()
          // replace line feeds and carriage returns with %~%
          .replaceAll(RegExp(EnglishConstants.reSentenceEndingSelector),
              EnglishConstants.kSentenceDelimiter)
          // select all sentences and replace the ending punctuation with %~%
          .replaceAllMapped(RegExp(EnglishConstants.reSentenceEndingSelector),
              (match) {
        final sentence = match.group(0) ?? '';
        // remove white-space before delimiter
        return '$sentence$EnglishConstants.kSentenceDelimiter'.replaceAll(
            RegExp(r'(\s+)(?=%~%)'), EnglishConstants.kSentenceDelimiter);
      });
}
