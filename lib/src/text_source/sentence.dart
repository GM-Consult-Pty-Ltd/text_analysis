// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'package:text_analysis/text_analysis.dart';

/// A [Sentence] represents a text [source] not containing sentence ending
/// punctuation such as periods, question-marks and exclamations, except where
/// used in tokens, identifiers or other terms.
///
/// In addition to the [source] text, the [Sentence] object also enumerates
/// its [tokens].
abstract class Sentence {
  //

  /// Factory constructor instantiates a [Sentence] from [source] and [tokens].
  factory Sentence(source, List<Token> tokens) => _SentenceImpl(source, tokens);

  /// The source text of the [Sentence].
  String get source;

  /// All the tokens in the [Sentence].
  List<Token> get tokens;
}

/// Implementation class for [Sentence].
class _SentenceImpl implements Sentence {
//

  /// Instantiates a const [_SentenceImpl]
  const _SentenceImpl(this.source, this.tokens);

  @override
  final String source;

  @override
  final List<Token> tokens;
}
