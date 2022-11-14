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
  //

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

  @override
  TermFlag get isStopWord =>
      (term) => LatinLanguageAnalyzer.isNumberOrAmount(term) || term.length < 2;

  /// Returns true if the String starts with "@" or "#" followed by one or more
  /// word-chacters only.
  static bool isHashtag(String term) =>
      RegExp(rHashtag).allMatches(term.trim()).length == 1;

  /// Returns true if the String contains digits and delimiters (periods or
  /// commas) where delimiters are not at the start or end of the String.
  static bool isNumber(String term) =>
      RegExp(rNumber).allMatches(term.trim()).length == 1;

  /// Returns true if the String contains digits and delimiters (periods or
  /// commas) where delimiters are not at the start or end of the String.
  ///
  /// Includes numbers with pre-fixes or suffixes
  static bool isNumberOrAmount(String term) =>
      RegExp(rNumbersAndAmounts).allMatches(term.trim()).length == 1;

  /// Replaces all hyphenations with [replace].
  ///
  /// A hypenation is a single dash character preceded and followed by a word
  /// boundary.
  static String replaceHyphens(String term, [String replace = ' ']) =>
      term.replaceAll(RegExp(kHypenations), replace);

  /// Returns true if the [term] contains one or more hyphens.
  ///
  /// A hypenation is a single dash character preceded and followed by a word
  /// boundary.
  static bool isHyphenated(String term) =>
      RegExp(kHypenations).allMatches(term).isNotEmpty;

  /// Selector for single hyphen characters preceded and followed by a word
  /// boundary.
  static const kHypenations = r'(?<=\b)-{1}(?=\b)';

  /// The delimiter inserted at sentence endings to allow splitting of the text
  /// into sentences.
  static const kSentenceDelimiter = r'%~%';

  /// Selects text that starts with "@" or "#" and is preceded or followed by
  /// non-word characters or the start/end of the String.
  static const rHashtags = r'(?<=^|\W)[#@]{1}(\w)+(?=\W|$)';

  /// Selects text that starts with "@" or "#" followed by one or more
  /// word-chacters only.
  static const rHashtag = r'(?<=^)[#@]{1}(\w)+(?=$)';

  /// Selector for all single or double quotation marks and apostrophes.
  static const rQuotes = '[\'"“”„‟’‘‛]';

  /// Selects the end of a string.
  static const rEndString = r'\Z';

  /// Selector for enclosing quote marks.
  static const rEnclosingQuotes =
      '(?<=^|$rNonWordChars)$rQuotes+|$rQuotes+(?=$rEndString|$rNonWordChars)';

  /// Matches all brackets and carets.
  static const rBracketsAndCarets = r'[\[\]\(\)\{\}\<\>]';

  /// Matches al characters except:
  ///   - numbers 0-9;
  ///   - letters a-z;
  ///   - letters A-Z;
  ///   - ampersand, apostrophe, underscore and hyhpen ("&", "'", "_", "-")
  static const rNonWordChars = r"[^a-zA-Z0-9À-öø-ÿ¥Œ€@™#-\&_'-]";

  /// Matches characters used to write words, including:
  ///   - numbers 0-9;
  ///   - letters a-z;
  ///   - letters A-Z;
  ///   - ampersand, apostrophe, underscore and hyhpen ("&", "'", "_", "-")
  static const rWordChars = r"[a-zA-Z0-9À-öø-ÿ¥Œ€@™#-\&_'-]";

  /// Matches all line endings.
  static const rLineEndingSelector = '[\u000A\u000B\u000C\u000D]+';

  /// Matches strings where text is split for keywording:
  /// - all line endings
  /// - all punctuation
  /// - all numbers, including currency amounts and percentages
  static const rPhraseDelimiterSelector = '$rLineEndingSelector|'
      '$rPunctuationSelector|'
      '$rBracketsAndCarets+|'
      '"+';

  /// Matches all numbers, including those delimited with periods and or commas.
  static const rNumbers = r'(?<=^|\W)(\d|((?<=\d)[,.]{1}(?=\d)))+(?=$|\W)';

  /// Matches a String that includes digits and delimiters (periods and commas)
  /// where delimiters are not at the start or end of the string
  static const rNumber = r'(?<=^)(\d|((?<=\d)[,.]{1}(?=\d)))+(?=$)';

  /// Matches all numbers and amounts, including:
  /// - numbers delimited with periods and or commas;
  /// - single non-word currency symbol ($€£¥₣₹ك]) prefixes;
  /// - any three-letter upper-case pre-fixes e.g. "USD" or "GBP"
  /// - a single "%" suffix; and
  /// - three-letter currency identifiers in any combination of upper-case
  ///   letters.
  static const rNumbersAndAmounts = r'(?<=^|\s)([$€£¥₣₹ك]{1}|[A-Z]{3})?(\d+|'
      r'((?<=\d)[,.]{1}(?=\d)))+([%]{1})?(?=$|\W)';

  /// Matches all sentence endings.
  static const rSentenceEndingSelector =
      '(?<=$rWordChars|\\s)(\\. )(?=([^a-z])|\\s+|\$)|(\\.)(?=\$)|'
      '(?<=[^([{])([?!])(?=([^)]}])|\\s+|\$)';

  /// Matches all punctuation. Excludes periods followed by word characters or
  /// lower-case text (even if separated by white-space) to avoid selecting
  /// periods in abbreviations.
  static const rPunctuationSelector =
      r"[\!:;,\-—]+(?=[^a-zA-Z0-9À-öø-ÿ¥Œ€@™#-\&_\'-]|$)|[.](?=$|[^,.!:"
      '"'
      r"'[\]{}();a-zA-Z0-9\s]|\s[A-Z0-9])";
}
