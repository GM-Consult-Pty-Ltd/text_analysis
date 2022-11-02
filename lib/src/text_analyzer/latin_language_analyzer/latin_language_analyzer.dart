// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

import 'package:text_analysis/type_definitions.dart';
import 'package:text_analysis/text_analysis.dart';
import 'package:text_analysis/extensions.dart';
import 'package:porter_2_stemmer/porter_2_stemmer.dart';
import 'package:porter_2_stemmer/extensions.dart';

part 'latin_language_constants.dart';
part 'latin_language_extensions.dart';
// part 'english_extensions.dart';
part 'syllable_stemmer.dart';

/// A [TextAnalyzer] implementation for [LatinLanguageAnalyzerMixin] language analysis.
abstract class LatinLanguageAnalyzerMixin implements TextAnalyzer {
  //

  @override
  TermFilter get termFilter => (Term term) => term.versions(
      abbreviations, stopWords, termExceptions, characterFilter, stemmer);
  // {
  //       // remove white-space from start and end of term
  //       term = term.trim();
  //       final Set<String> retVal = {};
  //       if (term.isNotEmpty && !stopWords.contains(term)) {
  //         // exclude empty terms and that are stopwords
  //         final exception = termExceptions[term]?.trim();
  //         if (abbreviations.keys.contains(term)) {
  //           // return the abbreviation and a version with no punctuation.
  //           retVal.addAll({term, term.replaceAll('.', '').trim()});
  //         } else if (exception != null) {
  //           retVal.add(exception);
  //         } else {
  //           final terms = <List<String>>{};
  //           // Cleans the term as follows:
  //           // - change all quote marks to single apostrophe +U0027;
  //           // - remove enclosing quote marks;
  //           // - change all dashes to single standard hyphen;
  //           // - remove all characters except letters and numbers at end of term
  //           term = characterFilter(term);
  //           // check the resulting term is longer than 1 characters and not
  //           // contained in [stopWords]
  //           if (!stopWords.contains(term) && term.length > 1) {
  //             // - insert [term] in the return value
  //             terms.add([term]);
  //             // insert a version without hyphens
  //             terms.add([term.replaceAll(RegExp(r'[-]'), '').trim()]);
  //             // insert a version with hyphens replaced by spaces
  //             terms.add(term.split(RegExp(r'[\-]')));
  //             // split at all non-word characters unless preceded and ended by a number.
  //             final splitTerms = term
  //                 .split(RegExp(
  //                     r'(?<=[^0-9\b])[^a-zA-Z0-9À-öø-ÿ]+|[^a-zA-Z0-9À-öø-ÿ\-]+(?=[^0-9\b])'))
  //                 .map((e) => termExceptions[e.trim()]?.trim() ?? e.trim())
  //                 .toList()
  //                 .where((element) {
  //               element = element.trim();
  //               return element.length > 1 && !stopWords.contains(element);
  //             }).toList();
  //             terms.add(splitTerms);
  //           }
  //           for (final e in terms) {
  //             final element = <String>[];
  //             for (var term in e) {
  //               term = stemmer(term.trim()).trim();
  //               if (term.isNotEmpty) {
  //                 element.add(term);
  //               }
  //             }
  //             if (element.isNotEmpty) {
  //               var value = element.join(' ');
  //               value = (termExceptions[value] ?? value).trim();
  //               if (value.isNotEmpty) {
  //                 retVal.add(element.join(' '));
  //               }
  //             }
  //           }
  //         }
  //       }
  //       retVal.removeWhere((e) => e.trim().isEmpty);
  //       return retVal;
  //     };

  /// The [LatinLanguageAnalyzerMixin] implementation of the [characterFilter] function:
  /// - returns the term if it can be parsed as a number; else
  /// - converts the term to lower-case;
  /// - changes all quote marks to single apostrophe +U0027;
  /// - removes enclosing quote marks;
  /// - changes all dashes to single standard hyphen;
  /// - removes all non-word characters from the term;
  /// - replaces all characters except letters and numbers from the end of
  ///   the term.
  @override
  CharacterFilter get characterFilter => (Term term) => term.toWord();

  /// The [LatinLanguageAnalyzerMixin] implementation of [termSplitter].
  ///
  /// Algorithm:
  /// - Replace all punctuation, brackets and carets with white_space.
  /// - Split into terms at any sequence of white-space characters.
  /// - Trim leading and trailing white-space from all terms.
  /// - Trim any non=word characters from the end of all terms, unless it
  ///   matches any of the abbreviations.
  /// - Return only non-empty terms.
  @override
  TermSplitter get termSplitter => (SourceText source) =>
      source.replacePunctuationWith(' ').splitAtWhiteSpace();

  /// The [LatinLanguageAnalyzerMixin] implementation of [sentenceSplitter].
  ///
  /// Algorithm:
  /// - Insert a delimiter at sentence breaks.
  /// - Split the text into sentences at the delimiter.
  /// - Trim leading and trailing white-space from all terms.
  /// - Return only non-empty elements.
  @override
  SentenceSplitter get sentenceSplitter => (SourceText source) =>
      source.insertSentenceDelimiters().splitAtSentenceDelimiters();

  /// The [LatinLanguageAnalyzerMixin] implementation of [paragraphSplitter].
  ///
  /// Algorithm:
  /// - Split the text at line endings.
  /// - Trim leading and trailing white-space from all terms.
  /// - Return only non-empty elements.
  @override
  ParagraphSplitter get paragraphSplitter =>
      (source) => source.splitAtLineEndings();

  /// The [LatinLanguageAnalyzerMixin] implementation of [syllableCounter].
  ///
  /// Algorithm:
  /// - Trim leading and trailing white-space from term.
  /// - Return 0 if resulting term is empty.
  /// - Split the term using the [termSplitter]
  @override
  SyllableCounter get syllableCounter => (term) => term.syllableCount;

  @override
  NGrammer get nGrammer => (String text, NGramRange range) {
        // perform the punctuation and white-space split
        final terms = termSplitter(text.trim());
        return terms.nGrams(range);
      };

  @override
  KeywordExtractor get keywordExtractor =>
      (String source, {NGramRange? nGramRange}) => source.toKeyWords(
          termExceptions, stopWords,
          stemmer: stemmer, range: nGramRange);
}
