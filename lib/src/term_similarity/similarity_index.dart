// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd

/// Object model for a suggestion as alternate for a term. Used in spelling
/// correction and term expansion.
/// - [term] is the suggested term.
/// - [similarity] is the similarity level of the suggestion on a scale
///   of 0.0 to 1.0, where 1.0 indicates the terms are identical.
class SimilarityIndex {
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

  /// Instantiate a const [SimilarityIndex] with the [term] and [similarity]
  /// parameters.
  /// - [term] is the suggested term and must be a non-empty String. An
  ///   exception is thrown if [term] is empty.
  /// - [similarity] is the similarity level of the suggestion on a scale
  ///   of 0.0 to 1.0, where 1.0 indicates the terms are identical. An
  ///   exception is thrown if [similarity] is less than 0.0 or more than 1.0.
  const SimilarityIndex(this.term, this.similarity)
      : assert(term != '' && similarity >= 0.0 && similarity <= 1.0);

  /// Returns true if [runtimeType], [term] and [similarity] are equal.
  @override
  bool operator ==(Object other) =>
      other is SimilarityIndex &&
      term == other.term &&
      similarity == other.similarity;

  @override
  int get hashCode => Object.hash(term, similarity);
}

/// Extension methods on collection of [SimilarityIndex].
extension SimilarityIndexCollectionExtension on Iterable<SimilarityIndex> {
//

  /// Returns the first [limit] instances of the collection.
  ///
  /// Returns the entire collection as an ordered list if [limit] is null.
  List<SimilarityIndex> limit([int? limit = 10]) {
    final list = List<SimilarityIndex>.from(this);
    return (limit != null && list.length > limit)
        ? list.sublist(0, limit)
        : list;
  }

  /// Sorts the collection of [SimilarityIndex] instances in descending
  /// order of [SimilarityIndex.similarity].
  List<SimilarityIndex> sortBySimilarity([bool descending = true]) {
    final list = List<SimilarityIndex>.from(this);
    if (descending) {
      list.sort(((a, b) => b.similarity.compareTo(a.similarity)));
    } else {
      list.sort(((a, b) => a.similarity.compareTo(b.similarity)));
    }
    return list;
  }
}
