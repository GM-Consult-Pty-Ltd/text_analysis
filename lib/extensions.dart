// BSD 3-Clause License
// Copyright ©2022, GM Consult Pty Ltd
// All rights reserved

/// Exports the extension methods exposed by this package. Also exports
/// the extensions from the `porter_2_stemmer` package.
library extensions;

export 'src/term_similarity/_index.dart'
    show
        TermSimilarityExtensions,
        TermSimilarityCollectionExtension,
        SimilarityIndexCollectionExtension;
export 'src/text_analyzer/_index.dart'
    show
        TokenCollectionExtension,
        TextAnalysisExtensionsOnJSON,
        KGramExtensionOnTermCollection,
        TextAnalysisExtensionsOnString,
        StringCollectionCollectionExtension,
        TextAnalysisExtensionsOnStringList;
export 'package:porter_2_stemmer/porter_2_stemmer.dart'
    show Porter2StemmerExtension;
// export 'src/english_analyzer/english.dart' show EnglishStringExtensions;
