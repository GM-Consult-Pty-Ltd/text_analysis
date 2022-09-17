<!-- 
BSD 3-Clause License
Copyright (c) 2022, GM Consult Pty Ltd
All rights reserved. 
-->

### 0.6.4

- **PRE-RELEASE**
- Added `==` operator and `hashCode` getter to `TermPair`.
- Updated documentation.

### 0.6.3

- **PRE-RELEASE**
- Added object model `TermPair`.
- Updated documentation.

### 0.6.2

- **PRE-RELEASE**
- Added extension getter `List<String> get allTerms` on `Iterable<Token>`.
- Updated documentation.
- Codebase formatted.


### 0.6.1
- **PRE-RELEASE**
- Added type aliases to improve code readability.
- Updated documentation.
- Codebase formatted.

### 0.6.0+1
- **PRE-RELEASE**
- Codebase formatted.

### 0.6.0
- **PRE-RELEASE, BREAKING CHANGES**
- *BREAKING CHANGE*: Changed parameters for `JsonTokenizer` type defintion.
- Updated documentation.

### 0.5.0
- **PRE-RELEASE**
- Added `JsonTokenizer` type defintion.
- Updated documentation.


### 0.4.1
- **PRE-RELEASE**
- Added optional, nullable `FieldName? field` optional parameter to `Tokenizer` definition.
- Updated documentation.

### 0.4.0+1

- **PRE-RELEASE**
- Updated documentation.

### 0.4.0

- **PRE-RELEASE, BREAKING CHANGES**
- *BREAKING CHANGE*: added `Token.field` property to token, breaks default generative constructor.
- *BREAKING CHANGE*: added `FieldName? field` optional parameter to `TextAnalyzer.tokenize` method.
- *BREAKING CHANGE*: removed deprecated property `Token.index`, use `Token.termPosition` instead.
- *BREAKING CHANGE*: removed deprecated property `Token.position`, use `Token.termPosition` instead.
- *BREAKING CHANGE*: removed deprecated extension method `Iterable<Token>.maxIndex`, use `Iterable<Token>.`Iterable<Token>.maxIndex`` instead'.
- *BREAKING CHANGE*: removed extension method `Iterable<Token>.minIndex`, use `Iterable<Token>.`Iterable<Token>.firstPosition`` instead'.
- Added new method `ITextAnalyser,tokenizeJson`.
- Added new tests.
- Added new examples.
- Updated documentation.

### 0.3.1

- **PRE-RELEASE**
- Updated package imports.

### 0.3.0+1

- **PRE-RELEASE**
- Updated documentation.

### 0.3.0

- **PRE-RELEASE, BREAKING CHANGES**
- *BREAKING CHANGE*: `TextAnalyzerConfiguration.characterFilter` changed to non-nullable. Use  `(phrase) => phrase` if no `characterFilter` is required.
- *BREAKING CHANGE*: `TextAnalyzerConfiguration.termFilter` changed to non-nullable. Use  `(phrase) => [phrase]` if no `termFilter` is required.
- Added `porter_2_stemmer` package export so it does not need to be imported separately.
- Updated documentation.

### 0.2.0+1

- **PRE-RELEASE**
- Updated documentation.

### 0.2.0

- **PRE-RELEASE**
- Added abstract class `TextAnalyzerBase`.
- Updated documentation.

### 0.1.0+1

- **PRE-RELEASE**
- Updated documentation.

### 0.1.0

- **PRE-RELEASE, BREAKING CHANGES**
- *BREAKING CHANGE*: added `Token.termPosition` property to token, breaks default generative constructor.
- *DEPRECATED* property `Token.index`, use `Token.termPosition` instead.
- *DEPRECATED* property`Token.position`, use `Token.termPosition` instead.
- *DEPRECATED* extension method `Iterable<Token>.maxIndex`.

### 1.0.0+1

- **RETRACTED**
- Updated documentation.

### 1.0.0

- **RETRACTED**
- Updated dependencies.

### 0.0.12+1

- **PRE-RELEASE**
- Updated documentation.

### 0.0.12

- **PRE-RELEASE, BREAKING CHANGES**
- Added == operator to `Token`, `Sentence` and `TextSource`.
- Updated documentation.

### 0.0.11+build.1.e8af2efb

- **PRE-RELEASE**
- Updated documentation.

### 0.0.11

- **PRE-RELEASE**
- Updated documentation.

### 0.0.11-beta.1

- **PRE-RELEASE**
- Updated documentation.

### 0.0.10

- **PRE-RELEASE**
- Latest stable release.
- Updated documentation.

### 0.0.9-beta.1

- **PRE-RELEASE, BREAKING CHANGES**
- BREAKING CHANGE: changed definition of `Token.position`.

### 0.0.8

- **PRE-RELEASE, BREAKING CHANGES**
- BREAKING CHANGE: removed `relevance` extension method from `TokenCollectionExtension`.

### 0.0.7

- **PRE-RELEASE**
- Updated documentation.

### 0.0.6

- **PRE-RELEASE, BREAKING CHANGES**
- Added `TokenCollectionExtension` on `Iterable<Token>`.

### 0.0.5

- **PRE-RELEASE, BREAKING CHANGES**
- BREAKING CHANGE: added `position` property to `Token` class.

### 0.0.4

- **PRE-RELEASE, BREAKING CHANGES**
- Added `Tokenizer` type definition.

### 0.0.3

- **PRE-RELEASE, BREAKING CHANGES**
- BREAKING CHANGE: stemmer removed from English configuration.
- BREAKING CHANGE: stemmer incorporated into default tokenFilter for `TextAnalyzer`.

### 0.0.2

- **PRE-RELEASE**
- Updated documentation.

### 0.0.1-beta.1

- **PRE-RELEASE**
- Initial version.

