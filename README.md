<!-- 
BSD 3-Clause License
Copyright (c) 2022, GM Consult Pty Ltd
All rights reserved. 
-->

[![GM Consult Pty Ltd](https://raw.githubusercontent.com/GM-Consult-Pty-Ltd/text_analysis/main/dev/images/text_analysis_header.png?raw=true "GM Consult Pty Ltd")](https://github.com/GM-Consult-Pty-Ltd/text_analysis)
## **Tokenize text, compute document readbility and compare terms in Natural Language Processing.**

Skip to section:
* [Overview](#overview)
* [Usage](#usage)
* [API](#api)
* [Definitions](#definitions)
* [References](#references)
* [Issues](#issues)

## Overview

The `text_analysis` package provides methods to tokenize text, compute readibility scores for a document and evaluate similarity of `terms`. It is intended to be used in Natural Language Processing (`NLP`) as part of an information retrieval system. 

It is split into [three libraries](#usage):
* [text_analysis](https://pub.dev/documentation/text_analysis/0.12.0-2/text_analysis/text_analysis-library.html) is the core library that exports the tokenization, analysis and string similarity functions;
* [extensions](https://pub.dev/documentation/text_analysis/0.12.0-2/extensions/extensions-library.html) exports extension methods also provided as static methods of the [TextSimilarity](https://pub.dev/documentation/text_analysis/latest/text_analysis/TermSimilarity-class.html) class; and
* [type_definitions](https://pub.dev/documentation/text_analysis/0.12.0-2/type_definitions/type_definitions-library.html) exports all the typedefs used in this package.

Refer to the [references](#references) to learn more about information retrieval systems and the theory behind this library.

### Tokenization

Tokenization comprises the following steps:
* a `term splitter` splits text to a list of terms at appropriate places like white-space and mid-sentence punctuation;
* a `character filter` manipulates terms prior to tokenization (e.g. changing case and / or removing non-word characters);
* a `term filter` manipulates the terms by splitting compound or hyphenated terms or applying stemming and lemmatization. The `termFilter` can also filter out `stopwords`; and
* the `tokenizer` converts terms to a collection of `tokens` that contain tokenized versions of the term and a pointer to the position of the tokenized term (n-gram) in the source text. The tokens are generated for keywords, terms and/or n-grams, depending on the `TokenizingStrategy` selected. The desired n-gram range can be passed in when tokenizing the text or document.

![Text analysis](https://github.com/GM-Consult-Pty-Ltd/text_analysis/raw/main/assets/images/text_analysis.png?raw=true?raw=true "Tokenizing overview")

### Readability

The [TextDocument](#textdocument) enumerates a text document's *paragraphs*, *sentences*, *terms* and *tokens* and computes readability measures:
* the average number of words in each sentence;
* the average number of syllables per word;
* the `Flesch reading ease score`, a readibility measure calculated from  sentence length and word length on a 100-point scale; and
* `Flesch-Kincaid grade level`, a readibility measure relative to U.S. school grade level.
The `TextDocument` also includes a co-occurrence graph generated using the Rapid Keyword Extraction (RAKE) algorithm, from which the keywords (and keyword scores) can be obtained.

### String Comparison

The following measures of `term` similarity are provided as extensions on String:
* `Damerau–Levenshtein distance` is the minimum number of  single-character edits (transpositions, insertions, deletions or substitutions) required to change one `term` into another;
* `edit similarity` is a normalized measure of `Damerau–Levenshtein distance` on a scale of 0.0 to 1.0, calculated by dividing the the difference between the maximum edit distance (sum of the length of the two terms) and the computed `editDistance`, by  the maximum edit distance;
* `length distance` returns the absolute value of the difference in length between two terms;
* `character similarity` returns the similarity two terms as it relates to the collection of unique characters in each term on a scale of 0.0 to 1.0;
* `length similarity` returns the similarity in length between two terms on a scale of 0.0 to 1.0 on a log scale (1 - the log of the ratio of the term lengths); and
* `Jaccard similarity` measures similarity between finite sample sets, and is defined as the size of the intersection divided by the size of the union of the sample sets.

The [TermSimilarity](#termsimilarity) class enumerates all the similarity measures of two terms and provides the `TermSimilarity.similarity` property that combines the four measures into a single value.

The [TermSimilarity](#termsimilarity) class also provides a function for splitting terms into `k-grams`, used in spell correction algorithms.

(*[back to top](#)*)

## Usage

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  text_analysis: <latest version>
```

In your code file add the text_analysis library import. This will also import the `Porter2Stemmer` class from the `porter_2_stemmer` package.

```dart
// import the core classes
import 'package:text_analysis/text_analysis.dart';

```

To use the package's extensions and/or type definitions, also add any of the following imports:

```dart

// import the implementation classes, if needed
import 'package:text_indexing/implementation.dart'; 

// import the typedefs, if needed
import 'package:text_indexing/type_definitions.dart'; 

// import the extensions, if needed
import 'package:text_indexing/extensions.dart'; 

```

Basic English tokenization can be performed by using a `English.analyzer` static const instance with no token filter:

```dart
  // Use the static English.analyzer instance to tokenize the text using the
  // English analyzer.
  final tokens = await English.analyzer.tokenizer(readabilityExample,
      strategy: TokenizingStrategy.all, nGramRange: NGramRange(1, 2));
```
To analyze text or a document, hydrate a [TextDocument](#textdocument) to obtain the text statistics and readibility scores:

```dart
  // get some sample text
  final sample =
      'The Australian platypus is seemingly a hybrid of a mammal and reptilian creature.';

  // hydrate the TextDocument
  final textDoc = await TextDocument.analyze(
      sourceText: sample,
      analyzer: English.analyzer,
      nGramRange: NGramRange(1, 3));

  // print the `Flesch reading ease score`
  print(
      'Flesch Reading Ease: ${textDoc.fleschReadingEaseScore().toStringAsFixed(1)}');
  // prints "Flesch Reading Ease: 37.5"
```

To compare terms, call the desired extension on the `term`, or the static method from the [TermSimilarity](https://pub.dev/documentation/text_analysis/latest/text_analysis/TermSimilarity-class.html) class:

```dart

  // define a misspelt term
  const term = 'bodrer';

  // a collection of auto-correct options
  const candidates = [
    'bord',
    'board',
    'broad',
    'boarder',
    'border',
    'brother',
    'bored'
  ];

  // get a list of the terms orderd by descending similarity
  final matches = term.matches(candidates);
  // same as TermSimilarity.matches(term, candidates))

  // print matches
  print('Ranked matches: $matches');
  // prints:
  //     Ranked matches: [border, boarder, bored, brother, board, bord, broad]
  //  

```

Please see the [examples](https://pub.dev/packages/text_analysis/example) for more details.

(*[back to top](#)*)

## API

The key interfaces of the `text_analysis` library are briefly described in this section. Please refer to the [documentation](https://pub.dev/documentation/text_analysis/latest/) for details.

The API contains a fair amount of boiler-plate, but we aim to make the code as readable, extendable and re-usable as possible:

* We use an `interface > implementation mixin > base-class > implementation class pattern`:
  - the `interface` is an abstract class that exposes fields and methods but contains no implementation code. The `interface` may expose a factory constructor that returns an `implementation class` instance;
  - the `implementation mixin` implements the `interface` class methods, but not the input fields;
  - the `base-class` is an abstract class with the `implementation mixin` and exposes a default, unnamed generative const constructor for sub-classes. The intention is that `implementation classes` extend the `base class`, overriding the `interface` input fields with final properties passed in via a const generative constructor.
* To maximise performance of the indexers the API performs lookups in nested hashmaps of DART core types. To improve code legibility the API makes use of type aliases, callback function definitions and extensions. The typedefs and extensions are not exported by the [text_analysis](https://pub.dev/documentation/text_analysis/latest/text_analysis/text_analysis-library.html) library, but can be found in the [type_definitions](https://pub.dev/documentation/text_analysis/latest/type_definitions/type_definitions-library.html), [implementation](https://pub.dev/documentation/text_analysis/latest/type_definitions/implementation-library.html) and [extensions](https://pub.dev/documentation/text_analysis/latest/extensions/extensions-library.html) mini-libraries. [Import these libraries seperately](#usage) if needed.

(*[back to top](#)*)

#### TermSimilarity

The [TermSimilarity](https://pub.dev/documentation/text_analysis/0.12.0-2/text_analysis/TermSimilarity-class.html) class provides the following measures of similarity between two terms:
* `characterSimilarity` returns the similarity two terms as it relates to the collection of unique characters in each term on a scale of 0.0 to 1.0;
* `editDistance` returns the `Damerau–Levenshtein distance`, the minimum number of  single-character edits (transpositions, insertions, deletions or substitutions) required to change one `term` into another;
* `editSimilarity` returns a normalized measure of `Damerau–Levenshtein distance` on a scale of 0.0 to 1.0, calculated by dividing the the difference between the maximum edit distance (sum of the length of the two terms) and the computed `editDistance`, by by the maximum edit distance;
* `lengthDistance` returns the absolute value of the difference in length between two terms;
* `lengthSimilarity` returns the similarity in length between two terms on a scale of 0.0 to 1.0 on a log scale (1 - the log of the ratio of the term lengths); 
* `jaccardSimilarity` returns the Jaccard Similarity Index of two terms.

To compare one term with a collection of other terms, the following static methods are also provided:
* `editDistanceMap` returns a hashmap of `terms` to their `editSimilarity` with a term;
* `editSimilarityMap` returns a hashmap of `terms` to their `editSimilarity` with a term;
* `lengthSimilarityMap` returns a hashmap of `terms` to their `lengthSimilarity` with a term;
* `jaccardSimilarityMap` returns a hashmap of `terms` to Jaccard Similarity Index with a term;
* `termSimilarityMap` returns a hashmap of `terms` to termSimilarity with a term;
* `termSimilarities`,  `editSimilarities`, `characterSimilarities`, `lengthSimilarities` and `jaccardSimilarities` all return a list of [SimilarityIndex] values for candidate terms; and
* `matches` returns the best matches from `terms` for a term, in descending order of term similarity (best match first).

*String comparisons are NOT case-sensitive.*

The  [TextSimilarity](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextSimilarity-class.html) class relies on [extension methods](https://pub.dev/documentation/text_analysis/latest/extensions/TermSimilarityExtensions.html) that can be imported from the [extensions](https://pub.dev/documentation/text_analysis/0.12.0-2/extensions/extensions-library.html) library.

(*[back to top](#)*)

#### TextAnalyzer

The [TextAnalyzer](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer-class.html) interface exposes language-specific properties and methods used in text analysis:
* [characterFilter](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/characterFilter.html) is a function that manipulates text prior to stemming and tokenization;
* [termFilter](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/termFilter.html) is a filter function that returns a collection of terms from a term. It returns an empty collection if the term is to be excluded from analysis or, returns multiple terms if the term is split (at hyphens) and / or, returns modified term(s), such as applying a stemmer algorithm;
* [termSplitter](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/termSplitter.html) returns a list of terms from text;
* [sentenceSplitter](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/sentenceSplitter.html) splits text into a list of sentences at sentence and line endings;
* [paragraphSplitter](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/paragraphSplitter.html) splits text into a list of paragraphs at line endings; 
* [stemmer](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/stemmer.html) is a language-specific function that returns the stem of a term;
* [lemmatizer](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/lemmatizer.html) is a language-specific function that returns the lemma of a term;
* [tokenizer](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/tokenizer.html) and [jsonTokenizer](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/jsonTokenizer.html) are callbacks that return a collection of [tokens](https://pub.dev/documentation/text_analysis/latest/text_analysis/Token-class.html) from text or a document;
* [keywordExtractor](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/keywordExtractor.html)  is a splitter function that returns an ordered collection of keyword phrases from text;
* [termExceptions](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/termExceptions.html) is a hashmap of words to token terms for special words that should not be re-capitalized, stemmed or lemmatized;
* [stopWords](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/stopWords.html) are terms that commonly occur in a language and that do not add material value to the analysis of text; and
* [syllableCounter](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/syllableCounter.html) returns the number of syllables in a word or text.

The [LatinLanguageAnalyzer](https://pub.dev/documentation/text_analysis/latest/text_analysis/LatinLanguageAnalyzer-class.html) implements the `TextAnalyzer` interface methods for languages that use the Latin/Roman alphabet/character set.

The [English](https://pub.dev/documentation/text_analysis/latest/text_analysis/English-class.html) implementation of [TextAnalyzer](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer-class.html) is included in this library and mixes in the `LatinLanguageAnalyzerMixin`.

(*[back to top](#)*)

### TextDocument

The [TextDocument](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument-class.html) object model enumerates a text document's *paragraphs*, *sentences*, *terms*, *keywords*, *n-grams*, *syllable count* and *tokens* and provides functions that return text analysis measures:
* [averageSentenceLength](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/averageSentenceLength.html) is the average number of words in [sentences](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/sentences.html);
* [averageSyllableCount](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/averageSyllableCount.html) is the average number of syllables per word in
  [terms](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/terms.html);
* [wordCount](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/wordCount.html) the total number of words in the [sourceText](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/sourceText.html);
* [fleschReadingEaseScore](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/fleschReadingEaseScore.html) is a readibility measure calculated from sentence length and word length on a 100-point scale. The higher the score, the easier it is to understand the document;
* [fleschKincaidGradeLevel](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/fleschKincaidGradeLevel.html) is a readibility measure relative to U.S. school grade level.  It is also calculated from sentence length and word length .

The [TextDocumentMixin](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocumentMixin-class.html) implements the [averageSentenceLength](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocumentMixin/averageSentenceLength.html), [averageSyllableCount](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocumentMixin/averageSyllableCount.html), [wordCount](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocumentMixin/wordCount.html), [fleschReadingEaseScore](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocumentMixin/fleschReadingEaseScore.html) and [fleschKincaidGradeLevel](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocumentMixin/fleschKincaidGradeLevel.html) methods.

A [TextDocument](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument-class.html) can be hydrated with the [unnamed factory constructor](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/TextDocument.html) or using the [analyze](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/analyze.html) or [analyzeJson](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/analyzeJson.html) static methods. Alternatively, extend [TextDocumentBase](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocumentBase-class.html) class.

(*[back to top](#)*)

## Definitions

The following definitions are used throughout the [documentation](https://pub.dev/documentation/text_analysis/latest/):

* `corpus`- the collection of `documents` for which an `index` is maintained.
* `cosine similarity` - similarity of two vectors measured as the cosine of the angle between them, that is, the dot product of the vectors divided by the product of their euclidian lengths (from [Wikipedia](https://en.wikipedia.org/wiki/Cosine_similarity)).
* `character filter` - filters characters from text in preparation of tokenization .  
* `Damerau–Levenshtein distance` - a metric for measuring the `edit distance` between two `terms` by counting the minimum number of operations (insertions, deletions or substitutions of a single character, or transposition of two adjacent characters) required to change one `term` into the other (from [Wikipedia](https://en.wikipedia.org/wiki/Damerau%E2%80%93Levenshtein_distance)).
* `dictionary (in an index)` - a hash of `terms` (`vocabulary`) to the frequency of occurence in the `corpus` documents.
* `document` - a record in the `corpus`, that has a unique identifier (`docId`) in the `corpus`'s primary key and that contains one or more text fields that are indexed.
* `document frequency (dFt)` - the number of documents in the `corpus` that contain a term.
* `edit distance` - a measure of how dissimilar two terms are by counting the minimum number of operations required to transform one string into the other (from [Wikipedia](https://en.wikipedia.org/wiki/Edit_distance)).
* `etymology` - the study of the history of the form of words and, by extension, the origin and evolution of their semantic meaning across time (from [Wikipedia](https://en.wikipedia.org/wiki/Etymology)).
* `Flesch reading ease score` - a readibility measure calculated from  sentence length and word length on a 100-point scale. The higher the score, the easier it is to understand the document (from [Wikipedia](https://en.wikipedia.org/wiki/Flesch%E2%80%93Kincaid_readability_tests)).
* `Flesch-Kincaid grade level` - a readibility measure relative to U.S. school grade level.  It is also calculated from sentence length and word length (from [Wikipedia](https://en.wikipedia.org/wiki/Flesch%E2%80%93Kincaid_readability_tests)).
* `IETF language tag` - a standardized code or tag that is used to identify human languages in the Internet. (from [Wikepedia](https://en.wikipedia.org/wiki/IETF_language_tag)).
* `index` - an [inverted index](https://en.wikipedia.org/wiki/Inverted_index) used to look up `document` references from the `corpus` against a `vocabulary` of `terms`. 
* `index-elimination` - selecting a subset of the entries in an index where the `term` is in the collection of `terms` in a search phrase.
* `inverse document frequency (iDft)` - a normalized measure of how rare a `term` is in the corpus. It is defined as `log (N / dft)`, where N is the total number of terms in the index. The `iDft` of a rare term is high, whereas the `iDft` of a frequent term is likely to be low.
* `Jaccard index` measures similarity between finite sample sets, and is defined as the size of the intersection divided by the size of the union of the sample sets (from [Wikipedia](https://en.wikipedia.org/wiki/Jaccard_index)).
* `Map<String, dynamic>` is an acronym for `"Java Script Object Notation"`, a common format for persisting data.
* `k-gram` - a sequence of (any) k consecutive characters from a `term`. A `k-gram` can start with "$", denoting the start of the term, and end with "$", denoting the end of the term. The 3-grams for "castle" are { $ca, cas, ast, stl, tle, le$ }.
* `lemma  or lemmatizer` - lemmatisation (or lemmatization) in linguistics is the process of grouping together the inflected forms of a word so they can be analysed as a single item, identified by the word's lemma, or dictionary form (from [Wikipedia](https://en.wikipedia.org/wiki/Lemmatisation)).
* `n-gram` (sometimes also called Q-gram) is a contiguous sequence of `n` items from a given sample of text or speech. The items can be phonemes, syllables, letters, words or base pairs according to the application. The `n-grams` typically are collected from a text or speech `corpus`. When the items are words, `n-grams` may also be called shingles (from [Wikipedia](https://en.wikipedia.org/wiki/N-gram)).
* `Natural language processing (NLP)` is a subfield of linguistics, computer science, and artificial intelligence concerned with the interactions between computers and human language, in particular how to program computers to process and analyze large amounts of natural language data (from [Wikipedia](https://en.wikipedia.org/wiki/Natural_language_processing)).
* `Part-of-Speech (PoS) tagging` is the task of labelling every word in a sequence of words with a tag indicating what lexical syntactic category it assumes in the given sequence (from [Wikipedia](https://en.wikipedia.org/wiki/Part-of-speech_tagging)).
* `Phonetic transcription` - the visual representation of speech sounds (or phones) by means of symbols. The most common type of phonetic transcription uses a phonetic alphabet, such as the International Phonetic Alphabet (from [Wikipedia](https://en.wikipedia.org/wiki/Phonetic_transcription)).
* `postings` - a separate index that records which `documents` the `vocabulary` occurs in.  In a positional `index`, the postings also records the positions of each `term` in the `text` to create a positional inverted `index`.
* `postings list` - a record of the positions of a `term` in a `document`. A position of a `term` refers to the index of the `term` in an array that contains all the `terms` in the `text`. In a zoned `index`, the `postings lists` records the positions of each `term` in the `text` a `zone`.
* `stem or stemmer` -  stemming is the process of reducing inflected (or sometimes derived) words to their word stem, base or root form (generally a written word form) (from [Wikipedia](https://en.wikipedia.org/wiki/Stemming)).
* `stopwords` - common words in a language that are excluded from indexing.
* `term` - a word or phrase that is indexed from the `corpus`. The `term` may differ from the actual word used in the corpus depending on the `tokenizer` used.
* `term filter` - filters unwanted terms from a collection of terms (e.g. stopwords), breaks compound terms into separate terms and / or manipulates terms by invoking a `stemmer` and / or `lemmatizer`.
* `term expansion` - finding terms with similar spelling (e.g. spelling correction) or synonyms for a term. 
* `term frequency (Ft)` - the frequency of a `term` in an index or indexed object.
* `term position` - the zero-based index of a `term` in an ordered array of `terms` tokenized from the `corpus`.
* `text` - the indexable content of a `document`.
* `token` - representation of a `term` in a text source returned by a `tokenizer`. The token may include information about the `term` such as its position(s) (`term position`) in the text or frequency of occurrence (`term frequency`).
* `token filter` - returns a subset of `tokens` from the tokenizer output.
* `tokenizer` - a function that returns a collection of `token`s from `text`, after applying a character filter, `term` filter, [stemmer](https://en.wikipedia.org/wiki/Stemming) and / or [lemmatizer](https://en.wikipedia.org/wiki/Lemmatisation).
* `vocabulary` - the collection of `terms` indexed from the `corpus`.
* `zone` - the field or zone of a document that a term occurs in, used for parametric indexes or where scoring and ranking of search results attribute a higher score to documents that contain a term in a specific zone (e.g. the title rather that the body of a document).

(*[back to top](#)*)

## References

* [Manning, Raghavan and Schütze, "*Introduction to Information Retrieval*", Cambridge University Press, 2008](https://nlp.stanford.edu/IR-book/pdf/irbookprint.pdf)
* [University of Cambridge, 2016 "*Information Retrieval*", course notes, Dr Ronan Cummins, 2016](https://www.cl.cam.ac.uk/teaching/1516/InfoRtrv/)
* [Wikipedia (1), "*Inverted Index*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Inverted_index)
* [Wikipedia (2), "*Lemmatisation*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Lemmatisation)
* [Wikipedia (3), "*Stemming*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Stemming)
* [Wikipedia (4), "*Synonym*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Synonym)
* [Wikipedia (5), "*Jaccard Index*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Jaccard_index)
* [Wikipedia (6), "*Flesch–Kincaid readability tests*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Flesch%E2%80%93Kincaid_readability_tests)
* [Wikipedia (7), "*Edit distance*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Edit_distance)
* [Wikipedia (8), "*Damerau–Levenshtein distance*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Damerau%E2%80%93Levenshtein_distance)
* [Wikipedia (9), "*Natural language processing*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Natural_language_processing)
* [Wikipedia (10), "*IETF language tag*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/IETF_language_tag)
* [Wikipedia (11), "*Phonetic transcription*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Phonetic_transcription)
* [Wikipedia (12), "*Etymology*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Etymology)
* [Wikipedia (13), "*Part-of-speech tagging*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Part-of-speech_tagging)
* [Wikipedia (14), "*N-gram*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/N-gram)
* [Wikipedia (15), "*Cosine similarity*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Cosine_similarity)

(*[back to top](#)*)

## Issues

If you find a bug please fill an [issue](https://github.com/GM-Consult-Pty-Ltd/text_analysis/issues).  

This project is a supporting package for a revenue project that has priority call on resources, so please be patient if we don't respond immediately to issues or pull requests.

