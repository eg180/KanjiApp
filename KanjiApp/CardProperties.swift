//
//  CardProperties.swift
//  KanjiApp
//
//  Created by Sky on 2014-07-13.
//  Copyright (c) 2014 Sky. All rights reserved.
//

import Foundation

enum CardProperties {
    case kanji
    case index
    case hiragana
    case definition
    case exampleEnglish
    case exampleJapanese
    case soundWord
    case soundDefinition
    case definitionOther
    case usageAmount
    case usageAmountOther
    case pitchAccentText
    case pitchAccent
    case otherExampleSentences
    
    case answersKnown
    case answersNormal
    case answersHard
    case answersForgot
    case interval
    func description() -> String {
        switch self {
        case .kanji:
            return "kanji"
        case .index:
            return "index"
        case .hiragana:
            return "hiragana"
        case .definition:
            return "definition"
        case .exampleEnglish:
            return "exampleEnglish"
        case .exampleJapanese:
            return "exampleJapanese"
        case .soundWord:
            return "soundWord"
        case .soundDefinition:
            return "soundDefinition"
        case .definitionOther:
            return "definitionOther"
        case .definitionOther:
            return "definitionOther"
        case .usageAmount:
            return "usageAmount"
        case .usageAmountOther:
            return "usageAmountOther"
        case .pitchAccentText:
            return "pitchAccentText"
        case .pitchAccent:
            return "pitchAccent"
        case .otherExampleSentences:
            return "otherExampleSentences"
        case .answersKnown:
            return "answersKnown"
        case .answersNormal:
            return "answersNormal"
        case .answersHard:
            return "answersHard"
        case .answersForgot:
            return "answersForgot"
        case .interval:
            return "interval"
        }
    }
}