// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'package:text_analysis/text_analysis.dart';

/// A [TextSource] represents a text [source] that has been analyzed to
/// enumerate its [sentences] and [tokens].
abstract class TextSource {
  //

  /// Instantiates a [TextSource] from the [source].
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

  /// Compares only whether:
  /// - [other] is [TextSource];
  /// - [source] == [other].source; and
  /// - [sentences].length == [other].sentences.length.
  @override
  bool operator ==(Object other) =>
      other is TextSource &&
      source == other.source &&
      sentences.length == other.sentences.length;

  @override
  int get hashCode => Object.hash(source, tokens);
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
    var sentenceTermPosition = 0;
    for (final sentence in sentences) {
      tokens.addAll(sentence.tokens.map((e) {
        final tokenIndex = e.index + sentenceIndex;
        final termPosition = sentenceTermPosition + e.termPosition;
        final tokenPosition = tokenIndex / source.length;
        return Token(e.term, tokenIndex, tokenPosition, termPosition);
      }));
      sentenceIndex += sentence.source.length;
      if (tokens.isNotEmpty) {
        sentenceTermPosition = tokens.last.termPosition + 1;
      }
    }
    return tokens;
  }

  /// Instantiates a const [_TextSourceImpl].
  const _TextSourceImpl(this.source, this.sentences);
}
