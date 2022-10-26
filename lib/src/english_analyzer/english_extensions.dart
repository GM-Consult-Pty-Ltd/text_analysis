// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

part of 'english.dart';

/// String extensions used by the [English] text analyzer.
extension EnglishStringExtensions on String {
//

  /// Trims all forms of quotation marks from start and end of String.
  String removeEnclosingQuotes() => replaceAll(
      RegExp(
          '(^${EnglishConstants.rQuotes}+)|(${EnglishConstants.rQuotes}+(?=\$))'),
      '');

  /// Replace all forms of apostrophe or quotation mark with U+0027, then
  /// replace all enclosing single quotes with double quote U+201C
  String normalizeQuotesAndApostrophes() =>
      replaceAll(RegExp(EnglishConstants.rQuotes), "'")
          .replaceAll(RegExp(EnglishConstants.rEnclosingQuotes), '"');

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
  String replacePunctuationWith([String text = ' ']) => trim()
      .normalizeQuotesAndApostrophes()
      // replace all brackets and carets with text.
      .replaceAll(RegExp(EnglishConstants.reLineEndingSelector),
          EnglishConstants.kSentenceDelimiter)
      // replace all brackets and carets with text.
      .replaceAll(RegExp(EnglishConstants.reSentenceEndingSelector), text)
      // replace all brackets and carets with text.
      .replaceAll(RegExp(EnglishConstants.rePunctuationSelector), text)
      // replace all brackets and carets with text.
      .replaceAll(RegExp(EnglishConstants.reBracketsAndCarets), text)
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

  /// Extracts keywords from the text as a list of phrases.
  ///
  /// The text is split at punctuation, line endings and stop-words, resulting
  /// in an ordered collection of term sequences of varying length.
  ///
  /// Each element of the list is an ordered list of terms that make up the
  /// keyword.
  List<List<String>> toKeyWords(
      Map<String, String> abbreviations, Set<String> stopWords,
      [Stemmer? stemmer]) {
    // final phraseTerms = <List<String>>[];
    final retVal = <List<String>>[];
    final phrases = toChunks();
    for (final e in phrases) {
      final phrase = <String>[];
      final terms =
          e.replacePunctuationWith(' ').splitAtWhiteSpace(abbreviations);
      for (var e in terms) {
        e = e.trim().toLowerCase();
        final stem = (stemmer != null ? stemmer(e) : e).trim();
        if (!stopWords.contains(e) &&
            !stopWords.contains(stem) &&
            stem.isNotEmpty) {
          phrase.add(stem);
        } else {
          if (phrase.isNotEmpty) {
            retVal.add(List<String>.from(phrase));
          }
          phrase.clear();
        }
      }
      if (phrase.isNotEmpty) {
        retVal.add(List<String>.from(phrase));
      }
    }

    return retVal;
  }

  /// Splits the String into phrases at phrase delimiters:
  /// - punctuation not part of abbreviations or numbers;
  /// - line endings;
  /// - phrase delimiters such as double quotes, brackets and carets.
  List<String> toChunks() {
    final retVal = <String>[];
    final split =
        trim().split(RegExp(EnglishConstants.rPhraseDelimiterSelector));
    for (final e in split) {
      final phrase = e.replaceAll(RegExp(r'\s+'), ' ').trim();
      if (phrase.isNotEmpty) {
        retVal.add(phrase);
      }
    }
    return retVal;
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

/// English language specific extensions on String collections.
extension EnglishStringCollectionExtension on Iterable<String> {
//

  /// Returns a set of all the unique terms contained in the String collection.
  Set<String> toUniqueTerms(TermSplitter splitter) {
    final retVal = <String>{};
    for (final e in this) {
      retVal.addAll(splitter(e));
    }
    return retVal;
  }
}


