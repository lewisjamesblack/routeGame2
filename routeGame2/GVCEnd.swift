//
//  GVCEnd.swift
//  routeGame2
//
//  Created by Lewis Black on 22/10/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit

extension GameViewController {

    func wordSelectionOver(){
        
        isWordBeingSelectedCorrect = false
        
        if let currentWord = currentWord {
            if isWordCorrect(currentWord).0 == false {
                if selectedWords[currentWord].count < minWordLength {
                    deSelectWord(currentWord)
                }else if ifWordIncorrectUnselect {
                    deSelectWord(currentWord)
                }
                translationText.text = ""
            } else {
                wordSelectedCorrect()
            }
            
        }
        
        currentlySelectingSquare = false
        hintsAskedForSoFar = 0
        currentSquare = nil
        currentWord = nil
    }
    
    func wordSelectedCorrect() {
        unblackOutLetters()
        blackOutLetter()
        
        hintViewHeight.constant = 0
        hintPressedOdd = false
        sameCurrentWord = false
        currentColor += 1
    }
    
    
    func blackOutLetter(){
        if blackOutWrongWords {

            currentlyBlackOut = findLettersToBlack()
            
            for i in stride(from: currentlyBlackOut.count - 1, through: 0, by: -1){
                let square = currentlyBlackOut[i]
                arrayOfRows[square.0][square.1].blackOut()
            }
        }
    }
    
    func unblackOutLetters() {
        if blackOutWrongWords {
            for i in stride(from: currentlyBlackOut.count - 1, through: 0, by: -1){
                let square = currentlyBlackOut[i]
                arrayOfRows[square.0][square.1].unBlackOut()
            }

            currentlyBlackOut = []
        }
    }

    func findLettersToBlack() -> Array<(Int,Int)>{
        if let currentSq = currentSquare {
            
            let x:Int = currentSq.0
            let y:Int = currentSq.1
            var arrayPossible:Array<(Int,Int)> = [(x,y+1),(x,y-1),(x-1,y),(x+1,y)]
            var arrayStarters = [(Int,Int)]()
            
            for i in stride(from: arrayPossible.count - 1, through: 0, by: -1) {
                let s = arrayPossible[i]
                if s.0<0 || s.1<0 || s.0 >= Route().numberOfCols || s.1 >= Route().numberOfRows {
                    arrayPossible.remove(at: i)
                }
            }
            
            for i in 0..<firstSquares.count {
                let square = firstSquares[i]
                for i in stride(from: arrayPossible.count - 1, through: 0, by: -1){
                    let s = arrayPossible[i]
                    if s.0 == square.0 && s.1 == square.1 {
                        arrayStarters.append((s.0,s.1))
                    }
                }
            }

            for i in 0..<selectedWords.count {
                let letter = selectedWords[i].first!
                for i in stride(from: arrayStarters.count - 1, through: 0, by: -1){
                    let s = arrayStarters[i]
                    if s.0 == letter.0 && s.1 == letter.1 {
                        arrayStarters.remove(at: i)
                    }
                }
            }
            
            if let nextLetter = coordsOfAnswersArray[currentWord! + 1].first {
                for i in stride(from: arrayStarters.count - 1, through: 0, by: -1){
                    let s = arrayStarters[i]
                    if s.0 == nextLetter.0 && s.1 == nextLetter.1 {
                        arrayStarters.remove(at: i)
                    }
                }
            }
            return arrayStarters
        }
        return [(Int,Int)]()
    }
    
    
    
    func isWordCorrect(_ wordIndex:Int) -> (Bool,Int?,[(Int,Int,BorderType)]?,[(Int,Int,BorderType)]?) {
        
        if wordIndex <= currentWord! {
            let word = selectedWords[wordIndex]
            for i in 0..<coordsOfAnswersArray.count {
                let answerWord = coordsOfAnswersArray[i]
                if answerWord.count == word.count {
                    var boolArray = [Bool]()
                    for j in 0..<answerWord.count {
                        if autoCorrectWord {
                            func numberInRouteCoOrds(_ CoOrds:(Int,Int)) -> Int{
                                var found = 0  // <= will hold the index if it was found, or else will be nil
                                for i in (0..<routeCoOrds.count) {
                                    if routeCoOrds[i] == CoOrds {
                                        found = i
                                    }
                                }
                                return found
                            }
                            let capitalized = answersOneString.capitalized
                            let wordLetter = capitalized[capitalized.characters.index(capitalized.startIndex, offsetBy: numberInRouteCoOrds((word[j].0, word[j].1)))]
                            let squareLetter = capitalized[capitalized.characters.index(capitalized.startIndex, offsetBy: numberInRouteCoOrds(answerWord[j]))]
                            
                            if wordLetter == squareLetter {
                                boolArray.append(true)
                            } else {
                                boolArray.append(false)
                            }
                        } else {
                            if answerWord[j].0 == word[j].0 && answerWord[j].1 == word[j].1 {
                                boolArray.append(true)
                            } else {
                                boolArray.append(false)
                            }
                        }
                    }
                    
                    if boolArray.contains(false) {
                        
                    } else {
                        if autoCorrectWord {
                            var newAnswerWord:[(Int,Int,BorderType)] = word
                            var lettersBeingDeleted:[(Int,Int,BorderType)] = []
                            for j in 0..<answerWord.count {
                                if answerWord[j].0 != word[j].0 || answerWord[j].1 != word[j].1 {
                                    lettersBeingDeleted.append((word[j].0, word[j].1, word[j].2))
                                    newAnswerWord[j] = (answerWord[j].0, answerWord[j].1, word[j].2)
                                }
                            }
                            
                            selectedWords.removeLast()
                            selectedWords.append(newAnswerWord)
                            if lettersBeingDeleted.count == 0 {
                                return(true, i, nil, newAnswerWord)
                            }
                            return(true, i, lettersBeingDeleted, newAnswerWord)
                            
                        }
                        return(true, i ,nil, nil)
                    }
                }
            }
        }
        return(false, nil, nil, nil)
    }
    
    func isWholeThingTrue() -> Bool {
        for i in 0..<wordsFound.count {
            if wordsFound[i] == false {
                return false
            }
        }
        return true
    }



}
