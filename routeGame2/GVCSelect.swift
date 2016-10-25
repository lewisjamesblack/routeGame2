//
//  GVC-EndSelect.swift
//  routeGame2
//
//  Created by Lewis Black on 22/10/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit

extension GameViewController {

    func selectSquare(_ square:(Int,Int, BorderType), startOfTouch: Bool){
        if startOfTouch {
            if selectedWords.count == 0 {
                selectedWords = [[square]]
            } else  {
                selectedWords.append([square])
            }
            currentWord = selectedWords.count - 1
        } else {
            selectedWords[currentWord!].append(square)
        }
        endOfSelection(square)
    }
    
    func endOfSelection(_ square:(Int,Int, BorderType)){
        putBorderOnPreviousSquare(square)
        putEndBorderOnCurrentSquare(square)
        makeBordersOfLast(2)
        
        let wordCorrect = isWordCorrect(whatWordIsSquareIn(square)!.0)
        if autoCorrectWord {
            if wordCorrect.2 != nil {
                var lettersBeingDeleted:[(Int, Int, BorderType)] = wordCorrect.2!
                let count = lettersBeingDeleted.count
                putEndBorderOnCurrentSquare(selectedWords.last!.last!)
                for i in 0..<count {
                    let square:(Int, Int, BorderType) = lettersBeingDeleted[i]
                    let i = square.0
                    let j = square.1
                    let squareView:LetterSquareView = arrayOfRows[i][j]
                    makeBorders(squareView, borderType: BorderType.none)
                }
                let lettersCount:Int = selectedWords[currentWord!].count
                if count > 0 {
                    for i in 0..<lettersCount {
                        putBorderOnPreviousSquare(selectedWords[currentWord!][lettersCount - i - 1])
                    }
                }
                makeBordersOfLast(lettersCount - 1)
            }
        }
        if spellOutNameAtBottom {
            changeTranslatedText()
        }
        
        
        if wordCorrect.0 {
            isWordBeingSelectedCorrect = true
            let wordNumber:Int = wordCorrect.1!
            
            wordsFound[wordNumber] = true
            
            let dataWord:String = answersArray[wordNumber]
            
            if needsTranslation {
                self.translationText.text = "\(findTranslation(currentWord!).capitalized) = \(dataWord.capitalized)"
            } else {
                if sayIfCorrect {
                    self.translationText.text = "\(dataWord.capitalized) is Correct!"
                }
            }
            
            if isWholeThingTrue() {
                hintButton.isHidden = true
                nextLetterButton.isHidden = true
                translationText.text = "You have completed the quiz!"
            }
        }
    }


}
