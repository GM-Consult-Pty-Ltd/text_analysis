// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

/// DART text analyzer that extracts tokens from JSON documents for use in
/// information retrieval systems.
library text_analysis;

export 'src/_index.dart'
    show
        PartOfSpeech,
        PoSTag,
        SimilarityIndex,
        TermSimilarity,
        TextAnalyzer,
        TermCoOccurrenceGraph,
        English,
        TermSimilarityBase,
        TermSimilarityMixin,
        TermCoOccurrenceGraphMixin,
        TermCoOccurrenceGraphBase,
        LatinLanguageAnalyzer,
        TextDocumentMixin,
        TextDocumentBase,
        TextDocument,
        TokenizingStrategy,
        NGramRange,
        Token;

export 'package:porter_2_stemmer/porter_2_stemmer.dart' show Porter2Stemmer;
