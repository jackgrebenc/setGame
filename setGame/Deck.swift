//
//  Deck.swift
//  setGame
//
//  Created by Jack Grebenc on 2018-11-05.
//  Copyright © 2018 Jack Grebenc. All rights reserved.
//

import Foundation
import UIKit
struct Deck {
    //deckOfCards holds the current cards in the deck (not cards displayed on screen -> those get
    //removed by the function Activatecards in the viewController
    var deckOfCards = [Cards]()
    
    //deck gets initialized at the start of each game in the same order, randomization occurs only when
    //each card gets "activated" to show up on screen
    init() {
        for number in Cards.numbers.all {
            for symbol in Cards.symbols.all {
                for shading in Cards.shadings.all {
                    for color in Cards.colors.all {
                        deckOfCards.append(Cards(number: number, symbol: symbol, shading: shading, color: color))
                    }
                }
            }
        }
    }
    
    
}
