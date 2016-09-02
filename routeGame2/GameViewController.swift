//
//  ViewController.swift
//  routeGame2
//
//  Created by Lewis Black on 18/08/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var translationText: UILabel!
    @IBOutlet weak var scrollButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let numberOfCols = Route().numberOfCols
    let numberOfRows = Route().numberOfRows
    let routeCoOrds = Route().getRoute(0,type: 0)!
    let minWordLengthIfNoSmaller = 4
    let maxWordLengthIfNoBigger = 9
    let dataBeforeTranslation = Data().secondData
    
    var currentColor:Int = 0
    var color:UIColor{
        return colours[abs(currentColor % (colours.count))]
    }
    var arrayOfRows = [[LetterSquareView]]()
    var wordsFound: Array<Bool> = []
    var currentSquare:(Int,Int, BorderType)?
    var currentWord:Int?
    var selectedWords:Array<Array<(Int,Int, BorderType)>> = []
    var isWordBeingSelectedCorrect:Bool = false
    
    //Options
    
    //TranslationText
    var spellOutNameAtBottom:Bool = true //spells it as you go, but not on unselecting yes
    var sayIfCorrect:Bool = true
    var giveTranslation:Bool = true //can be true but will only work if it's a translating one, only if above is true does it work
    //Scrolling
    var scrollingOnlyTwoFinger:Bool = false
    var scrollingButton:Bool = false //if this true the one before becomes false
    //Other
    var deletingWords:Bool = false
    var ifWordIncorrectUnselect:Bool = true
    var stopSelectingIfWordCorrect:Bool = true
    var autoCorrectWord:Bool = true
    
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
        var coordsOfAnswersArray = [[(Int,Int)]]()
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

        
        let characterGridView = CharacterGridView(frame: CGRect(x: 0, y: 0, width: width, height: height), numberOfCols: numberOfCols, numberOfRows: numberOfRows, route: route, answersOneString: answersOneString)
        scrollView.addSubview(characterGridView )
        scrollView.contentSize = CGSize(width: width, height: height)
        
        let arrayOfRows = characterGridView.arrayOfRows
        
        //here is probably where the amazing bit of code to sort scrolling problem will go
        
        
        

      //  characterGridView.addGestureRecognizer(scrollView.panGestureRecognizer)
//        let viewToStopStuff = ViewToStopScrolling(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
//        viewToStopStuff.backgroundColor = UIColor.blueColor()
//        scrollView.addSubview(viewToStopStuff)
//        
       // scrollView.delaysContentTouches = false
        
        
        
        
        
        
        
        if scrollingOnlyTwoFinger {
            scrollView.panGestureRecognizer.minimumNumberOfTouches = 2
        }
        
        if scrollingButton {
            scrollButton.setTitle("Scroll", forState: .Normal)
        } else {
            scrollButton.setTitle("", forState: .Normal)
        }
        
        //Detect Touches
      
        var startPoint:CGPoint?

        func onSquareTouched(touches:Set<UITouch>, startOfTouch:Bool) {
            var square = pointIsInSquare(touches)
            if square != nil && isTouchNewSquare(touches, square: square!) {
                switch whatIsSquare(square!, startOfTouch: startOfTouch).0 {
                case Square.selectedInPreviousWord: square!.2 = whatIsSquare(square!, startOfTouch: startOfTouch).1
                    if startOfTouch && deletingWords {
                        deleteWordQuestion(square!)
                    }
                case Square.selectedInCurrentWord: square!.2 = whatIsSquare(square!, startOfTouch: startOfTouch).1
                    if stopSelectingIfWordCorrect {
                        if isWordBeingSelectedCorrect != true {
                            unselectUpToSquare(square!)
                        }
                    } else {
                        unselectUpToSquare(square!)
                    }
                case Square.unSelectedAllowed: square!.2 = whatIsSquare(square!, startOfTouch: startOfTouch).1
                    selectSquare(square!, startOfTouch:startOfTouch)
                case Square.unSelectedNotAllowed:square!.2 = whatIsSquare(square!, startOfTouch: startOfTouch).1
                }
            }
        }
        
        func makeBordersOfLastTwoSquares(){
            let count = selectedWords.count
            let lastCount = selectedWords[count - 1].count
            if count > 0 {
                makeBordersForSquare(selectedWords[count - 1][lastCount - 1])
                if lastCount > 1 {
                    makeBordersForSquare(selectedWords[count - 1][lastCount - 2])
                }
            }
        }
        
        func makeBordersOfLast(squares:Int){
            let count = selectedWords.count
            let letterCount = selectedWords[count - 1].count
            
            if count > 0 && letterCount - squares >= 0 && letterCount > 0 {
                for i in 0..<squares {
                    makeBordersForSquare(selectedWords[count - 1][letterCount - 1 - i])
                }
            }
        }

        func makeBordersForSquare(square:(Int,Int, BorderType)){
            let i = square.0
            let j = square.1
            let borderType = square.2
            let squareView = arrayOfRows[i][j]
            
            makeBorders(squareView, borderType: borderType)
        }
        
        
        func wordSelectionOver(){
            isWordBeingSelectedCorrect = false

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
                    if stopSelectingIfWordCorrect {
                        if isWordBeingSelectedCorrect{
                            return false
                        }
                    }
                    let newI = square.0
                    let newJ = square.1
                    let lastSquareHighlighted = highLightedWord[highLightedWord.count - 1]
                    let oldI = lastSquareHighlighted.0
                    let oldJ = lastSquareHighlighted.1
                    
                    if  newI > (oldI + 1) || newI < (oldI - 1) || newJ > (oldJ + 1) || newJ < (oldJ - 1) || newI == (oldI + 1) &&  newJ == (oldJ + 1) || newI == (oldI + 1) && newJ == (oldJ - 1) || newI == (oldI - 1) &&  newJ == (oldJ + 1) || newI == (oldI - 1) && newJ == (oldJ - 1) {
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
                let count = selectedWords.count - 1
                
                func setBorder(borderType:BorderType){
                    selectedWords[count][0].2 = borderType
                }
                
                switch whereIsSquare(square){
                case SquarePosition.aboveMiddle: setBorder(BorderType.endFromBottom)
                case SquarePosition.belowMiddle: setBorder(BorderType.endFromTop)
                case SquarePosition.middleLeft: setBorder(BorderType.endFromRight)
                case SquarePosition.middleRight: setBorder(BorderType.endFromLeft)
                default: break
                }
                
//                switch whereIsSquare(square){
//                case .aboveMiddle: setBorder(BorderType.endFromBottom)
//                case .belowMiddle: setBorder(BorderType.endFromTop)
//                case .middleLeft: setBorder(BorderType.endFromRight)
//                case .middleRight: setBorder(BorderType.endFromLeft)
//                default: break
//                }
                

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
            
            switch oneBehind {
            case SquarePosition.aboveMiddle: changeBorderTypeTo(BorderType.endFromTop)
            case SquarePosition.belowMiddle: changeBorderTypeTo(BorderType.endFromBottom)
            case SquarePosition.middleLeft: changeBorderTypeTo(BorderType.endFromLeft)
            case SquarePosition.middleRight: changeBorderTypeTo(BorderType.endFromRight)
            default: break
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
        
        func deleteWordQuestion(square:(Int,Int, BorderType)) {
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
                squareView.lastColor = squareView.selectingView.backgroundColor
                squareView.selectingView.backgroundColor = deleteColourChangeLetterLabelColor
            }
        }
        
        func colourChangeIfDeletionCancelled(word:Int){
            for i in 0..<selectedWords[word].count {
                let square = selectedWords[word][i]
                let squareView = arrayOfRows[square.0][square.1]
                squareView.selectingView.backgroundColor = squareView.lastColor
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
           // makeBordersOfLastTwoSquares()
            makeBordersOfLast(2)
            
            let wordCorrect = isWordCorrect(whatWordIsSquareIn(square)!.0)
            if autoCorrectWord {
                if wordCorrect.2 != nil {
                    var lettersBeingDeleted = wordCorrect.2!
                    let count = lettersBeingDeleted.count
                    putEndBorderOnCurrentSquare(selectedWords.last!.last!)
                    for i in 0..<count {
                        let square = lettersBeingDeleted[i]
                        let i = square.0
                        let j = square.1
                        let squareView = arrayOfRows[i][j]
                        makeBorders(squareView, borderType: BorderType.none)
                    }
                    let wordsCount = selectedWords.count
                    let lettersCount = selectedWords[wordsCount - 1].count
                    if count > 0 {
                        for i in 0..<lettersCount {
                            putBorderOnPreviousSquare(selectedWords[wordsCount - 1][lettersCount - i - 1])
                            print("getting chnage is \(selectedWords[wordsCount - 1][lettersCount - i - 1]))")
                        }
                    }
                    print(selectedWords)
                    makeBordersOfLast(lettersCount - 1)
                }
            }
            
            if spellOutNameAtBottom {
                changeTranslatedText()
            }
            
            if wordCorrect.0 {
                isWordBeingSelectedCorrect = true
                
                let wordNumber = wordCorrect.1!
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
     
        func isWordCorrect(wordIndex:Int) -> (Bool,Int?,[(Int,Int,BorderType)]?,[(Int,Int,BorderType)]?) {
            
            if wordIndex <= selectedWords.count - 1 {
                let word = selectedWords[wordIndex]
                for i in 0..<coordsOfAnswersArray.count {
                    let answerWord = coordsOfAnswersArray[i]
                    if answerWord.count == word.count {
                        var boolArray = [Bool]()
                        for j in 0..<answerWord.count {
                            if autoCorrectWord {
                                func numberInRouteCoOrds(CoOrds:(Int,Int)) -> Int{
                                    var found = 0  // <= will hold the index if it was found, or else will be nil
                                    for i in (0..<routeCoOrds.count) {
                                        if routeCoOrds[i] == CoOrds {
                                            found = i
                                        }
                                    }
                                    return found
                                }
                                let capitalized = answersOneString.capitalizedString
                                let wordLetter = capitalized[capitalized.startIndex.advancedBy(numberInRouteCoOrds((word[j].0, word[j].1)))]
                                let squareLetter = capitalized[capitalized.startIndex.advancedBy(numberInRouteCoOrds(answerWord[j]))]
                              
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
                            //print("bool array all true")
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
                                } else {
                                    print("lettersBeingDeleted \(lettersBeingDeleted)")
                                    print("newAnswerWord \(newAnswerWord)")

                                    return(true, i, lettersBeingDeleted, newAnswerWord)
                                }
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
        
        //translaton text
        translationText.text = ""
        
        func changeTranslatedText(){
            
            if isWordCorrect(currentWord!).0 == false {
                let squares = selectedWords[currentWord!]
                for i in 0..<squares.count {
                    stringWord = stringWord + String(answersOneString[answersOneString.startIndex.advancedBy(route[squares[i].0][squares[i].1])])
                }
                var translation:String
                if giveTranslation && needsTranslation{
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
    
func routeArrayOfRows(array: [(Int,Int)], numberOfRows: Int , numberOfCols: Int) -> [[Int]] {
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