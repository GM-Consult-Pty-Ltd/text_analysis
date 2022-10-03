// Copyright ©2022, GM Consult (Pty) Ltd. All rights reserved

/// Exports the extension methods exposed by this package. Also exports
/// the extensions from the `porter_2_stemmer` package.
library extensions;

export 'src/term_similarity.dart' show TermSimilarityExtensions;
export 'src/token.dart' show TokenCollectionExtension;
export 'package:porter_2_stemmer/porter_2_stemmer.dart'
    show Porter2StemmerExtension;
