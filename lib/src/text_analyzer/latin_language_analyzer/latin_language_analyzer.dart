// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

import 'package:text_analysis/type_definitions.dart';
import 'package:text_analysis/text_analysis.dart';
import 'package:text_analysis/extensions.dart';
import 'package:porter_2_stemmer/porter_2_stemmer.dart';
import 'package:porter_2_stemmer/extensions.dart';

part '_constants.dart';
part '_extensions.dart';
part '_keyword_extractor.dart';
part '_tokenizer.dart';
part 'syllable_stemmer.dart';

/// A [TextAnalyzer] implementation for Latin languages analysis.
///
/// Mixes in [LatinLanguageAnalyzerMixin] and exposes a const default
/// generative constructor.
abstract class LatinLanguageAnalyzer
    with _TokenizerMixin, LatinLanguageAnalyzerMixin {
  /// Initializes a const [LatinLanguageAnalyzer].
  const LatinLanguageAnalyzer();
}

/// A [TextAnalyzer] implementation mixin for Latin languages analysis.
abstract class LatinLanguageAnalyzerMixin implements TextAnalyzer {
  //

  @override
  TermFilter get termFilter =>
      (Term term) => term.versions(abbreviations, stopWords, termExceptions);

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
          stemmer: stemmer,
          range: nGramRange,
          characterFilter: characterFilter);
}
