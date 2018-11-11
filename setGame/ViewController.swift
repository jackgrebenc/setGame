//
//  ViewController.swift
//  setGame
//
//  Created by Jack Grebenc on 2018-11-05.
//  Copyright © 2018 Jack Grebenc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGame(newGameButton)
        scoreLabel.layer.cornerRadius = 5.0
        deal3CardsButton.layer.cornerRadius = 5.0
        newGameButton.layer.cornerRadius = 5.0
        
    }
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var deal3CardsButton: UIButton!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet weak var DeckCountLabel: UILabel!
    
    var deckCount = 81 {
        didSet{
            DeckCountLabel.text = "Deck: \(deckCount)"
        }
    }
    var scoreCount = 0 {
        didSet {
            scoreLabel.text = "Score: \(scoreCount)"
        }
    }
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func dealCardsPress(_ sender: UIButton) {
        //if statement protects against array index out of bounds
        if cardButtonsInPlay.count > 21 {
            let numFlippableCards = 24 - cardButtonsInPlay.count
            ActivateCards(numberOfCards: numFlippableCards)
            sender.layer.backgroundColor = UIColor.gray.cgColor
        } else {
            ActivateCards(numberOfCards: 3)
        }
        
    }
    
    var currentDeck = Deck()
    var cardButtonsInPlay = Dictionary<Int,Cards>()
    var selectedCards = [Int]()
    /*ActivateCards is used by dealCardsPress (when the player wants to draw three more cards) and by
      newGame. It adds cards into available spots (that have no cards) based on the number specified.
     An override method of ActivateCards (see below) is used for card replacement (occurs during a match)
     */
    func ActivateCards(numberOfCards num: Int) {
        if cardButtons != nil && cardButtons.indices.count >= num {
                for item in cardButtonsInPlay.count..<cardButtonsInPlay.count + num {
                    if currentDeck.deckOfCards.count > 0 {
                        let randomCard = currentDeck.deckOfCards.indices.index(currentDeck.deckOfCards.startIndex, offsetBy: Int(arc4random_uniform(UInt32(currentDeck.deckOfCards.count))))
                        cardButtons[item].setAttributedTitle(currentDeck.deckOfCards[randomCard].cardDisplay, for: UIControl.State.normal)
                        cardButtonsInPlay.updateValue(currentDeck.deckOfCards[randomCard], forKey: item)
                        cardButtons[item].backgroundColor = UIColor.white
                        cardButtons[item].layer.borderColor = UIColor.gray.cgColor
                        currentDeck.deckOfCards.remove(at: randomCard)
                        deckCount -= 1
                    }
                    else {
                        //no more cards in deck
                        //give deal3CardsButton a gray color to show disabled
                        deal3CardsButton.layer.backgroundColor = UIColor.gray.cgColor
                        break
                    }
                }
            }
    }
    //An overriding method for ActivateCards is used by checkForMatch is called 3 times (in a for loop) when the three cards match
    //and need to be replaced by cards from the deck. This is the ONLY time this method is used
    func ActivateCards(buttonIndex index: Int) {
        if cardButtons != nil && cardButtons.indices.count >= index {
                if currentDeck.deckOfCards.count > 0 {
                    let randomCard = currentDeck.deckOfCards.indices.index(currentDeck.deckOfCards.startIndex, offsetBy: Int(arc4random_uniform(UInt32(currentDeck.deckOfCards.count))))
                    cardButtons[index].setAttributedTitle(currentDeck.deckOfCards[randomCard].cardDisplay, for: UIControl.State.normal)
                    cardButtonsInPlay.updateValue(currentDeck.deckOfCards[randomCard], forKey: index)
                    cardButtons[index].backgroundColor = UIColor.white
                    cardButtons[index].layer.borderColor = UIColor.gray.cgColor
                    currentDeck.deckOfCards.remove(at: randomCard)
                    deckCount -= 1
                }
                else {
                    deal3CardsButton.layer.backgroundColor = UIColor.gray.cgColor
                }
            }
        }
    
    //Used to deactivate card slots when the deck is empty so that the interface displays a blank card slot
    //This method is only accessed by checkForMatch() when a confirmed match needs to be replaced but there are
    //no cards left in currentDeck.deckOfCards
    func deActivateCard(buttonIndex index: Int) {
        cardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6)
        cardButtons[index].setAttributedTitle(nil, for: UIControl.State.normal)
        cardButtonsInPlay.removeValue(forKey: index)
    }
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardSelected = cardButtons.index(of: sender){
            if cardButtonsInPlay.keys.contains(cardSelected) {
                if selectedCards.count == 3 {
                    //three cards are already selected (so player is selecting a fourth card
                    //check if the currently selected three cards are a match
                    checkForMatch()
                }
                //if statement handles deselection of a card (card is already in selectedCards)
                if selectedCards.contains(cardSelected) {
                    //player wants to deselect so change border color back to gray
                    cardButtons[cardSelected].layer.borderColor = UIColor.gray.cgColor
                    //closure used here to remove cardSelected from selectedCards
                    selectedCards.removeAll(where: { $0 == cardSelected })
                } else {
                    //card isn't in selected, so player is trying to make a new selection
                    //set border to green to show to player that the card has been selected
                    cardButtons[cardSelected].layer.borderColor = UIColor.blue.cgColor
                    selectedCards.append(cardSelected)
                }
                //after the first if/else statement; we need to check the number of currently selected cards
                if selectedCards.count == 3 {
                    //three cards are selected so we need to check if there's a match -> green borders indicate match, red indicates failure
                    let card1 = cardButtonsInPlay[selectedCards[0]]!
                    let card2 = cardButtonsInPlay[selectedCards[1]]!
                    let card3 = cardButtonsInPlay[selectedCards[2]]!
                    if card1.matches(card2, card3) {
                        for item in selectedCards.indices {
                            cardButtons[selectedCards[item]].layer.borderColor = UIColor.green.cgColor
                            match = true
                        }
                    }
                    else {
                        for item in selectedCards.indices {
                            cardButtons[selectedCards[item]].layer.borderColor = UIColor.red.cgColor
                        }
                    }
                }
            }
        }
    }
    /*checkForMatch is a helper function to touchCard that verifies whether a card has been matched
      and changes the UI based on if the match is succesful
     */
    var match = false
    func checkForMatch() {
        if match {
            scoreCount += 5
            for item in selectedCards.indices {
                if currentDeck.deckOfCards.count == 0 {
                    //deck is empty so cards can't be replaced
                    deActivateCard(buttonIndex: selectedCards[item])
                } else {
                    //deck is not empty so replace the cards in the UI
                    ActivateCards(buttonIndex: selectedCards[item])
                }
            }
            match = false
        }
        else {
            //not a match so deduct three points and change the borders of the selected cards back to unselected (gray)
            scoreCount -= 3
        }
        for item in selectedCards.indices {
            cardButtons[selectedCards[item]].layer.borderColor = UIColor.gray.cgColor
        }
        selectedCards.removeAll()
    }
    
    //newGame button resets the game and intializes the 12 starting cards
    @IBAction func newGame(_ sender: Any) {
        currentDeck = Deck()
        cardButtonsInPlay.removeAll()
        for button in cardButtons.indices {
            cardButtons[button].layer.borderWidth = 3.0
            cardButtons[button].layer.borderColor = UIColor.white.cgColor
            cardButtons[button].layer.cornerRadius = 8.0
            cardButtons[button].backgroundColor = nil
            cardButtons[button].setAttributedTitle(nil, for: UIControl.State.normal)
        }
        deal3CardsButton.layer.backgroundColor = UIColor.blue.cgColor
        selectedCards.removeAll()
        deckCount = currentDeck.deckOfCards.count //(should be 81 -> 69 once ActivateCards is called)
        scoreCount = 0
        ActivateCards(numberOfCards: 12)

        
    }
}
