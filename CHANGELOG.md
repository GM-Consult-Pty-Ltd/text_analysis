<!-- 
BSD 3-Clause License
Copyright (c) 2022, GM Consult Pty Ltd
All rights reserved. 
-->

## 0.23.0+1

### *Bug fixes*
* Fixed chunking of text to keywords to also chunk at line endings.

### *Updated*
* Dependencies.
* Tests.
* Documentation
* Examples.

## 0.23.0
**BREAKING CHANGES**

### *Breaking changes*
* Added and implemented new field `TextDocument.zones`.

### *New*
* Extension method `String toSourceText([Iterable<Zone>? fieldNames])` on `Map<String, dynamic>`.

### *Updated*
* Dependencies.
* Tests.
* Documentation
* Examples.

## 0.22.0
**BREAKING CHANGES**

### *Breaking changes*
* Added field `TextAnalyzer.phraseSplitter`.
* Added field `TextDocument.keywords`.
* Changed signature of `TextDocument` unnamed factory constructor.
* Moved export of all mixins and base-classes to `implementation` mini-library.
* Changed function definition `TermFilter`.

### *New*
* New enum `TokenizingStrategy`.
* New class `TermCoOccurrenceGraph`.
* New mixin class `LatinLanguageAnalyzerMixin`.
* New type alias `Phrase`.
* New function definition `KeywordExtractor`.
* New extension method `Set<String> toUniqueTerms()` on `Iterable<List<String>>`.
* New extension method `Map<String, List<int>> coOccurenceGraph(List<String> terms)` on `Iterable<List<String>>`.
* Added optional named parameter `TokenizingStrategy strategy` to `TextTokenizer.tokenize` method.
* Added optional named parameter `TokenizingStrategy strategy` to `TextTokenizer.tokenizeJson` method.
* Implemented method `English.KeywordExtractor`.

### *Updated*
* Dependencies.
* Tests.
* Documentation
* Examples.

## 0.21.0
**BREAKING CHANGES**

### *Breaking changes*
* Static method `TextDocument.analyze` signature changed. Default for parameter `nGramRange` changed to `NGramRange(1, 1)`.
* Static method `TextDocument.analyzeJson` signature changed. Default for parameter `nGramRange` changed to `NGramRange(1, 1)`.
* Method `TextTokenize.tokenize` signature changed. Default for parameter `nGramRange` changed to `NGramRange(1, 1)`.
* Method `TextTokenize.tokenizeJson` signature changed. Default for parameter `nGramRange` changed to `NGramRange(1, 1)`.

### *Bug fixes*
* Fixed bugs where n-grams would contain repeated words.

### *Updated*
* Dependencies.
* Tests.
* Documentation
* Examples.

## 0.20.0
**BREAKING CHANGES**

### *Breaking changes*
* Renamed `NGramRange.nMin` to `NGramRange.min`.
* Renamed `NGramRange.nMax` to `NGramRange.max`.
* Changed signature of `TextDocument` unnamed factory.
* Changed signature of `TextDocument.analyze` factory.
* Changed signature of `TextDocument.analyzeJson` factory.
* Removed field `TextDocument.analyzer`.

### *New*
* Implemented `NGramRange.==` and `NGramRange.hashCode`.
* Added extension method `nGrams(NGramRange range)` on `List<String>`.
* Added typedef `NGrammer = List<String> Function(String text, NGramRange range)`.
* Added field `TextAnalyzer.nGrammer`.
* Implemented field `English.nGrammer`.
* Added field `TextDocument.syllableCount`.
* Added field `TextDocument.nGrams`.

### *Updated*
* Dependencies.
* Tests.
* Documentation
* Examples.

## 0.19.0
**BREAKING CHANGES**

### *Breaking changes*
* Changed signature of `TextTokenizer.tokenize`.
* Changed signature of `TextTokenizer.tokenizeJson`.
* Changed `TextTokenizer.tokenize` algorithm to generate an n-gram for each token, using an n-gram range.
* Changed signature of `Token` default constructor by adding unnamed parameter `Token.n`.

### *New*
* Added class `NGramRange`.
* Added field `int Token.n`.
* Added optional named parameter `NGramRange nGramRange = NGramRange(1, 2)` to `TextDocument.analyze` factory.
* Added optional named parameter `NGramRange nGramRange = NGramRange(1, 2)` to `TextDocument.analyzeJson` factory.

### *Updated*
* Dependencies.
* Tests.
* Documentation
* Examples.

## 0.18.0
**BREAKING CHANGES**

### *Breaking changes*
* Removed static method `TermSimilarity.editDistance`.
* Removed static method `TermSimilarity.editSimilarity`.
* Removed static method `TermSimilarity.editSimilaritiesMap`.
* Removed static method `TermSimilarity.lengthDistance`.
* Removed static method `TermSimilarity.lengthSimilarity`.
* Removed static method `TermSimilarity.lengthSimilaritiesMap`.
* Removed static method `TermSimilarity.jaccardSimilarity`.
* Removed static method `TermSimilarity.jaccardSimilaritiesMap`.
* Removed static method `TermSimilarity.termSimilarities`.
* Removed static method `TermSimilarity.termSimilarity`.
* Changed signature of String extension method `termSimilarities`.
* Changed signature of String extension method `termSimilarityMap`.
* Changed signature of String extension method `getSuggestions`.
* Changed signature of String extension method `matches`.
* Changed signature of static method `TermSimilarity.termSimilarities`.
* Changed signature of static method `TermSimilarity.termSimilarityMap`.
* Changed signature of static method `TermSimilarity.getSuggestions`.
* Changed signature of static method `TermSimilarity.matches`.

### *New*
* Added mixin class `TermSimilarityMixin`.
* Added base class `TermSimilarityBase`.
* Added class property `TermSimilarity.term`.
* Added class property `TermSimilarity.other`.
* Added class property `TermSimilarity.editDistance`.
* Added class property `TermSimilarity.editSimilarity`.
* Added class property `TermSimilarity.lengthDistance`.
* Added class property `TermSimilarity.lengthSimilarity`.
* Added class property `TermSimilarity.jaccardSimilarity`.
* Added class property `TermSimilarity.characterSimilarity`.
* Added class property `TermSimilarity.similarity`.
* Added class method `TermSimilarity.toJson()`.
* Added class method `TermSimilarity.compareTo(TermSimilarity other)`.
* Added extension method `sortBySimilarity(bool descending = true)` on `Iterable<TermSimilarity>`.
* Added extension method `limit(int? limit)` on `Iterable<TermSimilarity>`.
* Added extension method `sortBySimilarity(bool descending = true)` on `Iterable<SimilarityIndex>`.
* Added extension method `limit(int? limit)` on `Iterable<SimilarityIndex>`.
* Added unnamed constructor `TermSimilarity`.

### *Updated*
* Dependencies.
* Tests.
* Documentation
* Examples.

## 0.17.1

### *Bug fixes*
* Fixed sorting error in `TermSimilarity.getSuggestions`.

### 0.17.0+1

### *New*
* Implemented `==` and `hashCode` for class `SimilarityIndex`.

## 0.17.0
**BREAKING CHANGES**

### *Breaking changes*
* Changed algorithm for calculating `TermSimilarity.termSimilarity` to apply weighting

### *New*
* Added class `SimilarityIndex`.
* Added String extension method `getSuggestions`.
* Added class method `TermSimilarity.getSuggestions`.
* Added String extension method `lengthSimilarities`.
* Added class method `TermSimilarity.lengthSimilarities`.
* Added String extension method `editSimilarities`.
* Added class method `TermSimilarity.editSimilarities`.
* Added String extension method `jaccardSimilarities`.
* Added class method `TermSimilarity.jaccardSimilarities`.
* Added String extension method `termSimilarities`.
* Added class method `TermSimilarity.termSimilarities`.
* Added function definition `KGramsMap`.
* Added extension `Set<KGram> toKGramsMap([int k = 2])` on `Iterable<String>`.
* Added enumeration `PartOfSpeech`.
* Added enumeration `PoSTag`.

### *Updated*
* Dependencies.
* Tests.
* Documentation
* Examples.

## 0.16.1

### *Updated*
* Dependencies.
* Tests.
* Documentation
* Examples.

## 0.16.0
**BREAKING CHANGES**

### *Breaking changes*
* Removed `stopWords` and `abbreviations` fields from `TextAnalyzer`.
* Changed implementation of `TextTokenizer.tokenize` to match removal of `stopWords` and `abbreviations` from `TextAnalyzer`.
* Moved all constants from `English` to `EnglishConstants`.
* Removed parameters `stemmer`, `lemmatizer`, `stopWords` and `abbreviations` from `English`. Extend the `English` class to use different values for these fields.
* Changed implementation of `English.termSplitter`.
* Changed signature of `TextTokenizer` unnamed factory constructor, now requires `analyzer` parameter.

### *New*
* New mini-library `constants`.
* New extension class on String `EnglishStringExtensions` added to `extensions` mini-library.
* New static const `TextTokenizer.english` shortcut factory method.

### *Bug fixes*
* Fixed handling of accented characters in `English.syllableCounter`.
* Fixed bugs in `English.syllableCounter` to improve accuracy when dealing with hyphenated terms,
abbreviations and apostrophes of contraction.

### *Updated*
* Dependencies.
* Tests.
* Documentation
* Examples.

## 0.15.1+1

### *Updated*
* Dependencies.

## 0.15.1

### *Bug fixes*
* Fixed error thrown in `TermSimilarity.editLength` when terms contained characters other than lower-case letters

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.  

## 0.15.0
**BREAKING CHANGES**

### *Breaking changes*
* Added field `Map<String, String> get abbreviations` to `TextAnalyzer` class.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

### *New*
* Implemented field `English.abbreviations` in `English` class.

## 0.14.0
**BREAKING CHANGES**

### *Breaking changes*
* Removed library `package_exports`. 
* The `Porter2Stemmer` class from the `porter_2_stemmer` package is exported by the `text_indexer` library.
* The `Porter2StemmerExtension` String extension is exported by the `extensions` library.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.13.0
**BREAKING CHANGES**

### *Breaking changes*
* Added field `TextAnalyzer.stemmer` to `TextAnalyzer` class.
* Added field `TextAnalyzer.stopWords` to `TextAnalyzer` class.
* Added field `TextAnalyzer.lemmatizer` to `TextAnalyzer` class.
* Added field `TextAnalyzer.termExceptions` to `TextAnalyzer` class.
* Removed static field `TextTokenizer.defaultTokenFilter`.
* Changed `TextTokenizer.tokenize` method to apply `analyzer.stemmer`, `analyzer.stopWords`, `analyzer.lemmatizer` an `analyzer.termExceptions` to all tokens/terms.

### *New*
* Implemented field `English.stemmer` in `English` class.
* Implemented field `English.stopWords` in `English` class.
* Implemented field `English.lemmatizer` in `English` class.
* Implemented field `English.termExceptions` in `English` class.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.13.0-1
**BREAKING CHANGES**

### *Breaking changes*
* Added field `TextAnalyzer.stemmer` to `TextAnalyzer` class.
* Added field `TextAnalyzer.stopWords` to `TextAnalyzer` class.
* Added field `TextAnalyzer.lemmatizer` to `TextAnalyzer` class.
* Added field `TextAnalyzer.termExceptions` to `TextAnalyzer` class.
* Removed static field `TextTokenizer.defaultTokenFilter`.
* Changed `TextTokenizer.tokenize` method to apply `analyzer.stemmer`, `analyzer.stopWords`, `analyzer.lemmatizer` an `analyzer.termExceptions` to all tokens/terms.

### *New*
* Implemented field `English.stemmer` in `English` class.
* Implemented field `English.stopWords` in `English` class.
* Implemented field `English.lemmatizer` in `English` class.
* Implemented field `English.termExceptions` in `English` class.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.12.1+1

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.12.1

### *New*
* Added extension on String `editDistanceMap`;
* Added method `TermSimilarity.editSimilarityMap`.
* Added method `TermSimilarity.editDistanceMap`.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.12.0
**BREAKING CHANGES**

### *Breaking changes*
* String extensions `extension TermSimilarityExtensions on String` removed from `text_analysis` library. Import the `extensions` library in stead.
* Type definitions removed from `text_analysis` library. Import the `type_definitions` library in stead. 
* Package export `porter_2_stemmer` removed from `text_analysis` library, import the `package_exports` library in stead.
* Changed definition/computation of [lengthDistance].
* Changed definition/computation of [lengthSimilarity].
* Changed definition/computation of [termSimilarity].

### *New*
* Added `int term.editDistance(String other)` extension on String.
* Added `double term.editDistanceSimilarity(String other)` extension on String.
* Added class `TermSimilarity` that exposes static methods for comparing terms.

### *Bug fixes*
* Fixed issue with tokenizer not incrementing term positions

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.12.0-2
**BREAKING CHANGES**

### *Breaking changes*
* String extensions `extension TermSimilarityExtensions on String` removed from `text_analysis` library. Import the `extensions` library in stead.
* Type definitions removed from `text_analysis` library. Import the `type_definitions` library in stead. 
* Package export `porter_2_stemmer` removed from `text_analysis` library, import the `package_exports` library in stead.
* Changed definition/computation of [lengthDistance].
* Changed definition/computation of [lengthSimilarity].
* Changed definition/computation of [termSimilarity].

### *New*
* Added `int term.editDistance(String other)` extension on String.
* Added `double term.editDistanceSimilarity(String other)` extension on String.
* Added class `TermSimilarity` that exposes static methods for comparing terms.

### *Bug fixes*
* Fixed issue with tokenizer not incrementing term positions

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.12.0-1
**BREAKING CHANGES**

### *Breaking changes*
* String extensions `extension TermSimilarityExtensions on String` removed from `text_analysis` library. Import the `extensions` library in stead.
* Type definitions removed from `text_analysis` library. Import the `type_definitions` library in stead. 
* Package export `porter_2_stemmer` removed from `text_analysis` library, import the `package_exports` library in stead.
* Changed definition/computation of [lengthDistance].
* Changed definition/computation of [lengthSimilarity].
* Changed definition/computation of [termSimilarity].

### *New*
* Added `int term.editDistance(String other)` extension on String.
* Added `double term.editDistanceSimilarity(String other)` extension on String.
* Added class `TermSimilarity` that exposes static methods for comparing terms.

### *Bug fixes*
* Fixed issue with tokenizer not incrementing term positions

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.11.2

### *New*
* Added extension on String `List<Term> matches(Iterable<Term> terms, {int k = 2, int limit = 10})`.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.11.1

### *New*
* Added extension on String `double termSimilarity(Term other, [int k = 2])`.
* Added extension on String `double termSimilarity(Term other, [int k = 2])`.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.11.0
**BREAKING CHANGES**

This version sees numerous breaking changes, including the re-naming of the primary interfaces of the library.

### *Breaking changes*

* Renamed `TextAnalyzer` interface to `TextTokenizer`.
* Renamed `TextAnalyzerConfiguration` interface to `TextAnalyzer`.
* Added `SentenceSplitter get sentenceSplitter` to `TextAnalyzer` interface.
* Added `ParagraphSplitter get paragraphSplitter` to `TextAnalyzer` interface.
* Added `SyllableCounter get syllableCounter` to `TextAnalyzer` interface.
* Added `List<String> paragraphs(SourceText source)` to `ITextTokenizer` interface.
* Moved class `TextTokenizer` to a private implementation class `_TextTokenizerImpl` and renamed `ITextTokenizer` interface to `TextTokenizer`.

### *New*
* Added mixin class `TextTokenizerMixin`.
* Added object model `TextDocument`.
* Added typedef `SyllableCounter`.
* Added unnamed factory constructor to `TextTokenizer` that initializes a `_TextTokenizerImpl`.
* Added `SentenceSplitter get sentenceSplitter` to `English` class.
* Added `ParagraphSplitter get paragraphSplitter` to `English` class.
* Added `SyllableCounter get syllableCounter` to `English` class.
* Added `TextDocument` interface.
* Added `TextDocumentMixin` mixin class.
* Added `TextDocument` unnamed factory with private implementation class.
* Added `TextDocument.analyze` factory constructor.
* Added `TextDocument.analyzeJson` factory constructor.
* Added extension on String `double lengthDistance(Term other)`.
* Added extension on String `double lengthSimilarity(Term other)`.
* Added extension on String `Map<Term, double> lengthSimilarityMap(Iterable<Term> terms)`.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    
Re-organized code repository

## 0.10.0
**BREAKING CHANGES**

This version sees numerous breaking changes, including the re-naming of the primary interfaces of the library.

### *Breaking changes*

* Renamed `TextAnalyzer` interface to `TextTokenizer`.
* Renamed `TextAnalyzerConfiguration` interface to `TextAnalyzer`.
* Added `SentenceSplitter get sentenceSplitter` to `TextAnalyzer` interface.
* Added `ParagraphSplitter get paragraphSplitter` to `TextAnalyzer` interface.
* Added `SyllableCounter get syllableCounter` to `TextAnalyzer` interface.
* Added `List<String> paragraphs(SourceText source)` to `ITextTokenizer` interface.
* Moved class `TextTokenizer` to a private implementation class `_TextTokenizerImpl` and renamed `ITextTokenizer` interface to `TextTokenizer`.

### *New*
* Added mixin class `TextTokenizerMixin`.
* Added object model `TextDocument`.
* Added typedef `SyllableCounter`.
* Added unnamed factory constructor to `TextTokenizer` that initializes a `_TextTokenizerImpl`.
* Added `SentenceSplitter get sentenceSplitter` to `English` class.
* Added `ParagraphSplitter get paragraphSplitter` to `English` class.
* Added `SyllableCounter get syllableCounter` to `English` class.
* Added `TextDocument` interface.
* Added `TextDocumentMixin` mixin class.
* Added `TextDocument` unnamed factory with private implementation class.
* Added `TextDocument.analyze` factory constructor.
* Added `TextDocument.analyzeJson` factory constructor.
* Added extension on String `double lengthDistance(Term other)`.
* Added extension on String `double lengthSimilarity(Term other)`.
* Added extension on String `Map<Term, double> lengthSimilarityMap(Iterable<Term> terms)`.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    
* Re-organized code repository.

## 0.9.1

### *New*
* Added extension on String `double jaccardSimilarity(Term other, [int k = 2])`.
* Added extension on String `double jaccardSimilarity(Term other, [int k = 2])`.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.9.0 
**BREAKING CHANGES**

### *Breaking changes*
* Removed class `TextSource`.
* Removed class `Sentence`.
* Removed class `TermPair`.
* Removed `TextAnalyzer.sentenceSplitter` from `TextAnalyzer` interface.
* Changed `TextTokenizer.tokenize` return value to `List<Token>`.
* Changed `TextTokenizer.tokenizeJson` return value to `List<Token>`.

## 0.8.1 
**PRE-RELEASE, BUG FIX**

### *Bug fixes*
* Fixed `TextTokenizerBase.tokenizeJson` would not tokenize documents if `Iterable<Zone> zones` parameter is empty.

### Non-breaking Changes:
* `TextTokenizerBase.tokenizeJson` required non-nullable parameter `Iterable<Zone> zones` to optional nullable `[Iterable<Zone>? zones]`.

## 0.8.0 
**PRE-RELEASE, BREAKING CHANGES**

### *Breaking changes*
* Added type definitions for `kGram` and `Trigram`.
* New extension method `Set<kGram> Term.kGrams([int k = 2])`.
* New extension method `Set<kGram> Iterable<Token>.kGrams([int k = 2])`.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.7.0 
**PRE-RELEASE, BREAKING CHANGES**

### *Breaking changes*
* Renamed `FieldName` type alias to `Zone`.
* Renamed parameter `FieldName? field` to `Zone? zone` wherever it is used. 

### *New*
* Type alias `IdFt`.
* Type alias `Ft`.
* Type alias `ZoneWeightMap`.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.6.5+1
**PRE-RELEASE** 

Minor bug fixes, updated dependencies, tests, examples and documentation.

## 0.6.5
**PRE-RELEASE**

### *New*
* Added custom implementation of `TermPair.toString()`.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.6.4
**PRE-RELEASE**

### *New*
* Added `==` operator and `hashCode` getter to `TermPair`.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.6.3
**PRE-RELEASE**

### *New*
* Added object model `TermPair`.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.6.2
**PRE-RELEASE**

### *New*
* Added extension getter `List<String> get allTerms` on `Iterable<Token>`.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.6.1
**PRE-RELEASE**

* Added type aliases to improve code readability.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.6.0+1
**PRE-RELEASE**

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation. 
* Codebase formatted.   

## 0.6.0 
**PRE-RELEASE, BREAKING CHANGES**

### *Breaking changes*
* Changed parameters for `JsonTokenizer` type defintion.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.5.0
**PRE-RELEASE**

### *New*
* Added `JsonTokenizer` type defintion.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.4.1
**PRE-RELEASE**

### *New*
* Added optional, nullable `FieldName? field` optional parameter to `Tokenizer` definition.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.4.0+1
**PRE-RELEASE**
 
### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.4.0 
**PRE-RELEASE, BREAKING CHANGES**

### *Breaking changes*
* Added `Token.field` property to token, breaks default generative constructor.
* Added `FieldName? field` optional parameter to `TextTokenizer.tokenize` method.
* Removed deprecated property `Token.index`, use `Token.termPosition` instead.
* Removed deprecated property `Token.position`, use `Token.termPosition` instead.
* Removed deprecated extension method `Iterable<Token>.maxIndex`, use `Iterable<Token>.`Iterable<Token>.maxIndex`` instead'.
* Removed extension method `Iterable<Token>.minIndex`, use `Iterable<Token>.`Iterable<Token>.firstPosition`` instead'.

### *New*
* Added new method `ITextAnalyser,tokenizeJson`.
* Added new tests.
* Added new examples.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.3.1
**PRE-RELEASE**

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.3.0+1
**PRE-RELEASE**

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.3.0 
**PRE-RELEASE, BREAKING CHANGES**

### *Breaking changes*
* `TextAnalyzer.characterFilter` changed to non-nullable. Use  `(phrase) => phrase` if no `characterFilter` is required.
* `TextAnalyzer.termFilter` changed to non-nullable. Use  `(phrase) => [phrase]` if no `termFilter` is required.

### *New*
* Added `porter_2_stemmer` package export so it does not need to be imported separately.
 
### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.2.0+1
**PRE-RELEASE**

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.2.0
**PRE-RELEASE**

### *New*
* Added abstract class `TextTokenizerBase`.
 
### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.1.0+1
**PRE-RELEASE**

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.1.0 
**PRE-RELEASE, BREAKING CHANGES** 

### *Breaking changes*
* Added `Token.termPosition` property to token, breaks default generative constructor.

### Deprecated:
* Property `Token.index`, use `Token.termPosition` instead.
* Property`Token.position`, use `Token.termPosition` instead.
* Extension method `Iterable<Token>.maxIndex`.

## 1.0.0+1
**PRE-RELEASE**

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 1.0.0
**PRE-RELEASE**

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.0.12+1
**PRE-RELEASE**
 
### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.0.12 
**PRE-RELEASE**

### *New*
* Added == operator to `Token`, `Sentence` and `TextSource`.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.0.11+build.1.e8af2efb

* **PRE-RELEASE**

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.0.11
**PRE-RELEASE**

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.0.11-beta.1
**PRE-RELEASE**

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.0.10
**PRE-RELEASE**

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.0.9-beta.1

### *Breaking changes*
* Changed definition of `Token.position`.

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.0.8 
**PRE-RELEASE, BREAKING CHANGES**

### *Breaking changes*
* Removed `relevance` extension method from `TokenCollectionExtension`.

## 0.0.7
**PRE-RELEASE**
 
### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.0.6 
**PRE-RELEASE, BREAKING CHANGES**

### *New*
* Added `TokenCollectionExtension` on `Iterable<Token>`.

## 0.0.5 
**PRE-RELEASE, BREAKING CHANGES**

### *Breaking changes*
* added `position` property to `Token` class.

## 0.0.4 
**PRE-RELEASE, BREAKING CHANGES**

### *New*
* Added `Tokenizer` type definition.

## 0.0.3 
**PRE-RELEASE, BREAKING CHANGES**

### *Breaking changes*
* Stemmer removed from English configuration.
* Stemmer incorporated into default tokenFilter for `TextTokenizer`.

## 0.0.2 
**PRE-RELEASE, BREAKING CHANGES**

### *Updated*
* Dependencies.
* Tests.
* Examples.
* Documentation.    

## 0.0.1-beta.1
**PRE-RELEASE**

Initial version.

