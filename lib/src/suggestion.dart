// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd

/// Object model for a suggestion as alternate for a term. Used in spelling
/// correction and term expansion.
/// - [term] is the suggested term.
/// - [similarity] is the similarity level of the suggestion on a scale
///   of 0.0 to 1.0, where 1.0 indicates the terms are identical.
class Suggestion {
//

  @override
  String toString() {
    return '{$term: ${similarity.toStringAsFixed(3)}}';
  }

  /// The suggested term.
  final String term;

  /// The similarity level of the suggestion on a scale of 0.0 to 1.0,
  /// where 1.0 indicates the terms are identical.
  final double similarity;

  /// Instantiate a const [Suggestion] with the [term] and [similarity]
  /// parameters.
  /// - [term] is the suggested term and must be a non-empty String. An
  ///   exception is thrown if [term] is empty.
  /// - [similarity] is the similarity level of the suggestion on a scale
  ///   of 0.0 to 1.0, where 1.0 indicates the terms are identical. An
  ///   exception is thrown if [similarity] is less than 0.0 or more than 1.0.
  const Suggestion(this.term, this.similarity)
      : assert(term != '' && similarity >= 0.0 && similarity <= 1.0);
}
