// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

import 'package:porter_2_stemmer/constants.dart';

import '../_index.dart';
part 'english_constants.dart';
part 'english_extensions.dart';
part 'syllable_stemmer.dart';

/// A [TextAnalyzer] implementation for [English] language analysis.
class English implements TextAnalyzer {
  //

  /// A const constructor to allow an instance to be used as default.
  ///
  /// [termExceptions] is a hashmap of words to token terms for special words
  /// that should not be re-capitalized, stemmed or lemmatized. The default
  /// [termExceptions] is an empty ```dart const <String, String>{}```.
  const English({this.termExceptions = const <String, String>{}});

  /// Instantiates a static const [English] instance.
  static const analyzer = English();

  @override
  Stemmer get stemmer => EnglishConstants.kStemmer;

  @override
  Lemmatizer get lemmatizer => EnglishConstants.kLemmatizer;

  /// Stopwords are terms that commonly occur in a language and that do not add
  /// material value to the analysis of text.
  Iterable<String> get stopWords => EnglishConstants.kStopWords;

  /// A hashmap of abbreviations in the analyzed language.
  Map<String, String> get abbreviations => EnglishConstants.kAbbreviations;

  /// A hashmap of words to token terms for special words that should not be
  /// re-capitalized, stemmed or lemmatized.
  @override
  final Map<String, String> termExceptions;

  @override
  TermFilter get termFilter => (Term term) async {
        // remove white-space from start and end of term
        term = term.trim();
        final terms = <String>{};
        // exclude empty terms and that are stopwords
        var exception = termExceptions[term]?.trim();
        if (term.isNotEmpty && !stopWords.contains(term)) {
          if (abbreviations.keys.contains(term)) {
            // return the abbreviation and a version with no punctuation.
            terms.addAll({term, term.replaceAll('.', '').trim()});
          } else if (exception != null) {
            terms.add(exception);
          } else {
            {
              // Cleans the term as follows:
              // - change all quote marks to single apostrophe +U0027;
              // - remove enclosing quote marks;
              // - change all dashes to single standard hyphen;
              // - remove all characters except letters and numbers at end of term
              term = characterFilter(term);
              // check the resulting term is longer than 1 characters and not
              // contained in [stopWords]
              if (!stopWords.contains(term) && term.length > 1) {
                // - insert [term] in the return value
                terms.add(term);
                // insert a version without apostrophes and/or hyphens
                final unHyphenated =
                    term.replaceAll(RegExp(r"['\-]"), '').trim();
                terms.add(unHyphenated);
                // split at all non-word characters unless preceded and ended by a number.
                final splitTerms = term.split(RegExp(
                    r'(?<=[^0-9\b])[^a-zA-Z0-9À-öø-ÿ]+|[^a-zA-Z0-9À-öø-ÿ]+(?=[^0-9\b])'));
                for (var splitTerm in splitTerms) {
                  exception = termExceptions[splitTerm.trim()]?.trim();
                  // var tokenTerm = splitTerm;
                  if (exception != null) {
                    // add the exception
                    terms.add(exception);
                  } else if (splitTerm.isNotEmpty) {
                    if (!stopWords.contains(splitTerm) &&
                        splitTerm.length > 1) {
                      // only add terms longer than 1 character to exclude possesives etc.
                      terms.add(splitTerm);
                    }
                  }
                }
              }
            }
          }
        }
        final retVal = (terms.map((e) {
          final exception = termExceptions[e];
          if (exception != null) {
            return exception;
          }
          final stemmedTerm = stemmer(lemmatizer(e.trim())).trim();
          return termExceptions[stemmedTerm] ?? stemmedTerm;
        }).toSet());
        retVal.removeWhere((e) => e.isEmpty);
        return retVal;
      };

  /// The [English] implementation of the [characterFilter] function:
  /// - returns the term if it can be parsed as a number; else
  /// - converts the term to lower-case;
  /// - changes all quote marks to single apostrophe +U0027;
  /// - removes enclosing quote marks;
  /// - changes all dashes to single standard hyphen;
  /// - removes all non-word characters from the term;
  /// - replaces all characters except letters and numbers from the end of
  ///   the term.
  @override
  CharacterFilter get characterFilter => (Term term) {
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
                .replaceAll(RegExp(EnglishConstants.reNonWordChars), '')
                // remove all characters except letters and numbers at end
                // of term
                .replaceAll(RegExp(r'[^a-zA-Z0-9À-öø-ÿ](?=$)'), '')
                .trim();
      };

  /// The [English] implementation of [termSplitter].
  ///
  /// Algorithm:
  /// - Replace all punctuation, brackets and carets with white_space.
  /// - Split into terms at any sequence of white-space characters.
  /// - Trim leading and trailing white-space from all terms.
  /// - Trim any non=word characters from the end of all terms, unless it
  ///   matches any of the abbreviations.
  /// - Return only non-empty terms.
  @override
  TermSplitter get termSplitter => (SourceText source) => source
      .replacePunctuationWithWhiteSpace()
      .splitAtWhiteSpace(abbreviations);

  /// The [English] implementation of [sentenceSplitter].
  ///
  /// Algorithm:
  /// - Insert a delimiter at sentence breaks.
  /// - Split the text into sentences at the delimiter.
  /// - Trim leading and trailing white-space from all terms.
  /// - Return only non-empty elements.
  @override
  SentenceSplitter get sentenceSplitter => (SourceText source) =>
      source.insertSentenceDelimiters().splitAtSentenceDelimiters();

  /// The [English] implementation of [paragraphSplitter].
  ///
  /// Algorithm:
  /// - Split the text at line endings.
  /// - Trim leading and trailing white-space from all terms.
  /// - Return only non-empty elements.
  @override
  ParagraphSplitter get paragraphSplitter =>
      (source) => source.splitAtLineEndings();

  /// The [English] implementation of [syllableCounter].
  ///
  /// Algorithm:
  /// - Trim leading and trailing white-space from term.
  /// - Return 0 if resulting term is empty.
  /// - Split the term using the [termSplitter]
  @override
  SyllableCounter get syllableCounter => (term) {
        term = term.trim();
        // return 0 if term is empty
        if (term.isEmpty) return 0;
        // return 1 if term length is less than 3
        if (term.length < 3) {
          return 1;
        } else {
          // initialize the return value
          var count = 0;
          // split term into terms at non-word characters
          final terms =
              term.split(RegExp(Porter2StemmerConstants.rEnglishNonWordChars));
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
      };

  @override
  NGrammer get nGrammer => (String text, NGramRange range) {
        // perform the punctuation and white-space split
        final terms = analyzer.termSplitter(text.trim());
        return terms.nGrams(range);
      };
}
