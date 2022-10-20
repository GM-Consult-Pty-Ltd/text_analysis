// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

/// In grammar, a `part-of-speech` is a category of words that have similar
/// grammatical properties.
///
/// See https://en.wikipedia.org/wiki/Part_of_speech.
enum PartOfSpeech {
  //

  /// Not a part of speech, or unclassified
  none,

  /// Symbol, e.g. $ or @
  symbol,

  /// A graphic depicting an emotion (emoji)
  emoticon,

  /// A word or phrase that describes a numerical quantity.
  ///
  /// Numerals can also be nouns or adjectives.
  numeral,

  /// A word at least partly assimilated from one language (the donor language)
  /// into another language (also known as "loan words").
  borrowed,

  /// A word, phrase, or affix that occurs together with a noun or noun
  /// phrase and generally serves to express the reference of that noun or
  /// noun phrase in the context (`the`, `an`, `this`, `some`, `either`,
  /// `my`, `whose`).
  determiner,

  /// A function word that must be associated with another word or phrase to
  /// impart meaning, i.e., does not have its own lexical definition.
  ///
  /// The term includes the "adverbial particles" like `up` or `out` in verbal
  /// idioms (phrasal verbs) such as "look up" or "knock out"; it also includes
  /// the "infinitival particle" `to`, the "negative particle" `not`, the
  /// "imperative particles" `do` and `let`, and sometimes "pragmatic particles"
  /// (also called "fillers" or "discourse markers") like `oh` and `well`.
  particle,

  //
  /// A word or lexical item denoting any abstract (abstract noun: e.g. `home`)
  /// or concrete entity (concrete noun: e.g. `house`); a person (`police
  /// officer`, `Michael`), place (`coastline`, `London`), thing (`necktie`,
  /// `television`), idea (`happiness`), or quality (`bravery`).
  ///
  /// Nouns can also be classified as count nouns or non-count nouns;
  /// some can belong to either category.
  ///
  /// The most common part of speech, they are called naming words.
  noun,

  /// A substitute for a noun or noun phrase (`them`, `he`).
  ///
  /// Pronouns make sentences shorter and clearer since they replace nouns.
  pronoun,

  /// A modifier of a noun or pronoun (`big`, `brave`).
  ///
  /// Adjectives make the meaning of another word (`noun`) more precise.
  adjective,

  /// A word denoting an action(`walk`), occurrence (`happen`), or state of
  /// being (`be`).
  ///
  /// Without a verb a group of words cannot be a clause or sentence.
  verb,

  /// A modifier of an adjective, verb, or another adverb (`very`, `quite`).
  ///
  /// Adverbs make language more precise.
  adverb,

  /// A word that relates words to each other in a phrase or sentence and
  /// aids in syntactic context (`in`, `of`).
  ///
  /// Prepositions show the relationship between a noun or a pronoun with
  /// another word in the sentence.
  preposition,

  /// A syntactic connector that links words, phrases, or clauses (`and`, `but`).
  ///
  /// Conjunctions connect words or group of words.
  conjunction,

  /// An emotional greeting or exclamation (`Huzzah`, `Alas`).
  ///
  /// Interjections express strong feelings and emotions.
  interjection,

  /// A grammatical marker of definiteness (`the`) or indefiniteness (`a`,
  /// `an`).
  ///
  /// The article is not always listed among the parts of speech. It is
  /// considered by some grammarians to be a type of adjective.
  ///
  /// Sometimes the term `determiner` (a broader class) is used in stead of
  /// `artivle.
  article
}

/// Extensions on the enum [PoSTag].
extension PartOfSpeechExtension on PartOfSpeech {
  //

  /// Lookup map of name to [PoSTag].
  static const _fromName = <String, PartOfSpeech>{
    'none': PartOfSpeech.none,
    'symbol': PartOfSpeech.symbol,
    'emoticon': PartOfSpeech.emoticon,
    'numeral': PartOfSpeech.numeral,
    'borrowed': PartOfSpeech.borrowed,
    'adjective': PartOfSpeech.adjective,
    'adverb': PartOfSpeech.adverb,
    'article': PartOfSpeech.article,
    'conjunction': PartOfSpeech.conjunction,
    'determiner': PartOfSpeech.determiner,
    'interjection': PartOfSpeech.interjection,
    'noun': PartOfSpeech.noun,
    'particle': PartOfSpeech.particle,
    'preposition': PartOfSpeech.preposition,
    'pronoun': PartOfSpeech.pronoun,
    'verb': PartOfSpeech.verb,
  };

  /// Lookup map of JSON representation to [PoSTag].
  static const _fromJson = <String, PartOfSpeech>{
    'PartOfSpeech.none': PartOfSpeech.none,
    'PartOfSpeech.symbol': PartOfSpeech.symbol,
    'PartOfSpeech.emoticon': PartOfSpeech.emoticon,
    'PartOfSpeech.numeral': PartOfSpeech.numeral,
    'PartOfSpeech.borrowed': PartOfSpeech.borrowed,
    'PartOfSpeech.adjective': PartOfSpeech.adjective,
    'PartOfSpeech.adverb': PartOfSpeech.adverb,
    'PartOfSpeech.article': PartOfSpeech.article,
    'PartOfSpeech.conjunction': PartOfSpeech.conjunction,
    'PartOfSpeech.determiner': PartOfSpeech.determiner,
    'PartOfSpeech.interjection': PartOfSpeech.interjection,
    'PartOfSpeech.noun': PartOfSpeech.noun,
    'PartOfSpeech.particle': PartOfSpeech.particle,
    'PartOfSpeech.preposition': PartOfSpeech.preposition,
    'PartOfSpeech.pronoun': PartOfSpeech.pronoun,
    'PartOfSpeech.verb': PartOfSpeech.verb,
  };

  /// Stringifies the enumeration as `runtimeType.name`.
  String toJson() => '$runtimeType.$name';

  /// Parses the string to [PartOfSpeech].
  static PartOfSpeech fromJson(String json) {
    final value = _fromJson[json] ?? _fromName[json];
    if (value != null) return value;
    throw ('Unable to parse $json to [PartOfSpeech]!');
  }
}
