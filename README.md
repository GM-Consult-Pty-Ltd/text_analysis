<!-- 
BSD 3-Clause License
Copyright (c) 2022, GM Consult Pty Ltd
All rights reserved. 
-->

# text_analysis
Text analyzer that extracts tokens from text for use in full-text search queries and indexes.

## Install

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  porter_2_stemmer: ^0.0.2
```

In your code file add the following import:

```dart
import 'package:text_analysis/text_analysis.dart';
```

## Usage

Basic ```English``` text analysis can be performed by using a ```TextAnalyzer``` instance with the default configuration and no token filter, as shown below. 

For more complex requirements, override ```TextAnalyzerConfiguration``` and/or pass in a ```TokenFilter``` function to manipulate the tokens after tokenization.

```dart

/// Import the text_analysis package by adding this line at the top of your
/// code file.
import 'package:text_analysis/text_analysis.dart';

/// For this example are using a few paragraphs of text that contains
/// numbers, currencies, abbreviations, hyphens and identifiers.
const exampleText = [
  'The Dow Jones rallied even as U.S. troops were put on alert amid '
      'the Ukraine crisis. Tesla stock fought back while Apple '
      'stock struggled. ',
  "[TSLA.XNGS] Tesla's #TeslaMotor Stock Is Getting Hammered.",
  'Among the best EV stocks to buy and watch, Tesla (TSLA.XNGS) is pulling back '
      r'from new highs after a failed breakout above a $1,201.05 double-bottom '
      'entry. ',
  'Meanwhile, Peloton reportedly finds an activist investor knocking '
      'on its door after a major stock crash fueled by strong indications of '
      'mismanagement. In a scathing new letter released Monday, activist '
      'Tesla Capital is pushing for Peloton to fire CEO, Chairman and '
      'founder John Foley and explore a sale.'
];

/// Parse the [exampleText] to a [TextSource] that enumerates a collection
/// of [Sentence] objects with their [Token]s
void main() async {
  //

  // Initialize a StringBuffer to hold the source text
  final sourceBuilder = StringBuffer();

  // Concatenate the elements of [text] using line-endings
  for (final src in exampleText) {
    sourceBuilder.writeln(src);
  }

  // convert the StringBuffer to a String
  final source = sourceBuilder.toString();

  // use a TextAnalyzer instance to tokenize the source
  final document = await TextAnalyzer().tokenize(source);

  // map the document's tokens to a list of terms (strings)
  final terms = document.tokens.map((e) => e.term).toList();

  // print the terms
  print(terms);
}

```

## Issues

If you find a bug please fill an [issue](https://github.com/GM-Consult-Pty-Ltd/text_analysis/issues).  

This project is a supporting package for a revenue project that has priority call on resources, so please be patient if we don't respond immediately to issues or pull requests.
