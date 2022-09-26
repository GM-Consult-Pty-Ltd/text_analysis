// BSD 3-Clause License
// Copyright (c) 2022, GM Consult Pty Ltd

import 'package:text_analysis/text_analysis.dart';

/// A basic [TextAnalyzer] implementation for [English] language
/// analysis.
///
/// The [termFilter] applies the following algorithm:
/// - apply the [characterFilter] to the term;
/// - if the resulting term is empty or contained in [kStopWords], return an
///   empty collection; else
/// - insert the filterered term in the return value;
/// - split the term at commas, periods, hyphens and apostrophes unless
///   preceded and ended by a number;
/// - if the term can be split, add the split terms to the return value,
///   unless the (split) terms are in [kStopWords] or are empty strings.
///
/// The [characterFilter] function:
/// - returns the term if it can be parsed as a number; else
/// - converts the term to lower-case;
/// - changes all quote marks to single apostrophe +U0027;
/// - removes enclosing quote marks;
/// - changes all dashes to single standard hyphen;
/// - removes all non-word characters from the term;
/// - replaces all characters except letters and numbers from the end of
///   the term.
///
/// Empty strings are removed from the returned collection.
class English implements TextAnalyzer {
  //

  /// A const constructor to allow an instance to be used as default.
  const English();

  /// Instantiates a static const [English] instance.
  static const configuration = English();

  /// Applies the following algorithm to convert a term to a list
  /// of strings:
  /// - apply the [characterFilter] to term;
  /// - if the resulting term is empty or contained in [kStopWords]
  ///   return an empty collection; else
  /// - insert the filterered term in the return value;
  /// - split the term at commas, periods, hyphens and apostrophes unless
  ///   preceded and ended by a number;
  /// - if the term can be split, add the split terms to the return value,
  ///   unless the (split) terms are in [kStopWords] or are empty strings.
  @override
  TermFilter get termFilter => (Term term) async {
        // apply the [characterFilter] to [term]
        if (kAbbreviations.contains(term)) {
          return [term, term.replaceAll('.', '')];
        }
        term = cleanTerm(term);
        // if the resulting [term] is shorter than 2 characters or contained
        // in [kStopWords] return an empty collection
        if (kStopWords.contains(term) || term.length < 2) {
          return [];
        }

        // - insert [term] in the return value
        final terms = {term};

        // insert an unhyphenated version if necessary
        if (term.contains('-')) {
          final unHyphenated = term.replaceAll('-', '');
          if (unHyphenated.isNotEmpty) {
            terms.add(unHyphenated);
          }
        }

        // split at all non-word characters unless preceded and ended by a number.
        final splitTerms =
            term.split(RegExp(r'(?<=[a-zA-Z])[^a-zA-Z0-9]+(?=[a-zA-Z])'));
        if (splitTerms.length > 1) {
          for (var splitTerm in splitTerms) {
            if (splitTerm.isNotEmpty) {
              splitTerm = characterFilter(splitTerm)
                  .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                  .trim();
              if (!kStopWords.contains(splitTerm) && splitTerm.length > 1) {
                terms.add(splitTerm);
              }
            }
          }
        } else {
          final alpha = characterFilter(term)
              .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
              .trim();
          if (alpha.isNotEmpty) {
            terms.add(alpha);
          }
        }
        return terms.toList();
      };

  /// The [English] implementation of the [characterFilter] function:
  /// - returns the term if it can be parsed as a number; else
  /// - converts the term to lower-case;
  /// - changes all quote marks to single apostrophe +U0027;
  /// - removes enclosing quote marks;
  /// - changes all dashes to single standard hyphen;
  /// - removes all non-word characters from the term;
  /// - replaces all characters except letters and numbers from the end of
  ///   the term.
  @override
  CharacterFilter get characterFilter => (Term term) {
        // try parsing the term to a number
        final number = num.tryParse(term);
        // return the term if it can be parsed as a number
        return number != null
            // return number.toString() if number is not null.
            ? number.toString()
            // if the term is all-caps return it unchanged.
            : term
                // convert to lower-case
                .toLowerCase()
                // change all quote marks to single apostrophe +U0027
                .replaceAll(RegExp('[\'"“”„‟’‘‛]+'), "'")
                // remove enclosing quote marks
                .replaceAll(RegExp(r"(^'+)|('+(?=$))"), '')
                // change all dashes to single standard hyphen
                .replaceAll(RegExp(r'[\-—]+'), '-')
                // remove all non-word characters
                .replaceAll(RegExp(r"[^0-9a-z,.\-'\$£₤#@]"), '')
                // remove all characters except letters and numbers at end
                // of term
                .replaceAll(RegExp(r'[^0-9a-z](?=$)'), '')
                .trim();
      };

  /// Cleans the term as follows:
  /// - change all quote marks to single apostrophe +U0027;
  /// - remove enclosing quote marks;
  /// - hange all dashes to single standard hyphen;
  /// - remove all characters except letters and numbers at end of term
  Term cleanTerm(Term term) => term
      .toLowerCase()
      // change all quote marks to single apostrophe +U0027
      .replaceAll(RegExp('[\'"“”„‟’‘‛]+'), "'")
      // remove enclosing quote marks
      .replaceAll(RegExp(r"(^'+)|('+(?=$))"), '')
      // change all dashes to single standard hyphen
      .replaceAll(RegExp(r'[\-—]+'), '-')
      // remove all characters except letters and numbers at end of term
      .replaceAll(RegExp(r'[^0-9a-z](?=$)'), '')
      .trim();

  /// The [English] implemenation of [termSplitter] replaces all text that
  /// matches [English.rePunctuationSelector] or [English.reBracketsAndCarets]
  /// with a single space character.
  ///
  /// Repeated white-space characters are also replaced with a single space
  /// character.
  ///
  /// The text is then split into terms at all space characters.
  ///
  /// Leading and trailing white-space is trimmed from all terms.
  ///
  /// Unless a term matches any of [English.kAbbreviations], any characters
  /// matching [English.reNonWordChars] is trimmed from the end of the term.
  ///
  /// Empty strings are removed from the returned terms.
  @override
  TermSplitter get termSplitter => (SourceText source) {
        // replace all punctuation with whitespace.
        source = source
            .replaceAll(RegExp(English.reSentenceEndingSelector), ' ')
            .replaceAll(RegExp(English.rePunctuationSelector), ' ')
            // replace all brackets and carets with _kTokenDelimiter.
            .replaceAll(RegExp(English.reBracketsAndCarets), ' ')
            // replace all repeated white-space with a single white-space.
            .replaceAll(RegExp(r'(\s{2,})'), ' ');
        // split at white-space
        final terms = source.split(RegExp(r'(\s+)')).map((e) {
          e = e.trim();
          if (kAbbreviations.contains(e)) {
            return e;
          }
          return e
              .trim()
              .replaceAll(RegExp('${English.reNonWordChars}(?=\$)'), '')
              .trim();
        })
            // convert to list
            .toList();
        terms.removeWhere((element) => element.isEmpty);
        return terms;
      };

  /// The delimiter inserted at sentence endings to allow splitting of the text
  /// into sentences.
  static const _kSentenceDelimiter = r'%~%';

  /// The [English] implementation of [sentenceSplitter] inserts
  /// [_kSentenceDelimiter] at sentence breaks and then splits the source text
  /// into a list of sentence strings.
  ///
  /// Sentence breaks are characters that match [English.reLineEndingSelector]
  /// or [English.reSentenceEndingSelector].
  ///
  /// Empty strings are removed from the returned collection.
  @override
  SentenceSplitter get sentenceSplitter => (SourceText source) {
        // insert the sentence delimiters at sentence breaks
        source = source
            // trim leading and trailing white-space from source
            .trim()
            // replace line feeds and carriage returns with %~%
            .replaceAll(
                RegExp(English.reLineEndingSelector), _kSentenceDelimiter)
            // select all sentences and replace the ending punctuation with %~%
            .replaceAllMapped(RegExp(English.reSentenceEndingSelector),
                (match) {
          final sentence = match.group(0) ?? '';
          // remove white-space before delimiter
          return '$sentence$_kSentenceDelimiter'
              .replaceAll(RegExp(r'(\s+)(?=%~%)'), _kSentenceDelimiter);
        });
        // split into sentence strings
        final sources = source
            // split at _kSentenceDelimiter
            .split(RegExp(_kSentenceDelimiter));
        final sentences = <String>[];
        for (final e in sources) {
          // trim leading and trailing white-space from all elements
          final sentence = e
              .trim()
              .replaceAll(RegExp(English.reSentenceEndingSelector), '')
              .trim();
          // add only non-empty sentences
          if (sentence.isNotEmpty) {
            sentences.add(sentence);
          }
        }
        // return the sentences
        return sentences;
      };

  /// Returns a list of paragraphs from text.
  @override
  ParagraphSplitter get paragraphSplitter => ((source) {
        final sentences = source.trim().split(RegExp(reLineEndingSelector));
        final retVal = <String>[];
        for (final e in sentences) {
          final sentence = e.trim();
          if (sentence.isNotEmpty) {
            retVal.add(sentence);
          }
        }
        return retVal;
      });

  @override
  SyllableCounter get syllableCounter => (term) {
        //
        term = term.trim();
        // return 0 if term is empty
        if (term.isEmpty) {
          return 0;
        }
        var count = 0;
        // uses the termSplitter to split [term] into terms at whitespace and punctuation
        // applies the Porter2Stemmer to each element of terms
        // joins all the stemmed terms into one string
        final terms = termSplitter(term);
        // count apostropied syllables like "d'Azure" and remove the
        // apostrophied prefix
        for (var e in terms) {
          e = e.replaceAllMapped(RegExp(r"(?<=\b)([a-zA-Z]')"), (match) {
            count++;
            return '';
          });
          // stem the remaining term
          e = e.stemPorter2();
          // check for terms with capitals or remaining punctuation
          if (e.toUpperCase() == e) {
            // this is more than likely an acronym, so add 1
            count++;
          } else if (kAbbreviations.contains(e) ||
              e.contains(RegExp(r'[^a-z]'))) {
            // still has non-letters, let's split it and get the syllables for
            // each sub-term
            final subTerms = e.split(RegExp('[^a-zA-Z]+'));
            for (final es in subTerms) {
              count += syllableCounter(es.trim());
            }
          } else {
            // add all the vowels, diphtongs and triptongs. As e has been stemmed,
            // we know trailing silent e's have been removed and vowel "y"s
            //converted to "i"
            term = term.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
            if (term.contains(RegExp(r"[^aeiou\s\-\']+(?=\b)"))) {
              count += RegExp(r'[aeiouy]+').allMatches(term).length;
            } else {
              count += RegExp(r'[aeiou]+').allMatches(e).length;
              // check for stemmed words ending in 3 or more consonants
              count += e.contains(RegExp(r"[^aeiou\s\-\']{3,}(?=\b)")) ? 1 : 0;
            }
          }
        }

        // termSplitter(term).map((e) {
        //   // count apostropied syllables like "d'Azure" and remove the
        //   // apostrophied prefix
        //   e = e.replaceAllMapped(RegExp(r"(?<=\b)([a-zA-Z]')"), (match) {
        //     count++;
        //     return '';
        //   });
        //   // stem the remaining term
        //   e = e.stemPorter2();
        //   // add all the vowels, diphtongs and triptongs. As e has been stemmed,
        //   // we know trailing silent e's have been removed and vowel "y"s
        //   //converted to "i"
        //   count += RegExp(r'[aeiou]+').allMatches(e).length;
        //   return e;
        // });
        // if count is 0, return 1 because a word must have at least one syllable
        return count < 1 ? 1 : count;
      };

  /// Matches all brackets and carets.
  static const reBracketsAndCarets = r'\(|\)|\[|\]|\{|\}|\<|\>';

  /// A collection of stop-words excluded from tokenization.
  static const kStopWords = {
    'a',
    'about',
    'above',
    'across',
    'after',
    'against',
    'all',
    'along',
    'although',
    'among',
    'an',
    'and',
    'another',
    'any',
    'anybody',
    'anyone',
    'anything',
    'anywhere',
    'are',
    'around',
    'as',
    'at',
    'aught',
    'be',
    'because',
    'before',
    'behind',
    'between',
    'beyond',
    'both',
    'but',
    'by',
    'case',
    'certain',
    'concerning',
    'despite',
    'down',
    'during',
    'each',
    'either',
    'enough',
    'even',
    'event',
    'every',
    'everybody',
    'everyone',
    'everything',
    'everywhere',
    'except',
    'few',
    'fewer',
    'fewest',
    'following',
    'for',
    'from',
    'he',
    'her',
    'hers',
    'herself',
    'him',
    'himself',
    'his',
    'I',
    'idem',
    'if',
    'in',
    'including',
    'into',
    'is',
    'it',
    'its',
    'itself',
    'last',
    'least',
    'less',
    'lest',
    'like',
    'little',
    'long',
    'many',
    'mine',
    'more',
    'most',
    'much',
    'naught',
    'near',
    'neither',
    'next',
    'no',
    'nobody',
    'none',
    'nor',
    'not',
    'nothing',
    'nought',
    'now',
    'nowhere',
    'of',
    'off',
    'on',
    'once',
    'one',
    'only',
    'onto',
    'or',
    'order',
    'other',
    'others',
    'ought',
    'our',
    'ours',
    'ourself',
    'ourselves',
    'out',
    'over',
    'past',
    'plus',
    'provided',
    'said',
    'several',
    'she',
    'since',
    'so',
    'some',
    'somebody',
    'someone',
    'something',
    'somewhat',
    'somewhere',
    'soon',
    'such',
    'suchlike',
    'sufficient',
    'supposing',
    'than',
    'that',
    'the',
    'thee',
    'their',
    'theirs',
    'theirself',
    'theirselves',
    'them',
    'themself',
    'themselves',
    'there',
    'these',
    'they',
    'thine',
    'this',
    'those',
    'thou',
    'though',
    'throughout',
    'thy',
    'thyself',
    'till',
    'time',
    'to',
    'towards',
    'under',
    'unless',
    'until',
    'up',
    'upon',
    'us',
    'was',
    'we',
    'were',
    'what',
    'whatever',
    'whatnot',
    'whatsoever',
    'when',
    'whence',
    'whenever',
    'where',
    'whereas',
    'whereby',
    'wherefrom',
    'wherein',
    'whereinto',
    'whereof',
    'whereon',
    'wheresoever',
    'whereto',
    'whereunto',
    'wherever',
    'wherewith',
    'wherewithal',
    'whether',
    'which',
    'whichever',
    'whichsoever',
    'while',
    'who',
    'whoever',
    'whom',
    'whomever',
    'whomso',
    'whomsoever',
    'whose',
    'whosesoever',
    'whosever',
    'whoso',
    'whosoever',
    'with',
    'within',
    'without',
    'ye',
    'yet',
    'yon',
    'yonder',
    'you',
    'your',
    'yours',
    'yourself',
    'yourselves',
  };

  /// Matches all words that contain only letters and periods and end with
  /// a period.
  ///
  /// Use for finding acronyms and abbreviations.
  static const reWordEndsWithPeriod = r'(?)([a-zA-Z.]+)(?=([.]))';

  /// Matches al characters except:
  ///   - numbers 0-9;
  ///   - letters a-z;
  ///   - letters A-Z;
  ///   - ampersand, apostrophe, underscore and hyhpen ("&", "'", "_", "-")
  static const reNonWordChars = r"[^a-zA-Z0-9¥Œ€@™#-\&_'-]";

  /// Matches characters used to write words, including:
  ///   - numbers 0-9;
  ///   - letters a-z;
  ///   - letters A-Z;
  ///   - ampersand, apostrophe, underscore and hyhpen ("&", "'", "_", "-")
  static const wordChars = r"[a-zA-Z0-9¥Œ€@™#-\&_'-]";

  /// Matches all line endings.
  static const reLineEndingSelector = '[\u000A\u000B\u000C\u000D]+';

  /// Matches all sentence endings.
  static const reSentenceEndingSelector =
      '(?<=$wordChars|\\s)(\\. )(?=([^a-z])|\\s+|\$)|(\\.)(?=\$)|'
      '(?<=[^([{])([?!])(?=([^)]}])|\\s+|\$)';

  /// Matches all mid-sentence punctuation.
  static const rePunctuationSelector =
      '(?<=$wordChars|\\s)[:;,\\-—]+(?=[\\s])|(\\.{2,})';

  /// A list of English abbreviations.
  static const kAbbreviations = [
    'Anon.',
    'Arb.',
    'Ashm.',
    'Jam.',
    'a.',
    'c.',
    'eOE',
    'lOE',
    'OE',
    'Bel & Dr.',
    'Ecclus.',
    'Esd.',
    'Macc.',
    'Sus.',
    'Wisd.',
    'Chr.',
    'Chron.',
    'Col.',
    'Coloss.',
    'Cor.',
    'Dan.',
    'Deut.',
    'Eccl.',
    'Eccles.',
    'Eph.',
    'Ephes.',
    'Esth.',
    'Exod.',
    'Ezek.',
    'Gal.',
    'Gen.',
    'Hab.',
    'Hag.',
    'Heb.',
    'Hebr.',
    'Hos.',
    'Isa.',
    'Jas.',
    'Jer.',
    'Josh.',
    'Jud.',
    'Judg.',
    'Kgs.',
    'Lam.',
    'Lament.',
    'Lev.',
    'Mal.',
    'Matt.',
    'Mic.',
    'Nah.',
    'Neh.',
    'Num.',
    'Obad.',
    'Pet.',
    'Philem.',
    'Phil.',
    'Philipp.',
    'Prov.',
    'Ps.',
    'Rev.',
    'Rom.',
    'Sam.',
    'Song of Sol.',
    'Song Sol.',
    'Thess.',
    'Tim.',
    'Tit.',
    'Zech.',
    'Zeph.',
    'abbrev.',
    'Abd.',
    'Aberd.',
    'Aberdeensh.',
    'abl.',
    'Abol.',
    'Aborig.',
    'Abr.',
    'Abridg.',
    'Abridgem.',
    'Absol.',
    'abstr.',
    'Abst.',
    'Acad.',
    'Accept.',
    'Accomm.',
    'Accompl.',
    'acc.',
    'Acct.',
    'Accs.',
    'Accts.',
    'accus.',
    'Achievem.',
    'ad.',
    'Add.',
    'Addit.',
    'Addr.',
    'adj. phr.',
    'adj.',
    'adjs.',
    'Admin.',
    'Adm.',
    'Admir.',
    'Admon.',
    'Admonit.',
    'Adv.',
    'Advancem.',
    'advb.',
    'advs.',
    'Advert.',
    'Advt.',
    'Advts.',
    'Advoc.',
    'Aerodynam.',
    'Aeronaut.',
    'Aff.',
    'Affect.',
    'Afr.',
    'agst.',
    'Agric.',
    'Alch.',
    'Alg.',
    'Alleg.',
    'Allit.',
    'Alm.',
    'Alph.',
    'alt.',
    'Amer.',
    'Anal.',
    'Analyt.',
    'Anat.',
    'Anc.',
    'Anecd.',
    'Ang.',
    'Angl.',
    'Anglo-Ind.',
    'Anim.',
    'Ann.',
    'Anniv.',
    'A.D.',
    'Annot.',
    'Answ.',
    'Anthrop.',
    'Anthropol.',
    'Ant.',
    'Antiq.',
    'aphet.',
    'Apoc.',
    'Apol.',
    'app.',
    'Applic.',
    'Appl.',
    'appos.',
    'Apr.',
    'Arab.',
    'Archaeol.',
    'arch.',
    'Abp.',
    'Archipel.',
    'Archit.',
    'Argt.',
    'Arith.',
    'Arithm.',
    'Arrangem.',
    'art.',
    'Artic.',
    'Artific.',
    'Artill.',
    'Assemb.',
    'Assoc.',
    'Assoc. Football',
    'Assyriol.',
    'Astrol.',
    'Astronaut.',
    'Astr.',
    'Astron.',
    'Att.',
    'Attrib.',
    'Aug.',
    'Austral.',
    'Auth.',
    'A.V.',
    'Autobiog.',
    'Autobiogr.',
    'Ayrsh.',
    'Bacteriol.',
    'Bedford.',
    'Bedfordsh.',
    'bef.',
    'B.C.',
    'Belg.',
    'Berks.',
    'Berksh.',
    'Berw.',
    'Berwicksh.',
    'betw.',
    'Bibliogr.',
    'Biochem.',
    'Biog.',
    'Biogr.',
    'Biol.',
    'Bp.',
    'Bk.',
    'Bks.',
    'Bord.',
    'Bot.',
    'Braz.',
    'Brit.',
    'BNC',
    'Bucks.',
    'Build.',
    'Bull.',
    'Bur.',
    'Calc.',
    'Cal.',
    'Calend.',
    'Calif.',
    'Calligr.',
    'Camb.',
    'Cambr.',
    'Campanol.',
    'Canad.',
    'Canterb.',
    'Capt.',
    'Cartogr.',
    'Catal.',
    'Catech.',
    'Cath.',
    'Cent.',
    'c.',
    'Ceram.',
    'Cert.',
    'Certif.',
    'Chamb.',
    'Char.',
    'Charac.',
    'Chas.',
    'Chem. Engin.',
    'Chem.',
    'Chesh.',
    'Chrons.',
    'Chronol.',
    'Ch.',
    'Ch. Hist.',
    'Cinematogr.',
    'Circ.',
    'Civil Engin.',
    'Civ. Law',
    'Class.',
    'Class. Antiq.',
    'Classif.',
    'cl.',
    'Climatol.',
    'Clin.',
    'cogn. w.',
    'Coll.',
    'Collect.',
    'colloq.',
    'Comb.',
    'Combs.',
    'comb. form',
    'Commandm.',
    'Commend.',
    'Comm.',
    'Commerc.',
    'Comm. Law',
    'Com.',
    'Commiss.',
    'Commonw.',
    'Communic.',
    'Comp.',
    'Compan.',
    'compar.',
    'Comp. Anat.',
    'Compend.',
    'compl.',
    'Compos.',
    'cpd.',
    'conc.',
    'Conch.',
    'Concl.',
    'concr.',
    'cf.',
    'Conf.',
    'Confid.',
    'Confl.',
    'Confut.',
    'Congreg.',
    'Congr.',
    'Congress.',
    'conj.',
    'Conn.',
    'Consc.',
    'Consecr.',
    'Consid.',
    'Consol.',
    'cons.',
    'Constit.',
    'Constit. Hist.',
    'Constr.',
    'const.',
    'Contempl.',
    'Contemp.',
    'contempt.',
    'Contend.',
    'Content.',
    'Contin.',
    'contr.',
    'Contradict.',
    'Contrib.',
    'Controv.',
    'Conv.',
    'Convent.',
    'Conversat.',
    'Convoc.',
    'Cornw.',
    'Coron.',
    'Corr.',
    'Corresp.',
    'Counc.',
    'Ct.',
    'Crt.',
    'Crts.',
    'Courtsh.',
    'Craniol.',
    'Craniom.',
    'Crim.',
    'Crim. Law',
    'Crit.',
    'Cryptogr.',
    'Crystallogr.',
    'Cumb.',
    'Cumberld.',
    'Cumbld.',
    'Cycl.',
    'Cytol.',
    'dat.',
    'Dau.',
    'Deb.',
    'Dec.',
    'Declar.',
    'Ded.',
    'Def.',
    'Deliv.',
    'Demonstr.',
    'dem.',
    'Dep.',
    'Dept.',
    'Depred.',
    'Depredat.',
    'Derbysh.',
    'deriv.',
    'derog.',
    'Descr.',
    'Devel.',
    'Devonsh.',
    'dial.',
    'Dict.',
    'Diffic.',
    'dim.',
    'Direct.',
    'Discipl.',
    'Disc.',
    'Discov.',
    'Discrim.',
    'Discuss.',
    'Dis.',
    'Diss.',
    'Distemp.',
    'Distill.',
    'Distrib.',
    'Dist.',
    'D.C.',
    'Divers.',
    'Div.',
    'Doctr.',
    'Doc.',
    'Domest.',
    'Dk.',
    'Durh.',
    'dyslog.',
    'E.E.T.S.',
    'e.',
    'E. Afr.',
    'E. Angl.',
    'E. Anglian',
    'East Ind.',
    'E. Ind.',
    'e. midl.',
    'east.',
    'Eccl. Hist.',
    'Eccl. Law',
    'Ecol.',
    'Econ.',
    'Edin.',
    'Edinb.',
    'ed.',
    'Educ.',
    'Edw.',
    'Egypt.',
    'Egyptol.',
    'Electr. Engin.',
    'Electr.',
    'Electro-magn.',
    'Electro-physiol.',
    'Elem.',
    'Eliz.',
    'Elizab.',
    'ellipt.',
    'Emb.',
    'Embryol.',
    'emph.',
    'Encycl. Brit.',
    'Encycl. Metrop.',
    'Encycl.',
    'Engin.',
    'Eng.',
    'E.D.D.',
    'Englishw.',
    'Enq.',
    'Enthus.',
    'Ent.',
    'Entom.',
    'Entomol.',
    'Enzymol.',
    'Epil.',
    'Episc.',
    'Ep.',
    'Epist.',
    'Epit.',
    'Equip.',
    'erron.',
    'esp.',
    'Ess.',
    'Essent.',
    'Establ.',
    'Ethnol.',
    'etymol.',
    'etym.',
    'euphem.',
    'Eval.',
    'Evang.',
    'Even.',
    'Evid.',
    'Evol.',
    'Exalt.',
    'Exam.',
    'exc.',
    'Exch.',
    'Exec.',
    'Ex. doc.',
    'Exerc.',
    'Exhib.',
    'Exped.',
    'Exper.',
    'Explan.',
    'Explic.',
    'Explor.',
    'Expos.',
    'Fab.',
    'fam.',
    'famil.',
    'Farew.',
    'Fr.',
    'Feb.',
    'f.',
    'fem.',
    'Fifesh.',
    'fig.',
    'fl.',
    'Ff.',
    'Footpr.',
    'Forfarsh.',
    'Fortif.',
    'Fortn.',
    'Found.',
    'Fragm.',
    'Fratern.',
    'freq.',
    'Friendsh.',
    'Fund.',
    'Furnit.',
    'fut.',
    'Gard.',
    'Gastron.',
    'Gaz.',
    'Geog.',
    'Geogr.',
    'Geol.',
    'Geom.',
    'Geomorphol.',
    'Geo.',
    'Ger.',
    'gerund.',
    'Glac.',
    'Glasg.',
    'Gloss.',
    'Glos.',
    'Glouc.',
    'Gloucestersh.',
    'Gd.',
    'Gosp.',
    'Gov.',
    'Govt.',
    'Gr.',
    'Gram.',
    'Gramm. Analysis',
    'Gt.',
    'Gynaecol.',
    'Haematol.',
    'Hampsh.',
    'Hants.',
    'Handbk.',
    'Hen.',
    'Her.',
    'Herb.',
    'Heref.',
    'Hereford.',
    'Herefordsh.',
    'Hertfordsh.',
    'Hierogl.',
    'Histol.',
    'hist.',
    'Hom.',
    'Horol.',
    'Hort.',
    'Hosp.',
    'Househ.',
    'Housek.',
    'Husb.',
    'Hydraul.',
    'Hydrol.',
    'Ichth.',
    'Icthyol.',
    'Ideol.',
    'Idol.',
    'Illustr.',
    'Imag.',
    'imit.',
    'Immunol.',
    'imp.',
    'imperf.',
    'impf.',
    'impers.',
    'Impr.',
    'improp.',
    'Inaug.',
    'Inclos.',
    'indef.',
    'Ind.',
    'indic.',
    'indir.',
    'Industr.',
    'Industr. Rel.',
    'infin.',
    'Infl.',
    'Innoc.',
    'Inorg.',
    'Inq.',
    'Inst.',
    'Instr.',
    'Intellect.',
    'Intell.',
    'Interc.',
    'int.',
    'interj.',
    'Interl.',
    'Internat.',
    'Interpr.',
    'interrog.',
    'intr.',
    'intrans.',
    'Intro.',
    'Introd.',
    'Invent.',
    'Inv.',
    'Invert. Zool.',
    'Invertebr.',
    'Investig.',
    'Investm.',
    'Invoc.',
    'Irel.',
    'Ir.',
    'iron.',
    'irreg.',
    'Ital.',
    'Jahrb.',
    'Jan.',
    'Jap.',
    'joc.',
    'Jrnl.',
    'Jrnls.',
    'Jul.',
    'Jun.',
    'Jurisd.',
    'Jurisdict.',
    'Jurispr.',
    'Justif.',
    'Justific.',
    'Kpr.',
    'Kent.',
    'K.',
    'King’s Bench Div.',
    'Kingd.',
    'Knowl.',
    'Lab.',
    'Lament',
    'Lanc.',
    'Lancash.',
    'Lancs.',
    'Lang.',
    'Langs.',
    'Lat.',
    'Lect.',
    'Leechd.',
    'Leg.',
    'Leicest.',
    'Leicester.',
    'Leicestersh.',
    'Leics.',
    'Let.',
    'Lett.',
    'Lex.',
    'Libr.',
    'Limnol.',
    'Lincolnsh.',
    'Lincs.',
    'l.',
    'll.',
    'Ling.',
    'Linn.',
    'lit.',
    'Lithogr.',
    'Lithol.',
    'Liturg.',
    'Lond.',
    'Ld.',
    'Lds.',
    'Mach.',
    'Mag.',
    'Magn.',
    'Managem.',
    'Manch.',
    'Manip.',
    'Man.',
    'Manuf.',
    'MS.',
    'MSS.',
    'Mar.',
    'm.',
    'masc.',
    'Mass.',
    'Math.',
    'Meas.',
    'Measurem.',
    'Mech.',
    'Med.',
    'Medit.',
    'Mtg.',
    'Mem.',
    'Merch.',
    'Merc.',
    'Metallif.',
    'Metallogr.',
    'Metall.',
    'Metamorph.',
    'metaphor.',
    'Metaph.',
    'Meteorol.',
    'Meth.',
    'metr. gr.',
    'Metrop.',
    'Mex.',
    'Mich.',
    'Microbiol.',
    'Microsc.',
    'midl.',
    'Mil.',
    'Milit.',
    'Min.',
    'Mineral.',
    'Misc.',
    'Miscell.',
    'mispr.',
    'mod.',
    'Monum.',
    'Morphol.',
    'Mt.',
    'Mts.',
    'Munic.',
    'Munif.',
    'Munim.',
    'Mus.',
    'Myst.',
    'Myth.',
    'Mythol.',
    'Narr.',
    'Narrat.',
    'Nat.',
    'Nat. Hist.',
    'Nat. Philos.',
    'Nat. Sci.',
    'Naut.',
    'Nav.',
    'Navig.',
    'Neighb.',
    'Nerv.',
    'Neurol.',
    'Neurosurg.',
    'n.',
    'N.E.D.',
    'New Hampsh.',
    'N.S. Wales',
    'N.S.W.',
    'N.T.',
    'N.Y.',
    'N.Z.',
    'Newc.',
    'Newspr.',
    'nom.',
    'nonce-wd.',
    'Non-conf.',
    'Nonconf.',
    'Norf.',
    'N. Afr.',
    'N. Amer.',
    'N. Carolina',
    'N. Dakota',
    'Northamptonsh.',
    'Northants.',
    'N.E.',
    'north.',
    'N. Irel.',
    'N. Ir.',
    'Northumbld.',
    'Northumb.',
    'Northumbr.',
    'N.W.',
    'Norw.',
    'Norweg.',
    'Notts.',
    'ns.',
    'Nov.',
    'Nucl.',
    'No.',
    'Numism.',
    'Obed.',
    'Obj.',
    'obl.',
    'Observ.',
    'obs.',
    'Obstetr. Med.',
    'Obstet.',
    'Obstetr.',
    'Occas.',
    'Occup.',
    'Occurr.',
    'Oceanogr.',
    'Oct.',
    'Offic.',
    'Off.',
    'Okla.',
    'O.T.',
    'Ont.',
    'Ophthalm.',
    'Ophthalmol.',
    'opp.',
    'Oppress.',
    'Opt.',
    'Orac.',
    'Ord.',
    'Org.',
    'Organ. Chem.',
    'Org. Chem.',
    'orig.',
    'Orkn.',
    'Ornith.',
    'Ornithol.',
    'Orthogr.',
    'Outl.',
    'Oxf.',
    'O.E.D.',
    'Oxfordsh.',
    'Oxon.',
    'p.',
    'Palaeobot.',
    'Palaeogr.',
    'Palaeont.',
    'Palaeontol.',
    'Paraphr.',
    'Parasitol.',
    'Parl.',
    'Parnass.',
    'Pt.',
    'ppl.',
    'ppl. a.',
    'ppl. adj.',
    'ppl. adjs.',
    'pple.',
    'pples.',
    'pa. pple.',
    'pass.',
    'pa.',
    'pa. t.',
    'Path.',
    'Pathol.',
    'Peculat.',
    'Penins.',
    'perf.',
    'pf.',
    'perh.',
    'Periodontol.',
    'Persec.',
    'Pers.',
    'personif.',
    'Perthsh.',
    'Petrogr.',
    'Petrol.',
    'Pharmaceut.',
    'Pharm.',
    'Pharmacol.',
    'Philad.',
    'Philol.',
    'Philos.',
    'Phoen.',
    'phonet.',
    'Phonol.',
    'Photog.',
    'Photogr.',
    'phr.',
    'Phrenol.',
    'Physical Chem.',
    'Physical Geogr.',
    'Physiogr.',
    'Phys.',
    'Physiol.',
    'Pict.',
    'pl.',
    'plur.',
    'poet.',
    'Pol. Econ.',
    'Pol.',
    'Polit.',
    'Polytechn.',
    'Pop.',
    'Porc.',
    'Port.',
    'poss.',
    'Posth.',
    'Postm.',
    'Pott.',
    'Pract.',
    'prec.',
    'pred.',
    'predic.',
    'Predict.',
    'Pref.',
    'Preh.',
    'Prehist.',
    'prep.',
    'Prerog.',
    'Presb.',
    'pr.',
    'pres.',
    'pres. pple.',
    'pr. pple.',
    'Preserv.',
    'Prim.',
    'Princ.',
    'Print.',
    'priv.',
    'Probab.',
    'prob.',
    'Probl.',
    'Proc.',
    'Prod.',
    'Prol.',
    'pron.',
    'pronunc.',
    'prop.',
    'propr.',
    'Pros.',
    'Provid.',
    'Provinc.',
    'Provis.',
    'pseudo-arch.',
    'pseudo-dial.',
    'pseudo-Sc.',
    'Psychoanal.',
    'Psychoanalyt.',
    'Psych.',
    'Psychol.',
    'Psychopathol.',
    'Publ.',
    'P. R.',
    'Purg.',
    'Quantum Mech.',
    'Q.',
    'Q. Eliz.',
    'Queen’s Bench Div.',
    'Qld.',
    'q.v.',
    'quot.',
    'quots.',
    'Radiol.',
    'Reas.',
    'Reb.',
    'Rebell.',
    'Reclam.',
    'Recoll.',
    'Rec.',
    'Redempt.',
    'redupl.',
    'refash.',
    'Ref.',
    'Refl.',
    'Refus.',
    'Refut.',
    'Regic.',
    'Reg.',
    'Regist.',
    'Regr.',
    'rel.',
    'Relig.',
    'Reminisc.',
    'Remonstr.',
    'Renfrewsh.',
    'Rep.',
    'Rept.',
    'repr.',
    'Reprod.',
    'Repub.',
    'Res.',
    'Resid.',
    'Retrosp.',
    'Ret.',
    'Revol.',
    'Rhet.',
    'Rhode Isl.',
    'Rich.',
    'Rom. Antiq.',
    'R.C. Church',
    'R.C.',
    'Ross-sh.',
    'Roxb.',
    'R.',
    'Roy.',
    'R.A.F.',
    'R.N.',
    'Rudim.',
    'Russ.',
    'St.',
    'SS.',
    'Sask.',
    'Sat.',
    'Sax.',
    'Scand.',
    'Sch.',
    'Sci.',
    'sc.',
    'Scotl.',
    'Scot.',
    'S.T.S.',
    'Script.',
    'Sculpt.',
    'Seismol.',
    'Sel. comm.',
    'Sel.',
    'Select.',
    'Sept.',
    'LXX',
    'Ser.',
    'Serm.',
    'Sess.',
    'Settlem.',
    'Sev.',
    'Shakes.',
    'Shaks.',
    'Sheph.',
    'Shetl.',
    'Shropsh.',
    'sing.',
    'Soc.',
    'Sociol.',
    'Som.',
    'Sonn.',
    's.',
    'S. Afr.',
    'S. Carolina',
    'S. Dakota',
    'S.E.',
    'south.',
    'S.W.',
    'Span.',
    'Spec.',
    'Specif.',
    'Specim.',
    'Spectrosc.',
    'sp.',
    'Staff.',
    'Stafford.',
    'Staffordsh.',
    'Staffs.',
    'Stand.',
    'Stat.',
    'Statist.',
    'Stock Exch.',
    'Stratigr.',
    'str.',
    'Struct.',
    'Stud.',
    's.v.',
    'subj.',
    'subjunct.',
    'subord.',
    'subord. cl.',
    'Subscr.',
    'Subscript.',
    'subseq.',
    'subst.',
    'suff.',
    'superl.',
    'Suppl.',
    'Supplic.',
    'Suppress.',
    'Surg.',
    'Surv.',
    'syll.',
    'Symmetr.',
    'Symp.',
    'Syst.',
    'Taxon.',
    'techn.',
    'Technol.',
    'Telecomm.',
    'Tel.',
    'Telegr.',
    'Teleph.',
    't.',
    'Teratol.',
    'Terminol.',
    'Terrestr.',
    'Test.',
    'Textbk.',
    'Theat.',
    'Theatr.',
    'Theol.',
    'Theoret.',
    'Thermonucl.',
    'Thes.',
    'Topogr.',
    'Trad.',
    'Trag.',
    'Trans.',
    'transf.',
    'Transl.',
    'tr.',
    'Transubstant.',
    'Trav.',
    'Treas.',
    'Treat.',
    'Treatm.',
    'Trib.',
    'Trig.',
    'Trigonom.',
    'Trop.',
    'Troub.',
    'Troubl.',
    'Typog.',
    'Typogr.',
    'ult.',
    'U.S.S.R.',
    'U.K.',
    'U.S.',
    'U.S.A.F.',
    'Univ.',
    'unkn.',
    'Unnat.',
    'Unoffic.',
    'unstr.',
    'Urin.',
    'usu.',
    'Utilit.',
    'Vac.',
    'Valedict.',
    'var.',
    'v.r.',
    'v.rr.',
    'varr.',
    'vars.',
    'Veg.',
    'Veg. Phys.',
    'Veg. Physiol.',
    'Venet.',
    'v.',
    'vb.',
    'vbl.',
    'vbl.n.',
    'vbl. ns.',
    'vbs.',
    'Vertebr.',
    'Vet. Med.',
    'Vet. Path.',
    'Vet. Sci.',
    'Vet. Surg.',
    'Vet.',
    'Vic.',
    'Vict.',
    'viz.',
    'Vind.',
    'Vindic.',
    'Virg.',
    'Va.',
    'Virol.',
    'Voc.',
    'Vocab.',
    'Vol.',
    'Vols.',
    'Voy.',
    'Vulg.',
    'Warwicksh.',
    'wk.',
    'Wkly.',
    'w.',
    'W. Afr.',
    'W. Indies',
    'W. Ind.',
    'W. Va.',
    'west.',
    'Westm.',
    'Westmld.',
    'Westmorld.',
    'Westmrld.',
    'Will.',
    'Wilts.',
    'Wiltsh.',
    'Wis.',
    'Wonderf.',
    'Worc.',
    'Worcestersh.',
    'Worcs.',
    'wd.',
    'Wks.',
    'Writ.',
    'Yr.',
    'Yearbk.',
    'Yrs.',
    'Yorks.',
    'Yorksh.',
    'Yng.',
    'Zeitschr.',
    'Zoogeogr.',
    'Zool.',
  ];
}
