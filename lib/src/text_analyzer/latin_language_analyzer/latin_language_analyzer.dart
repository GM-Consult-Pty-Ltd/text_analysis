// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

import 'package:porter_2_stemmer/porter_2_stemmer.dart';
import 'package:porter_2_stemmer/extensions.dart';
import 'package:text_analysis/extensions.dart';
import 'package:text_analysis/text_analysis.dart';
import 'package:text_analysis/type_definitions.dart';

part 'mixins/_character_filter.dart';
part 'mixins/_constants.dart';
part 'mixins/_keyword_extractor.dart';
part 'mixins/_n_grammer.dart';
part 'mixins/_paragraph_splitter.dart';
part 'mixins/_syllable_counter.dart';
part 'mixins/_syllable_stemmer.dart';
part 'mixins/_term_filter.dart';
part 'mixins/_term_splitter.dart';
part 'mixins/_tokenizer.dart';
part 'mixins/_sentence_splitter.dart';

/// A [TextAnalyzer] implementation for Latin languages analysis.
///
/// Exposes a const default generative constructor.
abstract class LatinLanguageAnalyzer
    with
        _CharacterFilter,
        _NGrammer,
        _ParagraphSplitter,
        _SyllableCounter,
        _SentenceSplitter,
        _TermFilter,
        _TermSplitter,
        _Tokenizer,
        _KeyWordExtractor
    implements TextAnalyzer {
  /// Initializes a const [LatinLanguageAnalyzer].
  const LatinLanguageAnalyzer();

  @override
  CharacterFilter get characterFilter => _filterCharacters;

  @override
  JsonTokenizer get jsonTokenizer => _tokenizeJson;

  @override
  NGrammer get nGrammer => _toNGrams;

  @override
  ParagraphSplitter get paragraphSplitter => _splitToParagraphs;

  @override
  SentenceSplitter get sentenceSplitter => _splitToSentences;

  @override
  SyllableCounter get syllableCounter => _countSyllables;

  @override
  TermFilter get termFilter => _filterTerms;

  @override
  TermSplitter get termSplitter => _splitToTerms;

  @override
  Tokenizer get tokenizer => _tokenize;

  @override
  KeywordExtractor get keywordExtractor => _extractKeywords;
}
