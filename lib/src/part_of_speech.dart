// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

/// In grammar, a `part-of-speech` is a category of words that have similar
/// grammatical properties.
///
/// See https://en.wikipedia.org/wiki/Part_of_speech.
enum PartOfSpeech {
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
