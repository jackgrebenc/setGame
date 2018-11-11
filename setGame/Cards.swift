//
//  Cards.swift
//  setGame
//
//  Created by Jack Grebenc on 2018-11-05.
//  Copyright © 2018 Jack Grebenc. All rights reserved.
//

import Foundation
import UIKit
struct Cards: Equatable {
    var number: numbers
    var symbol: symbols
    var shading: shadings
    var color: colors
    
    //cardDisplay applies all of the attributes for the specifications provided by each card into a NSAttributedString
    //This should probably be in the viewController since it is a strictly UI implementation
    //but I prefer to keep it in cards to provide a more OOP methodology and to not overcrowd my VC
    var cardDisplay: NSMutableAttributedString {
        let repSymbol = String(repeating: "\(self.symbol.toString)", count: self.number.rawValue)
        let symbolColor = self.color.colorAsUIColor
        let attributes = [
            NSAttributedString.Key.foregroundColor : symbolColor.withAlphaComponent(self.shading.hue),
            NSAttributedString.Key.strokeWidth : -5.0,
            NSAttributedString.Key.strokeColor: symbolColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24.0),
            ] as [NSAttributedString.Key : Any]
        
        return NSMutableAttributedString(string: repSymbol, attributes: attributes)
    }
    
    enum numbers: Int {
        case one = 1
        case two = 2
        case three = 3
        static var all = [numbers.one, .two, .three]
    }
    enum symbols: String {
        case circle, triangle, square
        var toString: String {
            switch self {
            case .circle:
                return "●"
            case .triangle:
                return "▲"
            case .square:
                return "■"
            }
        }
        static var all = [symbols.circle, .triangle, .square]
    }
    enum shadings {
        case solid, open, striped
        var hue: CGFloat {
            switch self {
            case .solid:
                return 1.0
            case .open:
                return 0
            case .striped:
                return 0.15
            }
        }
        static var all = [shadings.striped, .solid, .open]
    }
    enum colors {
        case red, green, purple
        var colorAsUIColor : UIColor {
            switch self {
            case .red:
                return UIColor.red
            case .green:
                return UIColor.green
            case .purple:
                return UIColor.purple
            }
        }
        static var all = [colors.red, .green, .purple]
    }
    //matches compares itself to two other cards to check if it satisifies the conditions for a match
    func matches(_ card2: Cards, _ card3: Cards) -> Bool {
        if numbersMatch(card2,card3) && symbolsMatch(card2,card3) && shadingsMatch(card2,card3) && colorsMatch(card2,card3) {
            return true
        }
        return false
    }
    /*The following four helper functions all must be true to verify a set match
      This may seem repetitive but I beileve this gives a simplisitic and easy to follow approach for match checking.
     There doesn't seem to be a way to implement a generic enum type that could make these four functions into one function
     with an extra parameter as the attribute being compared
    */
    func numbersMatch(_ card2: Cards, _ card3:Cards) -> Bool {
        let shared = (self.number == card2.number && self.number == card3.number)
        let notShared = (self.number != card2.number && self.number != card3.number && card2.number != card3.number)
        return  shared || notShared
    }
    func symbolsMatch(_ card2: Cards, _ card3: Cards) -> Bool {
        let shared = (self.symbol == card2.symbol && self.symbol == card3.symbol)
        let notShared = (self.symbol != card2.symbol && self.symbol != card3.symbol && card2.symbol != card3.symbol)
        return shared || notShared
    }
    func shadingsMatch(_ card2: Cards, _ card3: Cards) -> Bool {
        let shared = (self.shading == card2.shading && self.shading == card3.shading)
        let notShared = (self.shading != card2.shading && self.shading != card3.shading && card2.shading != card3.shading)
        return shared || notShared
    }
    func colorsMatch(_ card2: Cards, _ card3: Cards) -> Bool {
        let shared = (self.color == card2.color && self.color == card3.color)
        let notShared = (self.color != card2.color && self.color != card3.color && card2.color != card3.color)
        return shared || notShared
    }
}
