//
//  ViewController.swift
//  routeGame2
//
//  Created by Lewis Black on 18/08/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var translationText: UILabel!
    @IBOutlet weak var scrollButton: UIButton!
    
    let numberOfCols = Route().numberOfCols
    let numberOfRows = Route().numberOfRows
    let routeCoOrds = Route().getRoute(0,type: 0)!
    let minWordLengthIfNoSmaller = 4
    let maxWordLengthIfNoBigger = 9
    let dataBeforeTranslation = Data().firstData
    
    var currentColor:Int = 0
    var color:UIColor{
        return colours[abs(currentColor % (colours.count))]
    }
    var arrayOfRows:Array<Array<LetterSquareView>> = []
    var wordsFound: Array<Bool> = []
    var currentSquare:(Int,Int, BorderType)?
    var currentWord:Int?
    var selectedWords:Array<Array<(Int,Int, BorderType)>> = []
    var selectedPoints: Array<(Int,Int, BorderType)> {
        var selectedPoints:Array<(Int,Int, BorderType)> = []
        if selectedWords.count != 0 {
            for i in 0..<selectedWords.count {
                for x in 0..<selectedWords[i].count{
                    selectedPoints.append(selectedWords[i][x])
                }
            }
        }
        return selectedPoints
    }
    
    //Options
    
    //TranslationText
    var spellOutNameAtBottom:Bool = true //spells it as you go, but not on unselecting yes
    var sayIfCorrect:Bool = true
    var giveTranslation:Bool = false //can be true but will only work if it's a translating one, only if above is true does it work
    //Scrolling
    var scrollingOnlyTwoFinger:Bool = false
    var scrollingButton:Bool = true // counters the one before it
    //Other
    var ifWordIncorrectUnselect:Bool = true
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        //Calculate Constants

        let needsTranslation:Bool = (dataBeforeTranslation[1] as! Bool)
        let height = firstLetterDistanceFromTop * 2 + letterSquareViewHeight * CGFloat(numberOfRows)
        let width = firstLetterDistanceFromSide * 2 + letterSquareViewWidth * CGFloat(numberOfCols)
        
        func makeData() -> String {
            if needsTranslation {
                return Data().toDataString(dataBeforeTranslation[0] as! String, dataUsed: true)
            } else {
                return dataBeforeTranslation[0] as! String
            }
        }
        
        let data = makeData()
        let answersArray = Data().makeArrayOfAnswers(data)
        
        
        func maxWordLengthFunc() -> Int {
            var maxWordSoFar = maxWordLengthIfNoBigger
            for i in 0..<answersArray.count{
                if answersArray[i].characters.count > maxWordSoFar {
                    maxWordSoFar = answersArray[i].characters.count
                }
            }
            return maxWordSoFar
        }
        
        func minWordLengthFunc() -> Int {
            var minWordSoFar = minWordLengthIfNoSmaller
            for i in 0..<answersArray.count{
                if answersArray[i].characters.count < minWordSoFar {
                    minWordSoFar = answersArray[i].characters.count
                }
            }
            return minWordSoFar
        }
        
        let minWordLength = minWordLengthFunc()
        let maxWordLength = maxWordLengthFunc()
        
        var wordStart = 0
        var coordsOfAnswersArray:Array<Array<(Int,Int)>> = []
        let answersOneString = answersArray.joinWithSeparator("")
        let route = routeArrayOfRows(routeCoOrds, numberOfRows: numberOfRows, numberOfCols: numberOfCols)
        var wordsFound = [Bool](count: answersArray.count, repeatedValue: false)
        var stringWord:String = ""
        
        for i in 0..<answersArray.count{
            let wordLength = answersArray[i].characters.count
            let array = Array(routeCoOrds[wordStart...wordStart + wordLength - 1])
            coordsOfAnswersArray.append(array)
            wordStart += wordLength
        }
        
        
       
        
        
        //Make Grid
        
        scrollView.canCancelContentTouches = false

        if scrollingOnlyTwoFinger {
            scrollView.panGestureRecognizer.minimumNumberOfTouches = 2
        }
        
        if scrollingButton {
            scrollButton.setTitle("Scroll", forState: .Normal)
        } else {
            scrollButton.setTitle("", forState: .Normal)
        }
        
        let characterGridView = CharacterGridView(frame: CGRect(x: 0, y: 0, width: width, height: height), numberOfCols: numberOfCols, numberOfRows: numberOfRows, route: route, answersOneString: answersOneString)
        scrollView.addSubview(characterGridView )
        scrollView.contentSize = CGSize(width: width, height: height)
        
        let arrayOfRows = characterGridView.arrayOfRows
        
        //Detect Touches
      
        var startPoint:CGPoint?

        func onSquareTouched(touches:Set<UITouch>, startOfTouch:Bool) {
            var square = pointIsInSquare(touches)
            if square != nil {
                
                if isTouchNewSquare(touches, square: square!) {
                    if whatIsSquare(square!, startOfTouch: startOfTouch).0 == Square.selectedInPreviousWord {
                        square!.2 = whatIsSquare(square!, startOfTouch: startOfTouch).1
                        if startOfTouch {
                            undoWordQuestion(square!)
                        }
                    } else if whatIsSquare(square!, startOfTouch: startOfTouch).0 == Square.selectedInCurrentWord {
                        square!.2 = whatIsSquare(square!, startOfTouch: startOfTouch).1
                        unselectUpToSquare(square!)
                        
                    } else if whatIsSquare(square!, startOfTouch: startOfTouch).0 == Square.unSelectedAllowed {
                        square!.2 = whatIsSquare(square!, startOfTouch: startOfTouch).1
                        selectSquare(square!, startOfTouch:startOfTouch)
                    } else if whatIsSquare(square!, startOfTouch: startOfTouch).0 == Square.unSelectedNotAllowed {
                        square!.2 = whatIsSquare(square!, startOfTouch: startOfTouch).1
                    }
                }
            }
        }
        
        func makeBordersOfLastTwoSquares(){
            
            func makeBordersForSquare(square:(Int,Int, BorderType)){
                let i = square.0
                let j = square.1
                let borderType = square.2
                let squareView = arrayOfRows[i][j]
                
                makeBorders(squareView, borderType: borderType)
            }
            
            if selectedWords.count > 0 {
                makeBordersForSquare(selectedWords[selectedWords.count - 1][selectedWords[selectedWords.count - 1].count - 1])
                if selectedWords[selectedWords.count - 1].count > 1 {
                    makeBordersForSquare(selectedWords[selectedWords.count - 1][selectedWords[selectedWords.count - 1].count - 2])
                }
            }
        }

        
        
        
        func wordSelectionOver(){
            
            if currentWord != nil {
                
                if isWordCorrect(currentWord!).0 == false {
                    if selectedWords[currentWord!].count < minWordLength {
                        deSelectWord(currentWord!)
                    }else if ifWordIncorrectUnselect {
                        deSelectWord(currentWord!)
                    }
                    translationText.text = ""
                } else {
                    currentColor += 1
                }
            }
            
            currentSquare = nil
            currentWord = nil
        }

        //Establish where touch is
        
        func pointIsInSquare(touches:Set<UITouch>) -> (Int,Int,BorderType)?{
            if let touch = touches.first {
                startPoint = touch.locationInView(characterGridView)
                var m:Int = 0
                var n:Int = 0
                for i in 0...numberOfCols - 1 {
                    let beforeWidth:CGFloat = (firstLetterDistanceFromSide + CGFloat(i) * letterSquareViewWidth)
                    let afterWidth:CGFloat = (firstLetterDistanceFromSide + (CGFloat(i) + 1) * letterSquareViewWidth)
                    if beforeWidth < startPoint!.x && startPoint!.x <= afterWidth {
                        m = i
                    }
                }
                for j in 0...numberOfRows - 1 {
                    let beforeHeight:CGFloat = (firstLetterDistanceFromTop + CGFloat(j) * letterSquareViewHeight)
                    let afterHeight:CGFloat = (firstLetterDistanceFromTop + (CGFloat(j) + 1) * letterSquareViewHeight)
                    if beforeHeight < startPoint!.y && startPoint!.y <= afterHeight {
                        n = j
                    }
                }
                return (m,n,BorderType.unknown)
            }
            return nil
        }

        func isTouchNewSquare(touches:Set<UITouch>, square:(Int,Int, BorderType)) -> Bool {
            if currentSquare != nil {
                if square == currentSquare! {
                    return false
                }
                currentSquare = square
                
                return true
            }
            currentSquare = square
            return true
        }
        
        
        
        

        //Establish what square is
        
        enum Square {
            case selectedInPreviousWord
            case selectedInCurrentWord
            case unSelectedAllowed
            case unSelectedNotAllowed
        }
        
        func whatIsSquare(square:(Int,Int, BorderType), startOfTouch: Bool) -> (Square,BorderType) {
            
            if isSquareSelected(square).0 {
                if isSelectedSquareInCurrentWord(square, startOfTouch: startOfTouch) {
                    
                    return (Square.selectedInCurrentWord, isSquareSelected(square).1)
                }
                return (Square.selectedInPreviousWord, isSquareSelected(square).1)
            } else {
                if isUnSelectedSquareAllowed(square, startOfTouch: startOfTouch) {
                    return (Square.unSelectedAllowed, BorderType.unknown)
                }
                return (Square.unSelectedNotAllowed, BorderType.unknown)
            }
        }
        
        func isSquareSelected(square:(Int,Int, BorderType)) -> (Bool, BorderType) {
            if selectedWords.count != 0 {
                for i in 0..<selectedPoints.count {
                    if square.0 == selectedPoints[i].0 && square.1 == selectedPoints[i].1 {
                        
                        return (true, selectedPoints[i].2)
                    }
                }
            }
            return (false, BorderType.none)
        }
        
        
        func isSelectedSquareInCurrentWord(square:(Int,Int, BorderType), startOfTouch: Bool) -> Bool {
            
            if let m = whatWordIsSquareIn(square) {
                let word = m.0
                if word == currentWord {
                    return true
                }
                return false
            }
            return false
        }
        
        func whatWordIsSquareIn(square:(Int,Int, BorderType)) -> (Int,Int)? {
            for i in 0..<selectedWords.count {
                for j in 0..<selectedWords[i].count {
                    if square.0 == selectedWords[i][j].0 && square.1 == selectedWords[i][j].1 {
                        return (i,j)
                    }
                }
            }
            return nil
        }
        
        func isUnSelectedSquareAllowed(square:(Int,Int, BorderType), startOfTouch: Bool) -> Bool {
            if startOfTouch != true {
                if selectedWords.count != 0 {
                    let highLightedWord = selectedWords[selectedWords.count - 1]
                    if highLightedWord.count > maxWordLength - 1 {
                        return false
                    }
                    
                    let newI = square.0
                    let newJ = square.1
                    let lastSquareHighlighted = highLightedWord[highLightedWord.count - 1]
                    let oldI = lastSquareHighlighted.0
                    let oldJ = lastSquareHighlighted.1
                    
                    if  newI > (oldI + 1) || newI < (oldI - 1) || newJ > (oldJ + 1) || newJ < (oldJ - 1) {
                        return false
                    }
                    if newI == (oldI + 1) &&  newJ == (oldJ + 1){
                        return false
                    }
                    if newI == (oldI + 1) && newJ == (oldJ - 1) {
                        return false
                    }
                    if newI == (oldI - 1) &&  newJ == (oldJ + 1) {
                        return false
                    }
                    if newI == (oldI - 1) && newJ == (oldJ - 1) {
                        return false
                    }
                }
            }
            return true
        }
        
        //Do stuff with square
        //Select
        func selectSquare(square:(Int,Int, BorderType), startOfTouch: Bool){
            if startOfTouch {
                if selectedWords.count == 0 {
                    selectedWords = [[square]]
                } else  {
                    selectedWords.append([square])
                }
                currentWord = selectedWords.count - 1
            } else {
                selectedWords[selectedWords.count - 1].append(square)
            }
            endOfSelection(square)
        }
        
        func putBorderOnPreviousSquare(square:(Int,Int, BorderType)){
            if selectedWords[selectedWords.count - 1].count == 2 {
                //all four are mistakes that work because it's the first one, not sure why
                if whereIsSquare(square) == SquarePosition.aboveMiddle {
                    selectedWords[selectedWords.count - 1][0].2 = BorderType.endFromBottom
                } else if whereIsSquare(square) == SquarePosition.belowMiddle {
                    selectedWords[selectedWords.count - 1][0].2 = BorderType.endFromTop
                } else if whereIsSquare(square) == SquarePosition.middleLeft {
                    selectedWords[selectedWords.count - 1][0].2 = BorderType.endFromRight
                } else if whereIsSquare(square) == SquarePosition.middleRight {
                    selectedWords[selectedWords.count - 1][0].2 = BorderType.endFromLeft
                }
            } else {
                let previousSquareWord = whatIsPreviousSquareWL(square)?.0
                let previousSquareLetter = whatIsPreviousSquareWL(square)?.1
                
                func changeBorderTypeTo(borderType: BorderType) {
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
                }
            }
        }
        

        func putEndBorderOnCurrentSquare(square:(Int,Int, BorderType)){
            let oneBehind = whereIsSquare(square)
            let (word,letter) = whatWordIsSquareIn(square)!
            
            func changeBorderTypeTo(borderType: BorderType) {
                selectedWords[word][letter].2 = borderType
            }
            
            if oneBehind == SquarePosition.aboveMiddle {
                changeBorderTypeTo(BorderType.endFromTop)
            } else if oneBehind == SquarePosition.belowMiddle {
                changeBorderTypeTo(BorderType.endFromBottom)
            } else if oneBehind == SquarePosition.middleLeft {
                changeBorderTypeTo(BorderType.endFromLeft)
            } else if oneBehind == SquarePosition.middleRight {
                changeBorderTypeTo(BorderType.endFromRight)
            }
        }

        func whatIsPreviousSquareIJ(square:(Int,Int, BorderType)) -> (Int,Int)? {
            let word = whatWordIsSquareIn(square)!.0
            let letter = whatWordIsSquareIn(square)!.1
            if letter > 0 {
                return (selectedWords[word][letter - 1].0, selectedWords[word][letter - 1].1)
            }
            return nil
        }
        
        func whatIsPreviousSquareWL(square:(Int,Int, BorderType)) -> (Int,Int)? {
            let word = whatWordIsSquareIn(square)!.0
            let letter = whatWordIsSquareIn(square)!.1
            
            if letter > 0 {
                return (word, letter - 1)
            }
            return nil
        }
        
        
        //where is square in relation to square before it
        func whereIsSquare(square:(Int,Int, BorderType)) -> SquarePosition {
            
            if let previousSquareI = whatIsPreviousSquareIJ(square)?.0 {
                if let previousSquareJ = whatIsPreviousSquareIJ(square)?.1 {
                   
                    let iDifference = previousSquareI - square.0
                    let jDiffernce = previousSquareJ - square.1
                    
                    if iDifference == 1 && jDiffernce == 1 {
                        return SquarePosition.belowRight
                    } else if iDifference == 0 && jDiffernce == 1 {
                        return SquarePosition.belowMiddle
                    } else if iDifference == -1 && jDiffernce == 1 {
                        return SquarePosition.belowLeft
                    } else if iDifference == 1 && jDiffernce == 0 {
                        return SquarePosition.middleRight
                    } else if iDifference == 0 && jDiffernce == 0 {
                        return SquarePosition.error
                    } else if iDifference == -1 && jDiffernce == 0 {
                        return SquarePosition.middleLeft
                    } else if iDifference == 1 && jDiffernce == -1 {
                        return SquarePosition.aboveRight
                    } else if iDifference == 0 && jDiffernce == -1 {
                        return SquarePosition.aboveMiddle
                    } else if iDifference == -1 && jDiffernce == -1 {
                        return SquarePosition.aboveLeft
                    }
                }
            }
            return SquarePosition.error
            
        }
        
        enum SquarePosition {
            case aboveLeft
            case aboveMiddle
            case aboveRight
            case middleLeft
            case middleRight
            case belowLeft
            case belowMiddle
            case belowRight
            
            case error
        }
        
        //Delete
        
        func undoWordQuestion(square:(Int,Int, BorderType)) {
            if let j = whatWordIsSquareIn(square) {
                let m = j.0
                deleteWordAlert("Do you want to delete this word?", msg: "Press Ok to delete", word: m)
                
            }
        }

        func deleteWordAlert(title: String, msg: String, word:Int) {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: {(alert: UIAlertAction!) in
                deSelectWord(word)
            })
            alert.addAction(action)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
                (alertAction: UIAlertAction!) in
                alert.dismissViewControllerAnimated(true, completion: nil)
                colourChangeIfDeletionCancelled(word)
            }))
            
            
            let rootViewController: UIViewController = UIApplication.sharedApplication().windows[0].rootViewController!
            colourChangeBeforeDeletion(word)
            
            rootViewController.presentViewController(alert, animated: true, completion: nil)
        }
        
        func deSelectWord(word:Int){
            
            for i in 0..<selectedWords[word].count {
                unHighlightSquare(selectedWords[word][i])
            }
            selectedWords.removeAtIndex(word)
            currentColor -= 1
        }
        
        func unHighlightSquare(square:(Int,Int, BorderType)) {
            makeBorders(arrayOfRows[square.0][square.1], borderType: BorderType.none)
        }
        
        func colourChangeBeforeDeletion(word:Int){
            for i in 0..<selectedWords[word].count {
                let square = selectedWords[word][i]
                let squareView = arrayOfRows[square.0][square.1]
                squareView.lastColor = squareView.newView.backgroundColor
                squareView.newView.backgroundColor = deleteColourChangeLetterLabelColor
            }
        }
        
        func colourChangeIfDeletionCancelled(word:Int){
            for i in 0..<selectedWords[word].count {
                let square = selectedWords[word][i]
                let squareView = arrayOfRows[square.0][square.1]
                squareView.newView.backgroundColor = squareView.lastColor
            }
        }

        //Deselect
        
        
        func unselectUpToSquare(square:(Int,Int, BorderType)){
            
            let word = whatWordIsSquareIn(square)!.0
            let letter = whatWordIsSquareIn(square)!.1
            let mostRecentWord = selectedWords.count - 1
            let mostRecentLetter = selectedWords[mostRecentWord].count - 1
            
            if selectedWords[word].count != 1 {
                if word == mostRecentWord && letter != mostRecentLetter {
                    let letterBeingUnSelected = letter + 1
                    let squaresBeingDeleted = selectedWords[word][letterBeingUnSelected...mostRecentLetter]
                    
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
        

        
        func endOfSelection(square:(Int,Int, BorderType)){
            
            putBorderOnPreviousSquare(square)
            putEndBorderOnCurrentSquare(square)
            makeBordersOfLastTwoSquares()

            let word = whatWordIsSquareIn(square)!.0
            
            if spellOutNameAtBottom {
                    changeTranslatedText()
            }
            if isWordCorrect(word).0 {
                let wordNumber = isWordCorrect(word).1!
                wordsFound[wordNumber] = true
                
                let dataWord = answersArray[wordNumber]
                if needsTranslation {
                    self.translationText.text = "\(findTranslation(self.currentWord!).capitalizedString) = \(dataWord.capitalizedString)"
                } else {
                    if sayIfCorrect {
                        self.translationText.text = "\(dataWord.capitalizedString) IS CORRECT!"
                    }
                }
                
                if isWholeThingTrue() {
                    translationText.text = "Whole thing true"
                }
            }
        }
        
        

        // check if Words correct
     
        
        
        
        func isWordCorrect(wordIndex:Int) -> (Bool,Int?) {
            
            if wordIndex <= selectedWords.count - 1 {
                let word = selectedWords[wordIndex]
                
                for i in 0..<coordsOfAnswersArray.count {
                    let answerWord = coordsOfAnswersArray[i]
                    if answerWord.count == word.count {
                        var boolArray:Array<Bool> = []
                        for j in 0..<answerWord.count {
                            if answerWord[j].0 == word[j].0 && answerWord[j].1 == word[j].1 {
                                boolArray.append(true)
                                
                            } else {
                                boolArray.append(false)
                            }
                        }
                        if boolArray.contains(false) {
                        } else {
                            return(true,i)
                        }
                    }
                }
            }
            return(false,nil)
            
        }
        
        func isWholeThingTrue() -> Bool {
            for i in 0..<wordsFound.count {
                if wordsFound[i] == false {
                    return false
                }
            }
            return true
        }
        
        //translaton text
        translationText.text = ""
        
        func changeTranslatedText(){
            
            if isWordCorrect(currentWord!).0 == false {
                let squares = selectedWords[currentWord!]
                for i in 0..<squares.count {
                    stringWord = stringWord + String(answersOneString[answersOneString.startIndex.advancedBy(route[squares[i].0][squares[i].1])])
                }
                var translation:String
                if giveTranslation {
                    translation = "\(findTranslation(currentWord!)) = "
                } else {
                    translation = ""
                }
                translationText.text = "\(translation)\(stringWord.capitalizedString)"
                
            }
            stringWord = ""
        }

        func findTranslation(wordNumber:Int) -> String{
           return Data().makeArrayOfAnswers(Data().toDataString(self.dataBeforeTranslation[0] as! String, dataUsed: false))[currentWord!]
        }
        

        //border configs
        
        func makeBorders(squareView: LetterSquareView, borderType: BorderType){
            squareView.makeViewsFor(borderType, color: color)
        }
    
       
        
        NSNotificationCenter.defaultCenter().addObserverForName(TOUCH_BEGAN, object: nil, queue: nil, usingBlock: {( notification ) -> Void in
            if let touches: Set<UITouch> = notification.object as! Set<UITouch>? {
                self.scrollView.scrollEnabled = false
                onSquareTouched(touches, startOfTouch:true)
            }
        })
        
        NSNotificationCenter.defaultCenter().addObserverForName(TOUCH_MOVED, object: nil, queue: nil, usingBlock: {( notification ) -> Void in
            if let touches: Set<UITouch> = notification.object as! Set<UITouch>? {
                self.scrollView.scrollEnabled = false
                onSquareTouched(touches, startOfTouch:false)
            }
        })
        
        NSNotificationCenter.defaultCenter().addObserverForName(TOUCH_ENDED, object: nil, queue: nil, usingBlock: {( notification ) -> Void in
            self.scrollView.scrollEnabled = true
            wordSelectionOver()
        })
        
       
        
    }
    
    
    @IBAction func onButtonPressed(sender: AnyObject) {
            if scrollView.panGestureRecognizer.minimumNumberOfTouches == 1 {
                scrollButton.setTitle("Choose", forState: .Normal)
                scrollView.panGestureRecognizer.minimumNumberOfTouches = 2
            } else if scrollView.panGestureRecognizer.minimumNumberOfTouches == 2 {
                scrollButton.setTitle("Scroll", forState: .Normal)
                scrollView.panGestureRecognizer.minimumNumberOfTouches = 1
            }
    }
    
    
    
    

}
    
    func routeArrayOfRows(array: Array<(Int,Int)>, numberOfRows: Int , numberOfCols: Int) -> Array<Array<Int>> {
        var arrayOfRows = [[Int]](count: numberOfRows, repeatedValue: [Int](count: numberOfCols, repeatedValue: 0))
        for m in 0...array.count-1 {
            let i = array[m].0
            let j = array[m].1
            
            arrayOfRows[i][j] = m
        }
        return arrayOfRows
    }



enum BorderType {
    case endFromTop
    case endFromLeft
    case endFromRight
    case endFromBottom
    
    case tubeVertical
    case tubeHorizontal
    
    case cornerTopToLeft
    case cornerTopToRight
    case cornerBottomToLeft
    case cornerBottomToRight
    
    case none
    
    case unknown
}