// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

import 'package:porter_2_stemmer/porter_2_stemmer.dart';
import 'package:porter_2_stemmer/extensions.dart';
import 'package:text_analysis/extensions.dart';
import 'package:text_analysis/text_analysis.dart';
import 'package:text_analysis/type_definitions.dart';

part 'mixins/_character_filter.dart';
part 'mixins/_keyword_extractor.dart';
part 'mixins/_n_grammer.dart';
part 'mixins/_paragraph_splitter.dart';
part 'mixins/_syllable_counter.dart';
part 'mixins/_syllable_stemmer.dart';
part 'mixins/_term_filter.dart';
part 'mixins/_term_splitter.dart';
part 'mixins/_tokenizer.dart';
part 'mixins/_sentence_splitter.dart';

/// A [TextAnalyzer] implementation for Latin languages analysis.
///
/// Exposes a const default generative constructor.
abstract class LatinLanguageAnalyzer
    with
        _CharacterFilter,
        _NGrammer,
        _ParagraphSplitter,
        _SyllableCounter,
        _SentenceSplitter,
        _TermFilter,
        _TermSplitter,
        _Tokenizer,
        _KeyWordExtractor
    implements TextAnalyzer {
  /// Initializes a const [LatinLanguageAnalyzer].
  const LatinLanguageAnalyzer();

  @override
  CharacterFilter get characterFilter => _filterCharacters;

  @override
  JsonTokenizer get jsonTokenizer => _tokenizeJson;

  @override
  NGrammer get nGrammer => _toNGrams;

  @override
  ParagraphSplitter get paragraphSplitter => _splitToParagraphs;

  @override
  SentenceSplitter get sentenceSplitter => _splitToSentences;

  @override
  SyllableCounter get syllableCounter => _countSyllables;

  @override
  TermFilter get termFilter => _filterTerms;

  @override
  TermSplitter get termSplitter => _splitToTerms;

  @override
  Tokenizer get tokenizer => _tokenize;

  @override
  KeywordExtractor get keywordExtractor => _extractKeywords;

  /// The delimiter inserted at sentence endings to allow splitting of the text
  /// into sentences.
  static const kSentenceDelimiter = r'%~%';

  /// Selector for all single or double quotation marks and apostrophes.
  static const rQuotes = '[\'"“”„‟’‘‛]';

  /// Selects the end of a string.
  static const rEndString = r'\Z';

  /// Selector for enclosing quote marks.
  static const rEnclosingQuotes =
      '(?<=^|$reNonWordChars)$rQuotes+|$rQuotes+(?=$rEndString|$reNonWordChars)';

  /// Matches all brackets and carets.
  static const reBracketsAndCarets = r'[\[\]\(\)\{\}\<\>]';

  /// Matches al characters except:
  ///   - numbers 0-9;
  ///   - letters a-z;
  ///   - letters A-Z;
  ///   - ampersand, apostrophe, underscore and hyhpen ("&", "'", "_", "-")
  static const reNonWordChars = r"[^a-zA-Z0-9À-öø-ÿ¥Œ€@™#-\&_'-]";

  /// Matches characters used to write words, including:
  ///   - numbers 0-9;
  ///   - letters a-z;
  ///   - letters A-Z;
  ///   - ampersand, apostrophe, underscore and hyhpen ("&", "'", "_", "-")
  static const reWordChars = r"[a-zA-Z0-9À-öø-ÿ¥Œ€@™#-\&_'-]";

  /// Matches all line endings.
  static const reLineEndingSelector = '[\u000A\u000B\u000C\u000D]+';

  /// Matches strings where text is split for keywording:
  /// - all line endings
  /// - all punctuation
  /// - all numbers, including currency amounts and percentages
  static const rPhraseDelimiterSelector = '$reLineEndingSelector|'
      '$rePunctuationSelector|'
      '$reBracketsAndCarets+|'
      '$rQuotes+|'
      '$reNumbersAndAmounts';

  static const reNumbers = r'(\d|((?<=\d)[,.]{1}))+';

  static const reNumbersAndAmounts = r'([^\w,.]?|[A-Z]{3})\s?'
      '$reNumbers'
      r'[\s]?(([^\w,.]?)|[A-Z]{3})'; // suffix

  /// Matches all sentence endings.
  static const reSentenceEndingSelector =
      '(?<=$reWordChars|\\s)(\\. )(?=([^a-z])|\\s+|\$)|(\\.)(?=\$)|'
      '(?<=[^([{])([?!])(?=([^)]}])|\\s+|\$)';

  /// Matches all mid-sentence punctuation.
  static const rePunctuationSelector =
      r"[\!:;,\-—.]+(?=[^a-zA-Z0-9À-öø-ÿ¥Œ€@™#-\&_\'-]|$)";

}
