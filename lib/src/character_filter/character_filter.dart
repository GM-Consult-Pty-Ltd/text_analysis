// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

// import 'package:text_analysis/text_analysis.dart';

/// Type definition of a function that filters characters from the [source]
/// text in preparation of tokenization.
typedef TextFilter = String Function(String source);

/// The character filter class exposes the [filter] method, an implementation
/// of [TextFilter].
abstract class CharacterFilter {
  //

  /// The [filter] method, an implementation of [TextFilter], filters
  /// characters from the [source] text in preparation of tokenization.
  String filter(String source);
}

class _CharacterFilterImpl implements CharacterFilter {
  //

  @override
  String filter(String source) {
    // TODO: implement method _CharacterFilterImpl.filter
    return source;
  }
}
