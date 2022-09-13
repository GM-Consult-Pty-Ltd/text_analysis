<!-- 
BSD 3-Clause License
Copyright (c) 2022, GM Consult Pty Ltd
All rights reserved. 
-->

# text_analysis

Text analyzer that extracts tokens from text for use in full-text search queries and indexes.

*THIS PACKAGE IS **PRE-RELEASE**, IN ACTIVE DEVELOPMENT AND SUBJECT TO DAILY BREAKING CHANGES.*

## Objective

To tokenize text in preparation of constructing a `dictionary` from a `corpus` of `documents` in an information retrieval system.

The tokenization process comprises the following steps:
* a `term splitter` splits text to a list of terms at appropriate places like white-space and mid-sentence punctuation;
* a `character filter` manipulates terms prior to stemming and tokenization (e.g. changing case and / or removing non-word characters);
* a `term filter` manipulates the terms by splitting compound or hyphenated terms or applying stemming and lemmatization. The `termFilter` can also filter out `stopwords`; and
* the `tokenizer` converts the resulting terms  to a collection of `tokens` that contain the term and a pointer to the position of the term in the source text.

![Text analysis](https://github.com/GM-Consult-Pty-Ltd/text_analysis/raw/main/assets/images/text_analysis.png?raw=true?raw=true "Tokenizing overview")

The design of the text analyzer is consistent with [information retrieval theory](https://nlp.stanford.edu/IR-book/pdf/irbookonlinereading.pdf).

## Definitions

The following definitions are used throughout the [documentation](https://pub.dev/documentation/text_analysis/latest/):

* `corpus`- the collection of `documents` for which an `index` is maintained.
* `character filter` - filters characters from text in preparation of tokenization.  
* `dictionary` - is a hash of `terms` (`vocabulary`) to the frequency of occurence in the `corpus` documents.
* `document` - a record in the `corpus`, that has a unique identifier (`docId`) in the `corpus`'s primary key and that contains one or more text fields that are indexed.
* `index` - an [inverted index](https://en.wikipedia.org/wiki/Inverted_index) used to look up `document` references from the `corpus` against a `vocabulary` of `terms`. The implementation in this package builds and maintains a positional inverted index, that also includes the positions of the indexed `term` in each `document`.
* `lemmatizer` - lemmatisation (or lemmatization) in linguistics is the process of grouping together the inflected forms of a word so they can be analysed as a single item, identified by the word's lemma, or dictionary form (from [Wikipedia](https://en.wikipedia.org/wiki/Lemmatisation)).
* `postings` - a separate index that records which `documents` the `vocabulary` occurs in. In this implementation we also record the positions of each `term` in the `text` to create a positional inverted `index`.
* `postings list` - a record of the positions of a `term` in a `document`. A position of a `term` refers to the index of the `term` in an array that contains all the `terms` in the `text`.
* `term` - a word or phrase that is indexed from the `corpus`. The `term` may differ from the actual word used in the corpus depending on the `tokenizer` used.
* `term filter` - filters unwanted terms from a collection of terms (e.g. stopwords), breaks compound terms into separate terms and / or manipulates terms by invoking a `stemmer` and / or `lemmatizer`.
* `stemmer` -  stemming is the process of reducing inflected (or sometimes derived) words to their word stem, base or root form—generally a written word form (from [Wikipedia](https://en.wikipedia.org/wiki/Stemming)).
* `stopwords` - common words in a language that are excluded from indexing.
* `text` - the indexable content of a `document`.
* `token` - representation of a `term` in a text source returned by a `tokenizer`. The token may include information about the `term` position in the source text.
* `token filter` - returns a subset of `tokens` from the tokenizer output.
* `tokenizer` - a function that returns a collection of `token`s from the terms in a text source after applying a `character filter` and `term filter`.
* `vocabulary` - the collection of `terms` indexed from the `corpus`.

## Interfaces

The package exposes two interfaces:
* the `ITextAnalyzer` interface; and
* the `TextAnalyzerConfiguration` interface.

### Interface `ITextAnalyzer`

The `ITextAnalyzer` is an interface for a text analyser class that extracts tokens from text for use in full-text search queries and indexes

`ITextAnalyzer.configuration` is a `TextAnalyzerConfiguration` used by the [ITextAnalyzer] to tokenize source text.
Provide a `ITextAnalyzer.tokenFilter`  to manipulate tokens or restrict tokenization to tokens that meet criteria for either index or count.

The `tokenize` function tokenizes source text using the `ITextAnalyzer.configuration` and then manipulates the output by applying `ITextAnalyzer.tokenFilter`.

### Interface `TextAnalyzerConfiguration`

The `TextAnalyzerConfiguration` interface exposes language-specific properties and methods used in text analysis: 
* a `TextAnalyzerConfiguration.sentenceSplitter` splits the text at sentence endings such as periods, exclamations and question marks or line endings;
* a `TextAnalyzerConfiguration.termSplitter` to split the text into terms;
* a `TextAnalyzerConfiguration.characterFilter` to remove non-word characters.
* a `TextAnalyzerConfiguration.termFilter` to apply a stemmer/lemmatizer or stopword list.

## Implementations

The `latest version` provides the following implementation classes:
* implementation class `English`, implements `TextAnalyzerConfiguration` and provides text analysis configuration properties for the English language; and
* the `TextAnalyzerBase` abstract class implements `ITextAnalyzer.tokenize`; and
* the `TextAnalyzer` class extends `TextAnalyzerBase` and implements `ITextAnalyzer.tokenFilter` and `ITextAnalyzer.configuration` as final fields with their values passed in as (optional) parameters (with defaults) at initialization.

Refer to the package [API reference](https://pub.dev/documentation/text_analysis/latest/) for more details.

## Usage

Basic English text analysis can be performed by using a `TextAnalyzer` instance with the default configuration and no token filter:

```dart
  /// Use a TextAnalyzer instance to tokenize the [text] using the default 
  /// English configuration.
  final document = await TextAnalyzer().tokenize(text);

```

For more complex requirements, override `TextAnalyzerConfiguration` and/or pass in a `TokenFilter` function to manipulate the tokens after tokenization as shown in the [examples](https://pub.dev/packages/text_analysis/example).

### Install

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  text_analysis: <latest version>
```

In your code file add the following import:

```dart
import 'package:text_analysis/text_analysis.dart';
```

### Examples

[Examples](https://pub.dev/packages/text_analysis/example) are provided. 


## Issues

If you find a bug please fill an [issue](https://github.com/GM-Consult-Pty-Ltd/text_analysis/issues).  

This project is a supporting package for a revenue project that has priority call on resources, so please be patient if we don't respond immediately to issues or pull requests.

## References

* [Manning, Raghavan and Schütze, "*Introduction to Information Retrieval*", Cambridge University Press, 2008](https://nlp.stanford.edu/IR-book/pdf/irbookprint.pdf)
* [University of Cambridge, 2016 "*Information Retrieval*", course notes, Dr Ronan Cummins, 2016](https://www.cl.cam.ac.uk/teaching/1516/InfoRtrv/)
* [Wikipedia (1), "*Inverted Index*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Inverted_index)
* [Wikipedia (2), "*Lemmatisation*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Lemmatisation)
* [Wikipedia (3), "*Stemming*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Stemming)

