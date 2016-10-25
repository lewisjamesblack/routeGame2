//
//  GameVC-Borders.swift
//  routeGame2
//
//  Created by Lewis Black on 22/10/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit

extension GameViewController {

    func putBorderOnPreviousSquare(_ square:(Int,Int, BorderType)){
        
        if selectedWords[currentWord!].count == 2 {
            //all four are mistakes that work because it's the first one, not sure why
            
            func setBorder(_ borderType:BorderType){
                selectedWords[currentWord!][0].2 = borderType
            }
            
            switch whereIsSquare(square){
            case SquarePosition.aboveMiddle: setBorder(BorderType.endFromBottom)
            case SquarePosition.belowMiddle: setBorder(BorderType.endFromTop)
            case SquarePosition.middleLeft: setBorder(BorderType.endFromRight)
            case SquarePosition.middleRight: setBorder(BorderType.endFromLeft)
            default: break
            }
            
        } else {
            let previousSquareWord = whatIsPreviousSquareWL(square)?.0
            let previousSquareLetter = whatIsPreviousSquareWL(square)?.1
            
            func changeBorderTypeTo(_ borderType: BorderType) {
                selectedWords[previousSquareWord!][previousSquareLetter!].2 = borderType
            }
            
            let word = whatWordIsSquareIn(square)!.0
            let letter = whatWordIsSquareIn(square)!.1
            if letter > 0 {
                let previousSquare = selectedWords[word][letter - 1]
                let oneBehind = whereIsSquare(square)
                let twoBehind = whereIsSquare(previousSquare)
                if (oneBehind == SquarePosition.aboveMiddle && twoBehind == SquarePosition.aboveMiddle) || (oneBehind == SquarePosition.belowMiddle && twoBehind == SquarePosition.belowMiddle) {
                    changeBorderTypeTo(BorderType.tubeVertical)
                } else if (oneBehind == SquarePosition.middleLeft && twoBehind == SquarePosition.aboveMiddle) || (oneBehind == SquarePosition.belowMiddle && twoBehind == SquarePosition.middleRight) {
                    changeBorderTypeTo(BorderType.cornerTopToRight)
                } else if (oneBehind == SquarePosition.middleRight && twoBehind == SquarePosition.aboveMiddle) || (oneBehind == SquarePosition.belowMiddle && twoBehind == SquarePosition.middleLeft) {
                    changeBorderTypeTo(BorderType.cornerTopToLeft)
                } else if (oneBehind == SquarePosition.middleLeft && twoBehind == SquarePosition.middleLeft) || (oneBehind == SquarePosition.middleRight && twoBehind == SquarePosition.middleRight) {
                    changeBorderTypeTo(BorderType.tubeHorizontal)
                } else if (oneBehind == SquarePosition.middleRight && twoBehind == SquarePosition.belowMiddle) || (oneBehind == SquarePosition.aboveMiddle && twoBehind == SquarePosition.middleLeft) {
                    changeBorderTypeTo(BorderType.cornerBottomToLeft)
                } else if (oneBehind == SquarePosition.middleLeft && twoBehind == SquarePosition.belowMiddle) || (oneBehind == SquarePosition.aboveMiddle && twoBehind == SquarePosition.middleRight) {
                    changeBorderTypeTo(BorderType.cornerBottomToRight)
                }
            } else {
                selectedWords[word][letter].2 = BorderType.circle
            }
        }
    }
    
    
    func putEndBorderOnCurrentSquare(_ square:(Int,Int, BorderType)){
        let oneBehind = whereIsSquare(square)
        let (word,letter) = whatWordIsSquareIn(square)!
        
        func changeBorderTypeTo(_ borderType: BorderType) {
            selectedWords[word][letter].2 = borderType
        }
        
        switch oneBehind {
        case SquarePosition.aboveMiddle: changeBorderTypeTo(BorderType.endFromTop)
        case SquarePosition.belowMiddle: changeBorderTypeTo(BorderType.endFromBottom)
        case SquarePosition.middleLeft: changeBorderTypeTo(BorderType.endFromLeft)
        case SquarePosition.middleRight: changeBorderTypeTo(BorderType.endFromRight)
        default: break
        }
    }
    
    //where is square in relation to square before it
    func whereIsSquare(_ square:(Int,Int, BorderType)) -> SquarePosition {
        
        if let previousSquareI = whatIsPreviousSquareIJ(square)?.0 {
            if let previousSquareJ = whatIsPreviousSquareIJ(square)?.1 {
                
                let iDifference = previousSquareI - square.0
                let jDifference = previousSquareJ - square.1
                
                if iDifference == 1 && jDifference == 1 {
                    return SquarePosition.belowRight
                } else if iDifference == 0 && jDifference == 1 {
                    return SquarePosition.belowMiddle
                } else if iDifference == -1 && jDifference == 1 {
                    return SquarePosition.belowLeft
                } else if iDifference == 1 && jDifference == 0 {
                    return SquarePosition.middleRight
                } else if iDifference == 0 && jDifference == 0 {
                    return SquarePosition.error
                } else if iDifference == -1 && jDifference == 0 {
                    return SquarePosition.middleLeft
                } else if iDifference == 1 && jDifference == -1 {
                    return SquarePosition.aboveRight
                } else if iDifference == 0 && jDifference == -1 {
                    return SquarePosition.aboveMiddle
                } else if iDifference == -1 && jDifference == -1 {
                    return SquarePosition.aboveLeft
                }
            }
        }
        return SquarePosition.error
    }

    
    func whatIsPreviousSquareIJ(_ square:(Int,Int, BorderType)) -> (Int,Int)? {
        let word = whatWordIsSquareIn(square)!.0
        let letter = whatWordIsSquareIn(square)!.1
        
        if letter > 0 {
            return (selectedWords[word][letter - 1].0, selectedWords[word][letter - 1].1)
        }
        return nil
    }
    
    func whatIsPreviousSquareWL(_ square:(Int,Int, BorderType)) -> (Int,Int)? {
        let word = whatWordIsSquareIn(square)!.0
        let letter = whatWordIsSquareIn(square)!.1
        
        if letter > 0 {
            return (word, letter - 1)
        }
        return nil
    }
    
    func whatWordIsSquareIn(_ square:(Int,Int, BorderType)) -> (Int,Int)? {
        for i in 0..<selectedWords.count {
            for j in 0..<selectedWords[i].count {
                if square.0 == selectedWords[i][j].0 && square.1 == selectedWords[i][j].1 {
                    return (i,j)
                }
            }
        }
        return nil
    }
    
    func whatWordIsSquareInCoords(_ square:(Int,Int, BorderType)) -> (Int,Int)? {
        for i in 0..<coordsOfAnswersArray.count {
            for j in 0..<coordsOfAnswersArray[i].count {
                if square.0 == coordsOfAnswersArray[i][j].0 && square.1 == coordsOfAnswersArray[i][j].1 {
                    return (i,j)
                }
            }
        }
        return nil
    }
    
    
    func makeBorders(_ squareView: LetterSquareView, borderType: BorderType){
        squareView.makeViewsFor(borderType, color: color)
    }
    
    // This function makes for 1 if given 2 aswell
    func makeBordersOfLast(_ squares:Int){
        func makeBordersForSquare(_ square:(Int,Int, BorderType)){
            let i = square.0
            let j = square.1
            let borderType = square.2
            let squareView = arrayOfRows[i][j]
            
            makeBorders(squareView, borderType: borderType)
        }
        
        let letterCount = selectedWords[currentWord!].count
        let numberLess = squares - letterCount
        
        if currentWord! >= 0 && numberLess <= 0 && letterCount > 0 {
            for i in 0..<squares {
                makeBordersForSquare(selectedWords[currentWord!][letterCount - 1 - i])
            }
        }
        
        if currentWord! >= 0 && numberLess > 0 && letterCount > 0 {
            for i in 0..<squares - numberLess {
                makeBordersForSquare(selectedWords[currentWord!][letterCount - 1 - i])
            }
        }
    }
    
    

}
