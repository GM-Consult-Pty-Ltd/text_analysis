// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'package:text_analysis/text_analysis.dart';

/// A [TextSource] represents a text [source] that has been analyzed to
/// enumerate its [sentences] and [tokens].
abstract class TextSource {
  //

  /// Instantiates a [Document] from the [source].
  factory TextSource(String source, List<Sentence> sentences) =>
      _TextSourceImpl(source, sentences);

  /// The source text for the document.
  String get source;

  /// The collection of sentences in the [source].
  ///
  /// The [sentences] are obtained by splitting [source] at sentence
  /// punctuation marks and line end characters.
  List<Sentence> get sentences;

  /// The set of unique tokens in the document.
  List<Token> get tokens;
}

/// Implementation class for [TextSource].
class _TextSourceImpl implements TextSource {
  @override
  final String source;

  @override
  final List<Sentence> sentences;

  @override
  List<Token> get tokens {
    final tokens = <Token>[];
    var sentenceIndex = 0;
    for (final sentence in sentences) {
      tokens.addAll(sentence.tokens
          .map((e) => Token(e.term, e.index + sentenceIndex, e.position)));
      sentenceIndex += sentence.source.length;
    }
    return tokens;
  }

  /// Instantiates a const [_TextSourceImpl].
  const _TextSourceImpl(this.source, this.sentences);
}
