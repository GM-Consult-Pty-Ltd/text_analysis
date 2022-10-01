// Copyright ©2022, GM Consult (Pty) Ltd. All rights reserved

/// DART text analyzer that extracts tokens from JSON documents for use in
/// information retrieval systems.
library text_analysis;

export 'src/english.dart' show English;
export 'src/term_similarity.dart' show TermSimilarity;
export 'src/text_analyzer.dart' show TextAnalyzer;
export 'src/text_document.dart'
    show TextDocument, TextDocumentMixin, TextDocumentBase;
export 'src/text_tokenizer.dart'
    show TextTokenizer, TextTokenizerMixin, TextTokenizerBase;
export 'src/token.dart' show Token;
export 'package:porter_2_stemmer/porter_2_stemmer.dart' show Porter2Stemmer;
