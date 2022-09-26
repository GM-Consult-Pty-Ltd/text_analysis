<!-- 
BSD 3-Clause License
Copyright (c) 2022, GM Consult Pty Ltd
All rights reserved. 
-->

[![GM Consult Pty Ltd](https://raw.githubusercontent.com/GM-Consult-Pty-Ltd/text_analysis/main/assets/images/text_analysis_header.png?raw=true "GM Consult Pty Ltd")](https://github.com/GM-Consult-Pty-Ltd)
## **Tokenizes text, computes document readbility and compares terms.**

*THIS PACKAGE IS **PRE-RELEASE**, IN ACTIVE DEVELOPMENT AND SUBJECT TO DAILY BREAKING CHANGES.*

Skip to section:
- [Overview](#overview)
- [Usage](#usage)
- [API](#api)
- [Definitions](#definitions)
- [References](#references)
- [Issues](#issues)

## Overview

The `text_analysis` library provides methods to tokenize text, compute readibility scores for a document and compare similarity of words. It is intended to be used as part of an information retrieval system. 

Refer to the [references](#references) to learn more about information retrieval systems and the theory behind this library.

#### Tokenization

Tokenization comprises the following steps:
* a `term splitter` splits text to a list of terms at appropriate places like white-space and mid-sentence punctuation;
* a `character filter` manipulates terms prior to stemming and tokenization (e.g. changing case and / or removing non-word characters);
* a `term filter` manipulates the terms by splitting compound or hyphenated terms or applying stemming and lemmatization. The `termFilter` can also filter out `stopwords`; and
* the `tokenizer` converts the resulting terms to a collection of `tokens` that contain the term and a pointer to the position of the term in the source text.

A String extension method `Set<KGram> kGrams([int k = 3])` that parses a set of k-grams of length k from a `term`.  The default k-gram length is 3 (tri-gram).

![Text analysis](https://github.com/GM-Consult-Pty-Ltd/text_analysis/raw/main/assets/images/text_analysis.png?raw=true?raw=true "Tokenizing overview")

### Readibility

The [TextDocument](#textdocument) enumerates a text document's *paragraphs*, *sentences*, *terms* and *tokens* and computes readability measures:
* the average number of words in each sentence;
* the average number of syllables for words;
* the `Flesch reading ease score`, a readibility measure calculated from  sentence length and word length on a 100-point scale; and
* `Flesch-Kincaid grade level`, a readibility measure relative to U.S. school grade level.

### String Comparison

The following String extension methods can be used for comparing `terms`:
* `lengthDistance` returns a normalized measure of difference between two terms on a log (base 2) scale;
* `lengthSimilarity` returns the similarity in length between two terms on a scale of 0 to 1.0 (equivalent to `1-lengthSimilarity` with a lower bound of 0.0); 
* `lengthSimilarityMap` returns a hashmap of `terms` to their `lengthSimilarity` with a term;
* `jaccardSimilarity` returns the Jaccard Similarity Index of two terms; 
* `jaccardSimilarityMap` returns a hashmap of `terms` to Jaccard Similarity Index with a term;
* `termSimilarity` returns a similarity index value between 0.0 and 1.0, defined as the product of `jaccardSimilarity` and `lengthSimilarity`. A term similarity of 1.0 means the two terms are equal in length and have an identical collection of [k]-grams; 
* `termSimilarityMap` returns a hashmap of `terms` to termSimilarity with a term; and
* `matches` returns the best matches from `terms` for a term, in descending order of term similarity (best match first).

## Usage

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  text_analysis: <latest version>
```

In your code file add the following import:

```dart
import 'package:text_analysis/src/_index.dart';
```

Basic English tokenization can be performed by using a `TextTokenizer` instance with the default text analyzer and no token filter:

```dart
  /// Use a TextTokenizer instance to tokenize the [text] using the default 
  /// [English] analyzer.
  final document = await TextTokenizer().tokenize(text);
```
To analyze text or a document, hydrate a [TextDocument] to obtain the text statistics and readibility scores:

```dart
      // get some sample text
      final sample =
          'The Australian platypus is seemingly a hybrid of a mammal and reptilian creature.';

      // hydrate the TextDocument
      final textDoc = await TextDocument.analyze(sourceText: sample);

      // print the `Flesch reading ease score`
      print(
          'Flesch Reading Ease: ${textDoc.fleschReadingEaseScore().toStringAsFixed(1)}');
      // prints "Flesch Reading Ease: 37.5"
```
For more complex text analysis:
* implement a `TextAnalyzer` for a different language or non-language documents;
* implement a custom `TextTokenizer`or extend `TextTokenizerBase`; and/or 
* pass in a `TokenFilter` function to a `TextTokenizer` to manipulate the tokens after tokenization as shown in the [examples](https://pub.dev/packages/text_analysis/example); and/or
extend [TextDocumentBase].

Please see the [examples](https://pub.dev/packages/text_analysis/example) for more details.

## API

The key interfaces of the `text_analysis` library are briefly described in this section. Please refer to the [documentation](https://pub.dev/documentation/text_analysis/latest/) for details.

#### TextAnalyzer

 The [TextAnalyzer](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer-class.html) interface exposes language-specific properties and methods used in text analysis:
 - [characterFilter](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/characterFilter.html) is a function that manipulates text prior to stemming and tokenization;
- [termFilter](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/termFilter.html) is a filter function that returns a collection of terms from a term. It returns an empty collection if the term is to be excluded from analysis or, returns multiple terms if the term is split (at hyphens) and / or, returns modified term(s), such as applying a stemmer algorithm;
- [termSplitter](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/termSplitter.html) returns a list of terms from text;
- [sentenceSplitter](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/sentenceSplitter.html) splits text into a list of sentences at sentence and line endings;
- [paragraphSplitter](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/paragraphSplitter.html) splits text into a list of paragraphs at line endings; and
- [syllableCounter](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextAnalyzer/syllableCounter.html) returns the number of syllables in a word or text.

The [English]() implementation of [TextAnalyzer]() is included in this library.

#### TextTokenizer

The [TextTokenizer](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextTokenizer-class.html) extracts tokens from text for use in full-text search queries and indexes. It uses a [TextAnalyzer](#textanalyzer) and [token filter](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextTokenizer/tokenFilter.html) in the [tokenize](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextTokenizer/tokenize.html) and [tokenizeJson](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextTokenizer/tokenizeJson.html) methods that return a list of [tokens]() from text or a document. 

An [unnamed factory constructor](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextTokenizer/TextTokenizer.html) hydrates an implementation class.

### TextDocument

The [TextDocument](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextTDocument-class.html) object model enumerates a text document's *paragraphs*, *sentences*, *terms* and *tokens* and provides functions that return text analysis measures:
- [averageSentenceLength](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/averageSentenceLength.html) is the average number of words in [sentences](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/sentences.html);
- [averageSyllableCount](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/averageSyllableCount.html) is the average number of syllables per word in
  [terms](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/terms.html);
- [wordCount](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/wordCount.html) the total number of words in the [sourceText](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/sourceText.html);
- [fleschReadingEaseScore](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/fleschReadingEaseScore.html) is a readibility measure calculated from
  sentence length and word length on a 100-point scale. The higher the
  score, the easier it is to understand the document;
- [fleschKincaidGradeLevel](https://pub.dev/documentation/text_analysis/latest/text_analysis/TextDocument/fleschKincaidGradeLevel.html) is a readibility measure relative to U.S.
  school grade level.  It is also calculated from sentence length and word
  length .

## Definitions

The following definitions are used throughout the [documentation](https://pub.dev/documentation/text_analysis/latest/):
* `corpus`- the collection of `documents` for which an `index` is maintained.
* `character filter` - filters characters from text in preparation of tokenization.  
* `dictionary` - is a hash of `terms` (`vocabulary`) to the frequency of occurence in the `corpus` documents.
* `document` - a record in the `corpus`, that has a unique identifier (`docId`) in the `corpus`'s primary key and that contains one or more text fields that are indexed.
* `document frequency (dFt)` is number of documents in the `corpus` that contain a term.
- `Flesch reading ease score` - a readibility measure calculated from  sentence length and word length on a 100-point scale. The higher the score, the easier it is to understand the document ([Wikipedia(6)](https://en.wikipedia.org/wiki/Flesch%E2%80%93Kincaid_readability_tests)).
- `Flesch-Kincaid grade level` - a readibility measure relative to U.S. school grade level.  It is also calculated from sentence length and word length ([Wikipedia(6)](https://en.wikipedia.org/wiki/Flesch%E2%80%93Kincaid_readability_tests)).
* `index` - an [inverted index](https://en.wikipedia.org/wiki/Inverted_index) used to look up `document` references from the `corpus` against a `vocabulary` of `terms`. 
* `index-elimination` - selecting a subset of the entries in an index where the `term` is in the collection of `terms` in a search phrase.
* `inverse document frequency` or `iDft` is equal to log (N / `dft`), where N is the total number of terms in the index. The `IdFt` of a rare term is high, whereas the `IdFt` of a frequent term is likely to be low.
* `Jaccard index` measures similarity between finite sample sets, and is defined as the size of the intersection divided by the size of the union of the sample sets (from [Wikipedia](https://en.wikipedia.org/wiki/Jaccard_index)).
* `JSON` is an acronym for `"Java Script Object Notation"`, a common format for persisting data.
* `k-gram` - a sequence of (any) k consecutive characters from a `term`. A `k-gram` can start with "$", denoting the start of the term, and end with "$", denoting the end of the term. The 3-grams for "castle" are { $ca, cas, ast, stl, tle, le$ }.
* `lemmatizer` - lemmatisation (or lemmatization) in linguistics is the process of grouping together the inflected forms of a word so they can be analysed as a single item, identified by the word's lemma, or dictionary form (from [Wikipedia](https://en.wikipedia.org/wiki/Lemmatisation)).
* `postings` - a separate index that records which `documents` the `vocabulary` occurs in.  In a positional `index`, the postings also records the positions of each `term` in the `text` to create a positional inverted `index`.
* `postings list` - a record of the positions of a `term` in a `document`. A position of a `term` refers to the index of the `term` in an array that contains all the `terms` in the `text`. In a zoned `index`, the `postings lists` records the positions of each `term` in the `text` a `zone`.
* `term` - a word or phrase that is indexed from the `corpus`. The `term` may differ from the actual word used in the corpus depending on the `tokenizer` used.
* `term filter` - filters unwanted terms from a collection of terms (e.g. stopwords), breaks compound terms into separate terms and / or manipulates terms by invoking a `stemmer` and / or `lemmatizer`.
* `stemmer` -  stemming is the process of reducing inflected (or sometimes derived) words to their word stem, base or root form—generally a written word form (from [Wikipedia](https://en.wikipedia.org/wiki/Stemming)).
* `stopwords` - common words in a language that are excluded from indexing.
* `term frequency (Ft)` is the frequency of a `term` in an index or indexed object.
* `term position` is the zero-based index of a `term` in an ordered array of `terms` tokenized from the `corpus`.
* `text` - the indexable content of a `document`.
* `token` - representation of a `term` in a text source returned by a `tokenizer`. The token may include information about the `term` such as its position(s) (`term position`) in the text or frequency of occurrence (`term frequency`).
* `token filter` - returns a subset of `tokens` from the tokenizer output.
* `tokenizer` - a function that returns a collection of `token`s from `text`, after applying a character filter, `term` filter, [stemmer](https://en.wikipedia.org/wiki/Stemming) and / or [lemmatizer](https://en.wikipedia.org/wiki/Lemmatisation).
* `vocabulary` - the collection of `terms` indexed from the `corpus`.
* `zone` is the field or zone of a document that a term occurs in, used for parametric indexes or where scoring and ranking of search results attribute a higher score to documents that contain a term in a specific zone (e.g. the title rather that the body of a document).

## References

* [Manning, Raghavan and Schütze, "*Introduction to Information Retrieval*", Cambridge University Press, 2008](https://nlp.stanford.edu/IR-book/pdf/irbookprint.pdf)
* [University of Cambridge, 2016 "*Information Retrieval*", course notes, Dr Ronan Cummins, 2016](https://www.cl.cam.ac.uk/teaching/1516/InfoRtrv/)
* [Wikipedia (1), "*Inverted Index*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Inverted_index)
* [Wikipedia (2), "*Lemmatisation*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Lemmatisation)
* [Wikipedia (3), "*Stemming*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Stemming)
* [Wikipedia (4), "*Synonym*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Synonym)
* [Wikipedia (5), "*Jaccard Index*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Jaccard_index)
* [Wikipedia (6), "*Flesch–Kincaid readability tests*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Flesch%E2%80%93Kincaid_readability_tests)

## Issues

If you find a bug please fill an [issue](https://github.com/GM-Consult-Pty-Ltd/text_analysis/issues).  

This project is a supporting package for a revenue project that has priority call on resources, so please be patient if we don't respond immediately to issues or pull requests.

