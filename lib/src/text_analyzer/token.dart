// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd

import 'package:text_analysis/text_analysis.dart';
import 'package:text_analysis/type_definitions.dart';

/// A [Token] represents a [term] (word) present in a text source:
/// - [term] is the term that will be looked up in the index;
/// - [termPosition] is the zero-based position of the [term] in an ordered
///   list of all the terms in the source text;
/// - [n] is the number of terms in the n-gram; and
/// - [zone] is the nullable name of the zone the [term] is in.
class Token {
  //

  /// Instantiates [Token] instance.
  static const empty = Token('', 0, 0, null);

  /// Instantiates a [Token] instance:
  /// - [term] is the term that will be looked up in the index;
  /// - [termPosition] is the zero-based position of the [term] in an ordered
  ///   list of all the terms in the source text;
  /// - [zone] is the nullable / optional name of the zone the [term] is in;
  const Token(this.term, this.n, this.termPosition, [this.zone]);

  /// The number of terms in a n-gram.
  final int n;

  /// A [term] extracted text by a [TextAnalyzer].
  final Term term;

  /// The name of the zone (e.g. field name in a JSON document) that the
  /// [term] is in.
  final Zone? zone;

  /// The zero-based position of the [term] in an ordered list of all the terms
  /// in the source text.
  final int termPosition;

  /// Compares whether:
  /// - [other] is [Token];
  /// - [zone] == [other].zone;
  /// - [term] == [other].term; and
  /// - [termPosition] == [other].termPosition.
  @override
  bool operator ==(Object other) =>
      other is Token &&
      term == other.term &&
      zone == other.zone &&
      termPosition == other.termPosition;

  @override
  int get hashCode => Object.hash(term, zone, termPosition);

  //
}
