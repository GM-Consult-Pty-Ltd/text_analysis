// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'package:text_analysis/text_analysis.dart';

/// An object model for a pair of [Term]s that are both non-empty.
/// [terms] is an ordered list of length 2, containing non-empty [Term]s [term1]
///   and [term2];
/// - [term1] is the first [Term] in the pair ([terms].first); and
/// - [term2] is the second [Term] in the pair ([terms].last).
class TermPair {
  /// An ordered list of length 2, containing non-empty [Term]s [term1]
  /// and [term2].
  final List<Term> terms;

  /// Returns the first [Term] in the pair. Equivalent to [terms].first.
  String get term1 => terms.first;

  /// Returns the second [Term] in the pair. Equivalent to [terms].last.
  String get term2 => terms.last;

  /// Returns the terms separated by a single whte-space, e.g. "term1 term2".
  @override
  String toString() => '$term1 $term2';

  /// Compares only whether:
  /// - [other] is [TermPair];
  /// - [term1] == [other].term1; and
  /// - [term2] == [other].term2.
  @override
  bool operator ==(Object other) =>
      other is TermPair && term1 == other.term1 && term2 == other.term2;

  @override
  int get hashCode => Object.hash(term1, term2);

  /// Factory constructor that instantiates a [TermPair] instance:
  /// - [term1] is the first [Term] in the pair; and
  /// - [term2] is the second [Term] in the pair.
  /// Both terms must be non-empty strings, otherwise an exception is thrown.
  factory TermPair(Term term1, Term term2) {
    assert(term1.isNotEmpty && term2.isNotEmpty);
    return TermPair._([term1, term2]);
  }

  /// Private generative const constructor.
  const TermPair._(this.terms) : assert(terms.length == 2);
}
