// Copyright ©2022, GM Consult (Pty) Ltd,
// Copyright ©2022, [Princeton University](https://wordnet.princeton.edu/license-and-commercial-use)
// Copyright ©2022, the [NLTK team](https://github.com/nltk/nltk/blob/develop/LICENSE.txt).
// BSD 3-Clause License, Apache License
// All rights reserved

import 'part_of_speech.dart';

// ignore_for_file: constant_identifier_names

/// Part of speech tags are used in natural language processing as part of
/// `Part-of-Speech tagging`.
///
/// Part-of-Speech (PoS) tagging is the task of labelling every word in a
/// sequence of words with a tag indicating what lexical syntactic category it
/// assumes in the given sequence.
///
/// The tags adopted here are those used in the [WordNet®](https://wordnet.princeton.edu/)
/// lexical database of English as implemented in the [NTLK python library ](https://www.nltk.org/index.html).
///
/// - Copyright ©2022, [Princeton University](https://wordnet.princeton.edu/license-and-commercial-use)
/// - Copyright ©2022, the [NLTK team](https://github.com/nltk/nltk/blob/develop/LICENSE.txt).
enum PoSTag {
  /// Coordinating conjunction (conjunction)
  CC,

  /// Cardinal numeral (numeral)
  CD,

  /// Determiner (determiner)
  DT,

  /// Existential there (like: “there is” … think of it like “there exists”) (adverb)
  EX,

  /// Foreign word (borrowed)
  FW,

  /// Preposition/subordinating conjunction (conjunction)
  IN,

  /// Adjective ‘big’ (adjective)
  JJ,

  /// Adjective, comparative ‘bigger’ (adjective)
  JJR,

  /// Adjective, superlative ‘biggest’ (adjective)
  JJS,

  /// List marker 1) (symbol)
  LS,

  /// Modal could, will (verb)
  MD,

  /// Noun, singular ‘desk’ (noun)
  NN,

  /// Noun plural ‘desks’ (noun)
  NNS,

  /// Proper noun, singular ‘Harrison’ (noun)
  NNP,

  /// Proper noun, plural ‘Americans’ (noun)
  NNPS,

  /// Predeterminer ‘all the kids’ (determiner)
  PDT,

  /// Possessive ending parent’s (noun)
  POS,

  /// Personal pronoun I, he, she (pronoun)
  PRP,

  /// Possessive pronoun my, his, hers (pronoun)
  PRP$,

  /// Adverb very, silently, (adverb)
  RB,

  /// Adverb, comparative better (adverb)
  RBR,

  /// Adverb, superlative best (adverb)
  RBS,

  /// Particle give up (particle)
  RP,

  /// To go ‘to’ the store. (preposition)
  TO,

  /// Interjection, errrrrrrrm (interjection)
  UH,

  /// Verb, base form take (verb)
  VB,

  /// Verb, past tense took (verb)
  VBD,

  /// Verb, gerund/present participle taking (verb)
  VBG,

  /// Verb, past participle taken (verb)
  VBN,

  /// Verb, sing. present, non-3d take (verb)
  VBP,

  /// Verb, 3rd person sing. present takes (verb)
  VBZ,

  /// Wh-determiner which (determiner)
  WDT,

  /// Wh-pronoun who, what (pronoun)
  WP,

  /// Possessive wh-pronoun whose (pronoun)
  WP$,

  /// Wh-abverb where, when (abverb)
  WRB,
}

/// Extensions on the enum [PoSTag].
extension PoSTagExtension on PoSTag {
  //

  /// Lookup map of [PoSTag] to [PartOfSpeech].
  static const _posMap = <PoSTag, PartOfSpeech>{
    PoSTag.CC: PartOfSpeech.conjunction,
    PoSTag.CD: PartOfSpeech.numeral,
    PoSTag.DT: PartOfSpeech.determiner,
    PoSTag.EX: PartOfSpeech.adverb,
    PoSTag.FW: PartOfSpeech.borrowed,
    PoSTag.IN: PartOfSpeech.conjunction,
    PoSTag.JJ: PartOfSpeech.adjective,
    PoSTag.JJR: PartOfSpeech.adjective,
    PoSTag.JJS: PartOfSpeech.adjective,
    PoSTag.LS: PartOfSpeech.symbol,
    PoSTag.MD: PartOfSpeech.verb,
    PoSTag.NN: PartOfSpeech.noun,
    PoSTag.NNS: PartOfSpeech.noun,
    PoSTag.NNP: PartOfSpeech.noun,
    PoSTag.NNPS: PartOfSpeech.noun,
    PoSTag.PDT: PartOfSpeech.determiner,
    PoSTag.POS: PartOfSpeech.noun,
    PoSTag.PRP: PartOfSpeech.pronoun,
    PoSTag.PRP$: PartOfSpeech.pronoun,
    PoSTag.RB: PartOfSpeech.adverb,
    PoSTag.RBR: PartOfSpeech.adverb,
    PoSTag.RBS: PartOfSpeech.adverb,
    PoSTag.RP: PartOfSpeech.particle,
    PoSTag.TO: PartOfSpeech.preposition,
    PoSTag.UH: PartOfSpeech.interjection,
    PoSTag.VB: PartOfSpeech.verb,
    PoSTag.VBD: PartOfSpeech.verb,
    PoSTag.VBG: PartOfSpeech.verb,
    PoSTag.VBN: PartOfSpeech.verb,
    PoSTag.VBP: PartOfSpeech.verb,
    PoSTag.VBZ: PartOfSpeech.verb,
    PoSTag.WDT: PartOfSpeech.determiner,
    PoSTag.WP: PartOfSpeech.pronoun,
    PoSTag.WP$: PartOfSpeech.pronoun,
    PoSTag.WRB: PartOfSpeech.adverb,
  };

  /// Lookup map of name to [PoSTag].
  static const _fromName = <String, PoSTag>{
    'CC': PoSTag.CC,
    'CD': PoSTag.CD,
    'DT': PoSTag.DT,
    'EX': PoSTag.EX,
    'FW': PoSTag.FW,
    'IN': PoSTag.IN,
    'JJ': PoSTag.JJ,
    'JJR': PoSTag.JJR,
    'JJS': PoSTag.JJS,
    'LS': PoSTag.LS,
    'MD': PoSTag.MD,
    'NN': PoSTag.NN,
    'NNS': PoSTag.NNS,
    'NNP': PoSTag.NNP,
    'NNPS': PoSTag.NNPS,
    'PDT': PoSTag.PDT,
    'POS': PoSTag.POS,
    'PRP': PoSTag.PRP,
    r'PRP$': PoSTag.PRP$,
    'RB': PoSTag.RB,
    'RBR': PoSTag.RBR,
    'RBS': PoSTag.RBS,
    'RP': PoSTag.RP,
    'TO': PoSTag.TO,
    'UH': PoSTag.UH,
    'VB': PoSTag.VB,
    'VBD': PoSTag.VBD,
    'VBG': PoSTag.VBG,
    'VBN': PoSTag.VBN,
    'VBP': PoSTag.VBP,
    'VBZ': PoSTag.VBZ,
    'WDT': PoSTag.WDT,
    'WP': PoSTag.WP,
    r'WP$': PoSTag.WP$,
    'WRB': PoSTag.WRB,
  };

  /// Lookup map of JSON representation to [PoSTag].
  static const _fromJson = <String, PoSTag>{
    'PoSTag.CC': PoSTag.CC,
    'PoSTag.CD': PoSTag.CD,
    'PoSTag.DT': PoSTag.DT,
    'PoSTag.EX': PoSTag.EX,
    'PoSTag.FW': PoSTag.FW,
    'PoSTag.IN': PoSTag.IN,
    'PoSTag.JJ': PoSTag.JJ,
    'PoSTag.JJR': PoSTag.JJR,
    'PoSTag.JJS': PoSTag.JJS,
    'PoSTag.LS': PoSTag.LS,
    'PoSTag.MD': PoSTag.MD,
    'PoSTag.NN': PoSTag.NN,
    'PoSTag.NNS': PoSTag.NNS,
    'PoSTag.NNP': PoSTag.NNP,
    'PoSTag.NNPS': PoSTag.NNPS,
    'PoSTag.PDT': PoSTag.PDT,
    'PoSTag.POS': PoSTag.POS,
    'PoSTag.PRP': PoSTag.PRP,
    r'PoSTag.PRP$': PoSTag.PRP$,
    'PoSTag.RB': PoSTag.RB,
    'PoSTag.RBR': PoSTag.RBR,
    'PoSTag.RBS': PoSTag.RBS,
    'PoSTag.RP': PoSTag.RP,
    'PoSTag.TO': PoSTag.TO,
    'PoSTag.UH': PoSTag.UH,
    'PoSTag.VB': PoSTag.VB,
    'PoSTag.VBD': PoSTag.VBD,
    'PoSTag.VBG': PoSTag.VBG,
    'PoSTag.VBN': PoSTag.VBN,
    'PoSTag.VBP': PoSTag.VBP,
    'PoSTag.VBZ': PoSTag.VBZ,
    'PoSTag.WDT': PoSTag.WDT,
    'PoSTag.WP': PoSTag.WP,
    r'PoSTag.WP$': PoSTag.WP$,
    'PoSTag.WRB': PoSTag.WRB,
  };

  /// Stringifies the enumeration as `runtimeType.name`.
  String toJson() => '$runtimeType.$name';

  /// Parses the string to [PoSTag].
  static PoSTag fromJson(String json) {
    final value = _fromJson[json] ?? _fromName[json];
    if (value != null) return value;
    throw ('Unable to parse $json to [PoSTag]!');
  }

  /// Returns the [PartOfSpeech] for the [PoSTag].
  PartOfSpeech get partOfSpeech => _posMap[this] ?? PartOfSpeech.none;
}
