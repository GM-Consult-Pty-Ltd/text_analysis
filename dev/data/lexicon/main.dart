// import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:gmconsult_dev/gmconsult_dev.dart';

const kInputPath = r'dev\data\lexicon\en-lexicon.txt';

const kSavePath = r'dev\data\lexicon\english_lexicon';

const kComments = '// BSD 3-Clause License\n'
    '// Copyright ©2022, GM Consult Pty Ltd\n'
    '// Copyright ©2022, [Princeton University](https://wordnet.princeton.edu/license-and-commercial-use)\n'
    '// All rights reserved\n'
    '\n'
    '/// The lexicon was taken from Brill\'s rule based tagger v1.14,\n'
    '/// trained on Brown corpus and Penn Treebank.\n'
    '/// \n'
    '/// Eric Brill (1992). A simple rule-based part of speech tagger.\n'
    '/// In Proceedings of the workshop on Speech and Natural Language (pp. 112-116).\n'
    '/// Association for Computational Linguistics.\n'
    '/// \n'
    '/// Copyright 1993 by the Massachusetts Institute of Technology and the\n'
    '/// University of Pennsylvania. All rights reserved. MIT license.\n'
    '/// \n'
    '/// Additional words were added from the Twitter Part-of-Speech Annotated Data,\n'
    '/// available under the Creative Commons Attribution 3.0 Unported license ("CC-BY").\n'
    '/// Carnegie Mellon University. http://www.ark.cs.cmu.edu/TweetNLP\n'
    '/// \n'
    '/// Kevin Gimpel, Nathan Schneider, Brendan O\'Connor, et al. (2011).\n'
    '/// Part-of-Speech Tagging for Twitter: Annotation, Features, and Experiments.\n'
    '/// In Proceedings of the Annual Meeting of the ACL, Portland, OR, June 2011.\n'
    '\n'
    '/// English lexicon with Part-of-Speech tags from WordNet® data.\n';

void main() async {
  final json = <String, List<String>>{};
  await File(kInputPath)
      .openRead()
      .map(utf8.decode)
      .transform(LineSplitter())
      .forEach((line) {
    final term = getTerm(line);
    if (term != null) {
      final value = json[term] ?? [];
      final tags = getTags(line);
      if (tags != null) {
        value.addAll(tags);
      }
      json[term] = value.toSet().toList();
      // value.
    }
  });
  final text = jsonToString(json);
  await SaveAs.text(fileName: kSavePath, text: text, extension: 'dart');
}

String jsonToString(Map<String, List<String>> json) {
  final buffer = StringBuffer();
  buffer.write(kComments);

  buffer.write('const englishLexicon = {');
  var i = 0;
  for (final e in json.entries) {
    buffer.writeln(i > 0 ? ', ' : '');
    final key = textToString(e.key);
    final values = tagsToString(e.value);
    buffer.write('$key: [${values.toString()}]');
    i++;
  }
  buffer.write('};');
  return buffer.toString();
}

String tagsToString(Iterable<String> tags) {
  final buffer = StringBuffer();
  var i = 0;
  for (final tag in tags) {
    buffer.write(i > 0 ? ', ' : '');
    buffer.write(textToString(tag));
    i++;
  }
  return buffer.toString();
}

String textToString(String text) =>
    "'${text.replaceAll(r"\", r"\\'").replaceAll("'", r"\'").replaceAll(r'$', r'\$')}'";

Iterable<String>? getTags(String line) {
  final parts = line.split(' ');
  if (parts.length > 1) {
    return parts.last
        .trim()
        .split('|')
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty);
  }
  return null;
}

String? getTerm(String line) {
  if (line.startsWith(';;;')) return null;
  final parts = line.split(' ');
  if (parts.length > 1) {
    final term = line.substring(0, line.length - parts.last.length - 1).trim();
    return term.isNotEmpty ? term : null;
  }
  return null;
}
