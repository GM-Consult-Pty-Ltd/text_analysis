// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

part of 'latin_language_analyzer.dart';

/// String extensions used by the [LatinLanguageAnalyzer]text analyzer.
extension _LatinLanguageStringExtensions on String {
//

  /// Returns one or more versions of the String as follows:
  /// - returns an empty set if the String is empty or in [stopWords];
  /// - looks up the text in [termExceptions] and returns the value if the
  ///   key exists;
  /// - looks up the term in [abbreviations] and, if found, returns both the
  ///   abbreviation and a version with no punctuation;
  /// - applies [characterFilter] to the term and checks it again for matches in
  ///   [stopWords] and [termExceptions];
  /// - adds the resulting term if it is longer than 1;
  /// - add an un-hyphenated version if the term contains hyphens;
  /// - add a version with spaces in the place of hyphens;
  /// - split the term at all other non-word characters and check the elements
  ///   against [stopWords] and [termExceptions];
  /// - apply the [stemmer] to all words;
  Set<String> versions(
      Map<String, String> abbreviations,
      Set<String> stopWords,
      Map<String, String> termExceptions,
      CharacterFilter characterFilter,
      Stemmer stemmer) {
    // remove white-space from start and end of term
    var term = trim();
    final Set<String> retVal = {};
    if (term.isNotEmpty && !stopWords.contains(term)) {
      // exclude empty terms and that are stopwords
      final exception = termExceptions[term]?.trim();
      final abbreviation = abbreviations[term];
      if (abbreviation != null) {
        // return the abbreviation and a version with no punctuation.
        retVal.addAll({term, abbreviation, term.replaceAll('.', '').trim()});
      } else if (exception != null) {
        retVal.add(exception);
      } else {
        final terms = <List<String>>{};
        // apply the character filter
        term = characterFilter(term);
        // check the resulting term is longer than 1 characters and not
        // contained in [stopWords]
        if (!stopWords.contains(term) && term.length > 1) {
          terms.addAll([
            // - insert [term] in the return value
            [term],
            // insert a version without hyphens
            [term.replaceAll(RegExp(r'[-]'), '').trim()],
            // insert a version split at hyphens
            term.split(RegExp(r'[\-]'))
          ]);

          final splitTerms = term
              .split(RegExp(
                  r'(?<=[^0-9\b])[^a-zA-Z0-9À-öø-ÿ]+|[^a-zA-Z0-9À-öø-ÿ\-]+(?=[^0-9\b])'))
              .map((e) => termExceptions[e.trim()]?.trim() ?? e.trim())
              .toList()
              .where((element) {
            element = element.trim();
            return element.length > 1 && !stopWords.contains(element);
          }).toList();
          terms.add(splitTerms);
        }
        for (final e in terms) {
          final element = <String>[];
          for (var term in e) {
            term = (termExceptions[term.trim()] ?? stemmer(term.trim())).trim();
            if (term.isNotEmpty) {
              element.add(term);
            }
          }
          if (element.isNotEmpty) {
            var value = element.join(' ');
            value = (termExceptions[value] ?? value).trim();
            if (value.isNotEmpty) {
              retVal.add(element.join(' '));
            }
          }
        }
      }
    }
    retVal.removeWhere((e) => e.trim().isEmpty);
    return retVal;
  }

  /// Converts the String to a word, removing all non-word characters:
  /// - returns the term if it can be parsed as a number; else
  /// - converts the term to lower-case;
  /// - changes all quote marks to single apostrophe +U0027;
  /// - removes enclosing quote marks;
  /// - changes all dashes to single standard hyphen;
  /// - removes all non-word characters from the term;
  /// - replaces all characters except letters and numbers from the end of
  ///   the term.
  String toWord() {
    final term = this;
    // try parsing the term to a number
    final number = num.tryParse(term);
    // return the term if it can be parsed as a number
    return number != null
        // return number.toString() if number is not null.
        ? number.toString()
        // if the term is all-caps return it unchanged.
        : term
            // convert to lower-case
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

  /// Returns the syllable count for the String.
  int get syllableCount {
    final term = trim();
    // return 0 if term is empty
    if (term.isEmpty) return 0;
    // return 1 if term length is less than 3
    if (term.length < 3) {
      return 1;
    } else {
      // initialize the return value
      var count = 0;
      // split term into terms at non-word characters
      final terms = term.split(RegExp(_LatinLanguageConstants.reNonWordChars));
      for (var e in terms) {
        // stem the remaining term with the SyllableStemmer.
        // DO NOT USE the analyzer stemmer as it may be overridden and we
        // must make sure the trailing silent e's are removed and vowel "y"s
        // are converted to "i"
        e = SyllableStemmer().stem(e);
        // count apostropied syllables like "d'Azure" and remove the
        // apostrophied prefix
        e = e.replaceAllMapped(RegExp(r"(?<=\b)([a-zA-Z]')"), (match) {
          count++;
          return '';
        });
        // check for terms with capitals or remaining punctuation
        if (e.toUpperCase() == e) {
          // this is more than likely an acronym, so add 1
          count++;
        } else {
          // add all the single vowels, diphtongs and triptongs.
          // As e has been stemmed by the Porter2 stemmer, we know trailing
          // silent e's have been removed and vowel "y"s converted to "i"
          e = e.toLowerCase();
          if (e.contains(RegExp(r"[^aeiou\s\-\']+(?=\b)"))) {
            // term ends in one or more consonants or ys
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
      // if count is 0, return 1 because a word must have at least one syllable
      return count < 1 ? 1 : count;
    }
  }

  /// Replace all forms of apostrophe or quotation mark with U+0027, then
  /// replace all enclosing single quotes with double quote U+201C
  String normalizeQuotesAndApostrophes() =>
      replaceAll(RegExp(_LatinLanguageConstants.rQuotes), "'")
          .replaceAll(RegExp(_LatinLanguageConstants.rEnclosingQuotes), '"');

  /// Replace all punctuation in the String with whitespace.
  String replacePunctuationWith([String text = ' ']) => trim()
      .normalizeQuotesAndApostrophes()
      // replace all brackets and carets with text.
      .replaceAll(RegExp(_LatinLanguageConstants.reLineEndingSelector), text)
      // replace all brackets and carets with text.
      .replaceAll(
          RegExp(_LatinLanguageConstants.reSentenceEndingSelector), text)
      // replace all brackets and carets with text.
      .replaceAll(RegExp(_LatinLanguageConstants.rePunctuationSelector), text)
      // replace all brackets and carets with text.
      .replaceAll(RegExp(_LatinLanguageConstants.reBracketsAndCarets), text)
      // replace all repeated white-space with a single white-space.
      .replaceAll(RegExp(r'(\s{2,})'), ' ');

  /// Split the String at (one or more) white-space characters.
  List<String> splitAtWhiteSpace() {
    final terms = split(RegExp(r'(\s+)')).map((e) {
      e = e.trim();
      return e
          .replaceAll(
              RegExp('${_LatinLanguageConstants.reNonWordChars}(?=\$)'), '')
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
      Map<String, String> exceptions, Set<String> stopWords,
      {Stemmer? stemmer, NGramRange? range}) {
    // final phraseTerms = <List<String>>[];
    final retVal = <List<String>>[];
    final keyWordSet = <String>{};
    final phrases = toChunks();
    for (final e in phrases) {
      final phrase = <String>[];
      final terms = e.replacePunctuationWith(' ').splitAtWhiteSpace();
      for (var e in terms) {
        e = e.trim();
        if (e.length > 1) {
          final exception = exceptions[e];
          final alt = exceptions[e];
          if (exception != null) {
            final words = exception.split(' ');
            words.removeWhere((element) => stopWords.contains(element));
            e = words.join(' ').toLowerCase();
          } else {
            e = e.toLowerCase();
            e = (stemmer != null ? stemmer(e) : e).trim();

            e = alt ?? e;
          }
          if (!stopWords.contains(e) && e.isNotEmpty) {
            phrase.add(e);
          } else {
            _addPhraseToKeyWords(phrase, keyWordSet, retVal, range);
            phrase.clear();
          }
        }
      }
      _addPhraseToKeyWords(phrase, keyWordSet, retVal, range);
    }

    return retVal;
  }

  /// Worker method for toKeywords extension method.
  static void _addPhraseToKeyWords(List<String> phrase, Set<String> keyWordSet,
      List<List<String>> retVal, NGramRange? range) {
    final keyWord = phrase.join(' ').toLowerCase();
    if (phrase.isNotEmpty) {
      if (!keyWordSet.contains(keyWord)) {
        retVal.add(List<String>.from(phrase));
        keyWordSet.add(keyWord);
        if (range != null) {
          final nGrams = phrase.nGrams(range).map((e) => e.split(' '));
          for (var nGram in nGrams) {
            final keyWord = nGram.join(' ');
            if (!keyWordSet.contains(keyWord)) {
              if (nGram.length != phrase.length) {
                retVal.add(nGram);
                keyWordSet.add(keyWord);
              }
            }
          }
        }
      }
    }
  }

  /// Splits the String into phrases at phrase delimiters:
  /// - punctuation not part of abbreviations or numbers;
  /// - line endings;
  /// - phrase delimiters such as double quotes, brackets and carets.
  List<String> toChunks() {
    final retVal = <String>[];
    final split =
        trim().split(RegExp(_LatinLanguageConstants.rPhraseDelimiterSelector));
    for (final e in split) {
      final phrase = e.replaceAll(RegExp(r'\s+'), ' ').trim();
      if (phrase.isNotEmpty) {
        retVal.add(phrase);
      }
    }
    return retVal;
  }

  /// Split the String at _LatinLanguageConstants.kSentenceDelimiter, trim the elements
  /// and return only non-empty elements.
  List<String> splitAtSentenceDelimiters() {
    // split at _LatinLanguageConstants.kSentenceDelimiter
    final sources = split(RegExp(_LatinLanguageConstants.kSentenceDelimiter));
    final sentences = <String>[];
    for (final e in sources) {
      // trim leading and trailing white-space from all elements
      final sentence = e
          .trim()
          .replaceAll(
              RegExp(_LatinLanguageConstants.reSentenceEndingSelector), '')
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
        trim().split(RegExp(_LatinLanguageConstants.reLineEndingSelector));
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
          .replaceAll(RegExp(_LatinLanguageConstants.reSentenceEndingSelector),
              _LatinLanguageConstants.kSentenceDelimiter)
          // select all sentences and replace the ending punctuation with %~%
          .replaceAllMapped(
              RegExp(_LatinLanguageConstants.reSentenceEndingSelector),
              (match) {
        final sentence = match.group(0) ?? '';
        // remove white-space before delimiter
        return '$sentence$_LatinLanguageConstants.kSentenceDelimiter'
            .replaceAll(RegExp(r'(\s+)(?=%~%)'),
                _LatinLanguageConstants.kSentenceDelimiter);
      });
}

/// LatinLanguage language specific extensions on String collections.
extension LatinLanguageStringCollectionExtension on Iterable<String> {
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
