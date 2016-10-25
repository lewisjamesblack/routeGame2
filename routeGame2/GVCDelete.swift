//
//  GameVC - Delete.swift
//  routeGame2
//
//  Created by Lewis Black on 22/10/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit

extension GameViewController {
    
    func deleteWordQuestion(_ square:(Int,Int, BorderType)) {
        if let j = whatWordIsSquareIn(square) {
            let m = j.0
            deleteWordAlert("Do you want to delete this word?", msg: "Press Ok to delete", word: m)
        }
    }
    
    func deleteWordAlert(_ title: String, msg: String, word:Int) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) in
            self.deSelectWord(word)
        })
        alert.addAction(action)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
            (alertAction: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
            self.colourChangeIfDeletionCancelled(word)
        }))
        
        colourChangeBeforeDeletion(word)
        self.present(alert, animated: true, completion: nil)
    }
    
    func colourChangeBeforeDeletion(_ word:Int){
        for i in 0..<selectedWords[word].count {
            let square = selectedWords[word][i]
            let squareView = arrayOfRows[square.0][square.1]
            squareView.lastColor = squareView.selectingView.backgroundColor
            squareView.selectingView.backgroundColor = deleteColourChangeLetterLabelColor
        }
    }
    
    func colourChangeIfDeletionCancelled(_ word:Int){
        for i in 0..<selectedWords[word].count {
            let square = selectedWords[word][i]
            let squareView = arrayOfRows[square.0][square.1]
            squareView.selectingView.backgroundColor = squareView.lastColor
        }
    }
    
    func deSelectWord(_ word:Int){
        for i in 0..<selectedWords[word].count {
            unHighlightSquare(selectedWords[word][i])
        }
        selectedWords.remove(at: word)
        currentColor -= 1
    }
    
    
    
    
    
    
    
    func unselectUpToSquare(_ square:(Int,Int, BorderType)){
        
        let word:Int = whatWordIsSquareIn(square)!.0
        let letter:Int = whatWordIsSquareIn(square)!.1
        let mostRecentLetter:Int = selectedWords[currentWord!].count - 1
        
        if selectedWords[word].count != 1 {
            if word == currentWord! && letter != mostRecentLetter {
                let letterBeingUnSelected:Int = letter + 1
                let squaresBeingDeleted:ArraySlice<(Int, Int, BorderType)> = selectedWords[word][letterBeingUnSelected...mostRecentLetter]
                
                
                if squaresBeingDeleted.count == 1 {
                    unHighlightSquare(selectedWords[word][letterBeingUnSelected])
                    selectedWords[word].removeLast()
                } else {
                    for i in 0..<selectedWords[word].count {
                        for j in letterBeingUnSelected...letterBeingUnSelected + squaresBeingDeleted.count - 1 {
                            if selectedWords[word][i].0 == squaresBeingDeleted[j].0 && selectedWords[word][i].1 == squaresBeingDeleted[j].1 {
                                unHighlightSquare(selectedWords[word][i])
                            }
                        }
                    }
                    for _ in 0..<squaresBeingDeleted.count {
                        selectedWords[word].removeLast()//rewrite this
                    }
                }
            }
        }
        endOfSelection(square)
    }
    
    
    func unHighlightSquare(_ square:(Int,Int, BorderType)) {
        makeBorders(arrayOfRows[square.0][square.1], borderType: BorderType.none)
    }
    
    
}
