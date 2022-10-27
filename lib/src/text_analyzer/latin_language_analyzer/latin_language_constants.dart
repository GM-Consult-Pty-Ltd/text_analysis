// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

part of 'latin_language_analyzer.dart';

/// Constants used by the [LatinLanguageAnalyzer]text analyzer.
abstract class _LatinLanguageConstants {
  //

  /// The delimiter inserted at sentence endings to allow splitting of the text
  /// into sentences.
  static const kSentenceDelimiter = r'%~%';

  /// Selector for all single or double quotation marks and apostrophes.
  static const rQuotes = '[\'"“”„‟’‘‛]';

  /// Selects the end of a string.
  static const rEndString = r'\Z';

  /// Selector for enclosing  quotes
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

  ///
  static const rPhraseDelimiterSelector =
      '$rePunctuationSelector|$reBracketsAndCarets+|"+';

  /// Matches all sentence endings.
  static const reSentenceEndingSelector =
      '(?<=$reWordChars|\\s)(\\. )(?=([^a-z])|\\s+|\$)|(\\.)(?=\$)|'
      '(?<=[^([{])([?!])(?=([^)]}])|\\s+|\$)';

  /// Matches all mid-sentence punctuation.
  static const rePunctuationSelector =
      r"[\!:;,\-—.]+(?=[^a-zA-Z0-9À-öø-ÿ¥Œ€@™#-\&_\'-]|$)";
}
