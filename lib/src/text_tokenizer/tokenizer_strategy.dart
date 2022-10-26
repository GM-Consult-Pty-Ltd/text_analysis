// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd

import 'package:text_analysis/src/text_tokenizer/_index.dart';

/// The strategy to apply when splitting text to [Token]s.
enum TokenizingStrategy {
  //

  /// Split the text at all white-space and punctuation and remove stop-words.
  ///
  /// Build n-grams to match [NGramRange] from any sequence of terms.
  terms,

  /// Split the text at punctuation, line endings and stopwords, returning
  /// a token for each keyword.
  keyWords
}
