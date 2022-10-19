<!-- 
BSD 3-Clause License
Copyright (c) 2022, GM Consult Pty Ltd
All rights reserved. 
-->

## 0.17.0
**BREAKING CHANGES**

### *Breaking changes*
* Added field `TextAnalyzer.spellingKgrams`.

### *New*
* Added function definition `KGramsMap`.
* Added field `English.spellingKgrams`.

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

