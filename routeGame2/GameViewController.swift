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
    @IBOutlet weak var nextLetterButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var game:Game!
    var currentColor:Int = 0
    var color:UIColor{
        return colours[abs(currentColor % (colours.count))]
    }
    var arrayOfRows = [[LetterSquareView]]()
    var wordsFound: Array<Bool> = []
    var currentSquare:(Int,Int, BorderType)?
    var selectedWords:Array<Array<(Int,Int, BorderType)>> = []
    var isWordBeingSelectedCorrect:Bool = false
    var coordsOfAnswersArray = [[(Int,Int)]]()
    var hintsAskedForSoFar:Int = 0
    var characterGridView:CharacterGridView?
    var needsTranslation:Bool = false
    var answersArray: Array<String> = []
    var routeCoOrds: [(Int, Int)] = []
    var answersOneString: String = ""
    var route: [[Int]] = []
    var stringWord:String = "" //could be problem
    var dataBeforeTranslation: [AnyObject] = []
    var minWordLength: Int = 0
    var maxWordLength: Int = 0
    var startPoint:CGPoint?
    var numberOfCols: Int = 0
    var numberOfRows: Int = 0
    var currentlySelectingSquare: Bool = false
    var currentWord:Int?
    
    //Options
    
    //TranslationText
    var spellOutNameAtBottom:Bool = true //spells it as you go, but not on unselecting yes
    var sayIfCorrect:Bool = true
    var giveTranslation:Bool = true //can be true but will only work if it's a translating one, only if above is true does it work
    //Scrolling
    var scrollingOnlyTwoFinger:Bool = false
    var scrollingButton:Bool = false //if this true the one before becomes false
    //Hints
    var showNextLetterButton:Bool = true
    //Other
    var deletingWords:Bool = false //potentially fucks things up if true & things are being corrected
    var ifWordIncorrectUnselect:Bool = true
    var stopSelectingIfWordCorrect:Bool = true
    var autoCorrectWord:Bool = true
    var onlySelectSurroundingLetters:Bool = true //basically only select the letters above/below/sides of last letter
    
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //Calculate Constants

        numberOfCols = game.numberOfCols
        numberOfRows = game.numberOfRows
        routeCoOrds = game.routeCoOrds
        let minWordLengthIfNoSmaller = game.minWordLengthIfNoSmaller
        let maxWordLengthIfNoBigger = game.maxWordLengthIfNoBigger
        dataBeforeTranslation = game.dataBeforeTranslation
        
        needsTranslation = (dataBeforeTranslation[1] as! Bool)
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
        answersArray = Data().makeArrayOfAnswers(data)
        
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
        
        minWordLength = minWordLengthFunc()
        maxWordLength = maxWordLengthFunc()
        
        var wordStart = 0
        answersOneString = answersArray.joined(separator: "")
        route = routeArrayOfRows(routeCoOrds, numberOfRows: numberOfRows, numberOfCols: numberOfCols)
        wordsFound = [Bool](repeating: false, count: answersArray.count)
        
        for i in 0..<answersArray.count{
            let wordLength = answersArray[i].characters.count
            let array = Array(routeCoOrds[wordStart...wordStart + wordLength - 1])
            coordsOfAnswersArray.append(array)
            wordStart += wordLength
        }
        
        //Make Grid
        
        characterGridView = CharacterGridView(frame: CGRect(x: 0, y: 0, width: width, height: height), numberOfCols: numberOfCols, numberOfRows: numberOfRows, route: route, answersOneString: answersOneString)
        scrollView.addSubview(characterGridView!)
        scrollView.contentSize = CGSize(width: width, height: height)
        
        if showNextLetterButton == false {
            nextLetterButton.isHidden = true
        }
        
        arrayOfRows = characterGridView!.arrayOfRows
        
        
        if scrollingOnlyTwoFinger {
            scrollView.panGestureRecognizer.minimumNumberOfTouches = 2
        }
        
        if scrollingButton {
            scrollButton.setTitle("Scroll", for: UIControlState())
        } else {
            scrollButton.isHidden = true
        }
        
        translationText.text = ""

        //Detect Touches

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: TOUCH_BEGAN), object: nil, queue: nil, using: {( notification ) -> Void in
            if let touches: Set<UITouch> = notification.object as! Set<UITouch>? {
                self.scrollView.isScrollEnabled = false
                self.onSquareTouched(touches, startOfTouch:true)
            }
        })
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: TOUCH_MOVED), object: nil, queue: nil, using: {( notification ) -> Void in
            if let touches: Set<UITouch> = notification.object as! Set<UITouch>? {
                self.scrollView.isScrollEnabled = false
                self.onSquareTouched(touches, startOfTouch:false)
            }
        })
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: TOUCH_ENDED), object: nil, queue: nil, using: {( notification ) -> Void in
            self.scrollView.isScrollEnabled = true
            self.wordSelectionOver()
        })

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil, queue: nil, using: {( notification ) -> Void in
//            print("currentWord = \(self.currentWord)")
//            print("selectedWords = \(self.selectedWords)")

            self.deSelectWord(self.currentWord!)
            self.scrollView.isScrollEnabled = true

            self.currentlySelectingSquare = false
            self.hintsAskedForSoFar = 0
            self.currentSquare = nil
            self.currentWord = nil
            self.translationText.text = ""

        })
        
//        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.printVariable), userInfo: nil, repeats: true)
//        
//       
        
    }
    
    
//    func printVariable() {
//        print(currentlySelectingSquare)
//    }
    

    
    
    func onSquareTouched(_ touches:Set<UITouch>, startOfTouch:Bool) {
        var square = pointIsInSquare(touches)
        if square != nil && isTouchNewSquare(touches, square: square!) {
            switch whatIsSquare(square!).0 {
            case Square.selectedInPreviousWord: square!.2 = whatIsSquare(square!).1
            if startOfTouch && deletingWords {
                deleteWordQuestion(square!)
                }
            case Square.selectedInCurrentWord: square!.2 = whatIsSquare(square!).1
            if stopSelectingIfWordCorrect {
                if isWordBeingSelectedCorrect != true {
                    unselectUpToSquare(square!)
                }
            } else {
                unselectUpToSquare(square!)
                }
            case Square.unSelectedAllowed: square!.2 = whatIsSquare(square!).1
            currentlySelectingSquare = true
            selectSquare(square!, startOfTouch:startOfTouch)
            case Square.unSelectedNotAllowed:square!.2 = whatIsSquare(square!).1
            }
        }
    }
    
    //Establish where touch is
    
    func pointIsInSquare(_ touches:Set<UITouch>) -> (Int,Int,BorderType)?{
        if let touch = touches.first {
            startPoint = touch.location(in: characterGridView)
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
    
    func isTouchNewSquare(_ touches:Set<UITouch>, square:(Int,Int, BorderType)) -> Bool {
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
    
    //Delete
    
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
    
    //Deselect
    
    
    func unselectUpToSquare(_ square:(Int,Int, BorderType)){
        
        let word = whatWordIsSquareIn(square)!.0
        let letter = whatWordIsSquareIn(square)!.1
        let mostRecentLetter = selectedWords[currentWord!].count - 1
        
        if selectedWords[word].count != 1 {
            if word == currentWord! && letter != mostRecentLetter {
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
                currentColor += 1
            }
        }
        
        currentlySelectingSquare = false
        hintsAskedForSoFar = 0
        currentSquare = nil
        currentWord = nil
    }
    
    
    func deSelectWord(_ word:Int){
        for i in 0..<selectedWords[word].count {
            unHighlightSquare(selectedWords[word][i])
        }
        selectedWords.remove(at: word)
        currentColor -= 1
    }
    
    func unHighlightSquare(_ square:(Int,Int, BorderType)) {
        makeBorders(arrayOfRows[square.0][square.1], borderType: BorderType.none)
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
    
    
    
    
    func endOfSelection(_ square:(Int,Int, BorderType)){
        putBorderOnPreviousSquare(square)
        putEndBorderOnCurrentSquare(square)
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
                let lettersCount = selectedWords[currentWord!].count
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

            let wordNumber = wordCorrect.1!
            
            wordsFound[wordNumber] = true

            let dataWord = answersArray[wordNumber]

            if needsTranslation {
                self.translationText.text = "\(findTranslation(currentWord!).capitalized) = \(dataWord.capitalized)"
            } else {
                if sayIfCorrect {
                    self.translationText.text = "\(dataWord.capitalized) IS CORRECT!"
                }
            }

            if isWholeThingTrue() {
                translationText.text = "Whole thing true"
            }
        }
    }
    // don't need word number maybe
    func findTranslation(_ wordNumber:Int) -> String{
        return Data().makeArrayOfAnswers(Data().toDataString(dataBeforeTranslation[0] as! String, dataUsed: false))[currentWord!]
    }
    
    func changeTranslatedText(){
        
        if isWordCorrect(currentWord!).0 == false {
            let squares = selectedWords[currentWord!]
            for i in 0..<squares.count {
                stringWord = stringWord + String(answersOneString[answersOneString.characters.index(answersOneString.startIndex, offsetBy: route[squares[i].0][squares[i].1])])
            }
            var translation:String
            if giveTranslation && needsTranslation{
                translation = "\(findTranslation(currentWord!)) = "
            } else {
                translation = ""
            }
            translationText.text = "\(translation)\(stringWord.capitalized)"
            
        }
        stringWord = ""
    }
    
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
    
    
    func routeArrayOfRows(_ array: [(Int,Int)], numberOfRows: Int , numberOfCols: Int) -> [[Int]] {
        var arrayOfRows = [[Int]](repeating: [Int](repeating: 0, count: numberOfCols), count: numberOfRows)
        for m in 0...array.count-1 {
            let i = array[m].0
            let j = array[m].1
            
            arrayOfRows[i][j] = m
        }
        return arrayOfRows
    }
    
    
    
    @IBAction func onButtonPressed(_ sender: AnyObject) {
        if scrollView.panGestureRecognizer.minimumNumberOfTouches == 1 {
            scrollButton.setTitle("Choose", for: UIControlState())
            scrollView.panGestureRecognizer.minimumNumberOfTouches = 2
        } else if scrollView.panGestureRecognizer.minimumNumberOfTouches == 2 {
            scrollButton.setTitle("Scroll", for: UIControlState())
            scrollView.panGestureRecognizer.minimumNumberOfTouches = 1
        }
    }
    
    @IBAction func nextLetterButtonPressed(_ sender: AnyObject) {
        if currentlySelectingSquare == false {
            var nextWordArray: Array<(Int,Int)> = []
            
            if let currentWord = currentWord {
                nextWordArray = coordsOfAnswersArray[currentWord]
            } else {
                nextWordArray = coordsOfAnswersArray[selectedWords.count]
            }
            
            let hintWordCount = nextWordArray.count
            if hintsAskedForSoFar == hintWordCount {
                wordSelectionOver()
            } else {
                let word = nextWordArray[hintsAskedForSoFar]
                let square = (word.0, word.1, BorderType.unknown)
                
                if hintsAskedForSoFar == 0 {
                    selectSquare(square, startOfTouch: true)
                } else if hintsAskedForSoFar < hintWordCount {
                    selectSquare(square, startOfTouch: false)
                }
                hintsAskedForSoFar += 1
            }
        }
    }

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
    
    case circle
    
    case none
    
    case unknown
}
