import Foundation
import UIKit
import CoreData

enum View {
    case Search
    case GameMode(studyAheadAmount: Double, runTutorial: Bool)
    case Reader
    case CardsFinished
    case AddWords(enableOnAdd: Bool)
    case Lists(
        title: String,
        color: UIColor,
        cards: [NSManagedObject],
        displayConfirmButton: Bool,
        displayAddButton: Bool,
        sourceList: WordList?,
        enableOnAdd: Bool)
    case Settings
    
    func description() -> String {
        switch self {
        case .Search:
            return "Search"
        case .GameMode:
            return "GameMode"
        case .Reader:
            return "Reader"
        case .CardsFinished:
            return "CardsFinished"
        case .AddWords:
            return "AddWords"
        case .Lists:
            return "Lists"
        case .Settings:
            return "Settings"
        }
    }
}