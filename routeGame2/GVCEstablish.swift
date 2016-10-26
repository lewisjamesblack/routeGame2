//
//  GVC-Select.swift
//  routeGame2
//
//  Created by Lewis Black on 22/10/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit

extension GameViewController {
    
    enum Square {
        case selectedInPreviousWord
        case selectedInCurrentWord
        case unSelectedAllowed
        case unSelectedNotAllowed
    }
    
    func whatIsSquare(_ square:(Int,Int, BorderType)) -> (Square,BorderType) {
        
        if isSquareSelected(square).0 {
            if isSelectedSquareInCurrentWord(square) {
                return (Square.selectedInCurrentWord, isSquareSelected(square).1)
            }
            return (Square.selectedInPreviousWord, isSquareSelected(square).1)
        } else {
            if isUnSelectedSquareAllowed(square) {
                return (Square.unSelectedAllowed, BorderType.unknown)
            }
            return (Square.unSelectedNotAllowed, BorderType.unknown)
        }
    }
    
    func isSquareSelected(_ square:(Int,Int, BorderType)) -> (Bool, BorderType) {
        if selectedWords.count != 0 {
            for i in 0..<selectedWords.count {
                for j in 0..<selectedWords[i].count {
                    if square.0 == selectedWords[i][j].0 && square.1 == selectedWords[i][j].1 {
                        return (true, selectedWords[i][j].2)
                    }
                }
            }
        }
        return (false, BorderType.none)
    }
    
    
    func isSelectedSquareInCurrentWord(_ square:(Int,Int, BorderType)) -> Bool {
        
        if let m = whatWordIsSquareIn(square) {
            let word = m.0
            if word == currentWord {
                return true
            }
            return false
        }
        return false
    }
    
    
    func isUnSelectedSquareAllowed(_ square:(Int,Int, BorderType)) -> Bool {
        let newI = square.0
        let newJ = square.1
        
        if blackOutWrongWords {
            for i in 0..<currentlyBlackOut.count {
                if newI == currentlyBlackOut[i].0 && newJ == currentlyBlackOut[i].1 {
                    return false
                }
            }
        }
        
        if currentWord == nil && onlySelectSurroundingLetters {
            let count = selectedWords.count
            if count == 0 {
                if newI == 0 && newJ == 0 {
                    return true
                }
                return false
            } else {
                let highLightedWord = selectedWords[count - 1]
                let lastSquareHighlighted = highLightedWord[highLightedWord.count - 1]
                let oldI = lastSquareHighlighted.0
                let oldJ = lastSquareHighlighted.1
                
                if ((newI == oldI + 1 || newI == oldI - 1)  && newJ == oldJ) || ((newJ == oldJ + 1 || newJ == oldJ - 1)  && newI == oldI) {
                    return true
                }
                return false
            }
        } else if currentWord != nil {
            
            if selectedWords.count != 0 {
                let highLightedWord = selectedWords[currentWord!]
                if highLightedWord.count > maxWordLength - 1 {
                    return false
                }
                if stopSelectingIfWordCorrect {
                    if isWordBeingSelectedCorrect{
                        return false
                    }
                }
                let lastSquareHighlighted = highLightedWord[highLightedWord.count - 1]
                let oldI = lastSquareHighlighted.0
                let oldJ = lastSquareHighlighted.1
                
                if  newI > (oldI + 1) || newI < (oldI - 1) || newJ > (oldJ + 1) || newJ < (oldJ - 1) || newI == (oldI + 1) &&  newJ == (oldJ + 1) || newI == (oldI + 1) && newJ == (oldJ - 1) || newI == (oldI - 1) &&  newJ == (oldJ + 1) || newI == (oldI - 1) && newJ == (oldJ - 1) {
                    return false
                }
            }
            return true
        }
        return true
    }
    


}
