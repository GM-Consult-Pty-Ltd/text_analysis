// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'package:text_analysis/text_analysis.dart';

/// A [Sentence] represents a text [source] not containing sentence ending
/// punctuation such as periods, question-marks and exclamations, except where
/// used in tokens, identifiers or other terms.
///
/// In addition to the [source] text, the [Sentence] object also enumerates
/// its [tokens].
class Sentence {
  //

  /// Instantiates a [Sentence] from [source] and [tokens].
  const Sentence(this.source, this.tokens);

  /// The source text of the [Sentence].
  final String source;

  /// All the tokens in the [Sentence].
  final List<Token> tokens;
}
