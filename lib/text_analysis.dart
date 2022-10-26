// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

/// DART text analyzer that extracts tokens from JSON documents for use in
/// information retrieval systems.
library text_analysis;

export 'src/english_analyzer/english.dart' show English;
export 'src/part_of_speech_tagging/_index.dart' show PartOfSpeech, PoSTag;
export 'src//term_similarity/_index.dart' show SimilarityIndex, TermSimilarity;
export 'src/text_analyzer/_index.dart' show TextAnalyzer, TermCoOccurrenceGraph;
export 'src/text_document/_index.dart' show TextDocument;
export 'src/text_tokenizer/_index.dart' show TextTokenizer, NGramRange, Token;
export 'package:porter_2_stemmer/porter_2_stemmer.dart' show Porter2Stemmer;
