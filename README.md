<!-- 
BSD 3-Clause License
Copyright (c) 2022, GM Consult Pty Ltd
All rights reserved. 
-->

# text_analysis

Text analyzer that extracts tokens from text for use in full-text search queries and indexes.

*THIS PACKAGE IS **PRE-RELEASE**, IN ACTIVE DEVELOPMENT AND SUBJECT TO DAILY BREAKING CHANGES.*

Skip to section:
- [Overview](#overview)
- [Usage](#usage)
- [API](#api)
- [Definitions](#definitions)
- [References](#references)
- [Issues](#issues)

## Overview

To tokenize text in preparation of constructing a `dictionary` from a `corpus` of `documents` in an information retrieval system.

The tokenization process comprises the following steps:
* a `term splitter` splits text to a list of terms at appropriate places like white-space and mid-sentence punctuation;
* a `character filter` manipulates terms prior to stemming and tokenization (e.g. changing case and / or removing non-word characters);
* a `term filter` manipulates the terms by splitting compound or hyphenated terms or applying stemming and lemmatization. The `termFilter` can also filter out `stopwords`; and
* the `tokenizer` converts the resulting terms  to a collection of `tokens` that contain the term and a pointer to the position of the term in the source text.

![Text analysis](https://github.com/GM-Consult-Pty-Ltd/text_analysis/raw/main/assets/images/text_analysis.png?raw=true?raw=true "Tokenizing overview")

Refer to the [references](#references) to learn more about information retrieval systems and the theory behind this library.

## Usage

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  text_analysis: <latest version>
```

In your code file add the following import:

```dart
import 'package:text_analysis/text_analysis.dart';
```

Basic English text analysis can be performed by using a `TextAnalyzer` instance with the default configuration and no token filter:

```dart
  /// Use a TextAnalyzer instance to tokenize the [text] using the default 
  /// [English] configuration.
  final document = await TextAnalyzer().tokenize(text);
```

For more complex text analysis:
* implement a `TextAnalyzerConfiguration` for a different language or tokenizing non-language documents;
* implement a custom `ITextAnalyzer`or extend `TextAnalyzerBase`; and/or 
* pass in a `TokenFilter` function to a `TextAnalyzer` to manipulate the tokens after tokenization as shown in the [examples](https://pub.dev/packages/text_analysis/example).

## API

The key members of the `text_analysis` library are briefly described in this section. Please refer to the [documentation](https://pub.dev/documentation/text_analysis/latest/) for details.

Skip to:
- [Type definitions](#type-definitions)
- [Object models](#object-models)
- [Interfaces](#interfaces)
- [Implementation classes](#implementation-classes)

### Type definitions

The following type definitions are included in the `text_analysis` library:
* `CharacterFilter` manipulates terms prior to stemming and tokenization (e.g. changing case and / or removing non-word characters);
* `SentenceSplitter` returns a list of sentences from `text`. In English, the `text` is split at sentence endings marks such as periods, question marks and exclamation marks;
* `TermFilter` manipulates the terms by splitting compound or hyphenated terms or applying stemming and lemmatization. The `termFilter` can also filter out `stopwords`;
* `TermSplitter` splits text to a list of terms at appropriate places like white-space and mid-sentence punctuation;
* `TokenFilter` returns a subset of `tokens` from the tokenizer output; and
* `Tokenizer` converts the resulting terms  to a collection of `tokens` that contain the term and a pointer to the position of the term in the source text.

## Object models

The `text_analysis` library includes the following object-model classes:
* a `Token` represents a `term` (word) present in a `text` source with its `position` and optional `field name`.
* a `Sentence` represents a `text` source not containing sentence ending  punctuation such as periods, question-marks and exclamations, except where  used in tokens, identifiers or other terms; and
* A `TextSource` represents a `text` source that has been analyzed to enumerate `Sentence` and `Token` collections.

### Interfaces

The `text_analysis` library exposes two interfaces:
* the [TextAnalyzerConfiguration](#textanalyzerconfiguration-interface) interface; and 
* the [ITextAnalyzer](#itextanalyzer-interface) interface.

#### TextAnalyzerConfiguration Interface

The `TextAnalyzerConfiguration` interface exposes language-specific properties and methods used in text analysis: 
* a `TextAnalyzerConfiguration.sentenceSplitter` splits the text at sentence endings such as periods, exclamations and question marks or line endings;
* a `TextAnalyzerConfiguration.termSplitter` to split the text into terms;
* a `TextAnalyzerConfiguration.characterFilter` to remove non-word characters.
* a `TextAnalyzerConfiguration.termFilter` to apply a stemmer/lemmatizer or stopword list.

#### ITextAnalyzer Interface

The `ITextAnalyzer` is an interface for a text analyser class that extracts tokens from text for use in full-text search queries and indexes:
* `ITextAnalyzer.configuration` is a `TextAnalyzerConfiguration` used by the `ITextAnalyzer` to tokenize source text.
* Provide a `ITextAnalyzer.tokenFilter`  to manipulate tokens or restrict tokenization to tokens that meet criteria for either index or count; 
* the `ITextAnalyzer.tokenize` function tokenizes text to a `TextSource` object that contains all the `Token`s in the text; and
* the `ITextAnalyzer.tokenizeJson` function tokenizes a JSON hashmap to a `TextSource` object that contains all the `Token`s in the document.

### Implementation classes

The [latest version](https://pub.dev/packages/text_analysis/versions) provides the following implementation classes:
* the [English](#english-class) class implements [TextAnalyzerConfiguration](#textanalyzerconfiguration-interface) and provides text analysis configuration properties for the English language;
* the [TextAnalyzerBase](#textanalyzerbase-class) abstract class implements `ITextAnalyzer.tokenize`; and
* the [TextAnalyzer](#textanalyzer-class) class extends [TextAnalyzerBase](#textanalyzerbase-class)  and implements `ITextAnalyzer.tokenFilter` and `ITextAnalyzer.configuration` as final fields with their values passed in as (optional) parameters (with defaults) at initialization.

#### English class

A basic [TextAnalyzerConfiguration](#textanalyzerconfiguration-interface) implementation for `English` language analysis.

The `termFilter` applies the following algorithm:
* apply the `characterFilter` to the term;
* if the resulting term is empty or contained in `kStopWords`, return an empty collection; else
* insert the filterered term in the return value;
* split the term at commas, periods, hyphens and apostrophes unless preceded and ended by a number;
* if the term can be split, add the split terms to the return value, unless the (split) terms are in `kStopWords` or are empty strings.

The `characterFilter` function:
* returns the term if it can be parsed as a number; else
* converts the term to lower-case;
* changes all quote marks to single apostrophe +U0027;
* removes enclosing quote marks;
* changes all dashes to single standard hyphen;
* removes all non-word characters from the term;
* replaces all characters except letters and numbers from the end of the term.

The `sentenceSplitter` inserts`_kSentenceDelimiter` at sentence breaks and then splits the source text into a list of sentence strings (sentence breaks are characters that match `English.reLineEndingSelector` or `English.reSentenceEndingSelector`). Empty sentences are removed.

#### TextAnalyzerBase Class

The `TextAnalyzerBase` class implements the `ITextAnalyzer.tokenize` method:
* tokenizes source text using the `configuration`;
* manipulates the output by applying `tokenFilter`; and, finally
* returns a `TextSource` enumerating the source text, `Sentence` collection and `Token` collection.

#### TextAnalyzer Class

The `TextAnalyzer` class extends [TextAnalyzerBase](#textanalyzerbase-class):
* implements `configuration` and `tokenFilter` as final fields passed in as optional parameters at instantiation;
* `configuration` is used by the `TextAnalyzer` to tokenize source text and defaults to `English.configuration`; and
* provide nullable function `tokenFilter` if you want to manipulate tokens or restrict tokenization to tokens that meet specific criteria. The default is `TextAnalyzer.defaultTokenFilter`, that applies the`Porter2Stemmer`).

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

## References

* [Manning, Raghavan and Schütze, "*Introduction to Information Retrieval*", Cambridge University Press, 2008](https://nlp.stanford.edu/IR-book/pdf/irbookprint.pdf)
* [University of Cambridge, 2016 "*Information Retrieval*", course notes, Dr Ronan Cummins, 2016](https://www.cl.cam.ac.uk/teaching/1516/InfoRtrv/)
* [Wikipedia (1), "*Inverted Index*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Inverted_index)
* [Wikipedia (2), "*Lemmatisation*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Lemmatisation)
* [Wikipedia (3), "*Stemming*", from Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Stemming)

## Issues

If you find a bug please fill an [issue](https://github.com/GM-Consult-Pty-Ltd/text_analysis/issues).  

This project is a supporting package for a revenue project that has priority call on resources, so please be patient if we don't respond immediately to issues or pull requests.

