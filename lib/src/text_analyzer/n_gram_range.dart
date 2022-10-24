// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd

/// Enumerates a range of N-gram sizes (minimum and maximum length).
///
/// An `n-gram` is (sometimes also called Q-gram) is a contiguous sequence of
/// `n` items from a given sample of text or speech. The items can be phonemes,
/// syllables, letters, words or base pairs according to the application.
///
/// The `n-grams` typically are collected from a text or speech `corpus`.
/// When the items are words, `n-grams` may also be called shingles
/// (from [Wikipedia](https://en.wikipedia.org/wiki/N-gram)).
class NGramRange {
  //
  /// The minimum number of terms in the n-gram
  final int min;

  /// The maximum number of terms in the n-gram
  final int max;

  /// Default const generative constructor.
  const NGramRange(this.min, this.max);

  @override
  bool operator ==(Object other) =>
      other is NGramRange && max == other.max && min == other.min;

  @override
  int get hashCode => Object.hash(max, min);
}
