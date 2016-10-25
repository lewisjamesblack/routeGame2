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
    
    @IBOutlet weak var scoreText: UITextView!
    @IBOutlet weak var hintText: UITextView!
    @IBOutlet weak var hintButton: UIButton!
    
    @IBOutlet weak var hintViewHeight: NSLayoutConstraint!
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
    var sameCurrentWord:Bool = false
    var hintPressedOdd: Bool = false
    var dataHasHints: Bool = true
    var score:Int = 0
    var firstSquares = [(Int,Int)]()
    var currentlyBlackOut = [(Int,Int)]()
    
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
    var haveWordedHints:Bool = true
    //Other
    var deletingWords:Bool = false //potentially fucks things up if true & things are being corrected
    var ifWordIncorrectUnselect:Bool = true
    var stopSelectingIfWordCorrect:Bool = true
    var autoCorrectWord:Bool = true
    var onlySelectSurroundingLetters:Bool = true //basically only select the letters above/below/sides of last letter
    var blackOutWrongWords:Bool = true 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Calculate Constants

        numberOfCols = game.numberOfCols
        numberOfRows = game.numberOfRows
        routeCoOrds = game.routeCoOrds
        let minWordLengthIfNoSmaller: Int = game.minWordLengthIfNoSmaller
        let maxWordLengthIfNoBigger: Int = game.maxWordLengthIfNoBigger
        dataBeforeTranslation = game.dataBeforeTranslation
        
        dataHasHints = dataBeforeTranslation[3] as! Bool
        needsTranslation = (dataBeforeTranslation[1] as! Bool)
        let height: CGFloat = firstLetterDistanceFromTop * 2 + letterSquareViewHeight * CGFloat(numberOfRows)
        let width: CGFloat = firstLetterDistanceFromSide * 2 + letterSquareViewWidth * CGFloat(numberOfCols)
        
        func makeData() -> String {
            if needsTranslation || dataHasHints {
                return Data().changeToDataString(dataBeforeTranslation[0] as! String, dataUsed: true)
            } else {
                return dataBeforeTranslation[0] as! String
            }
        }
        
        let data: String = makeData()
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
        
        answersOneString = answersArray.joined(separator: "")
        route = routeArrayOfRows(routeCoOrds, numberOfRows: numberOfRows, numberOfCols: numberOfCols)
        
        
        wordsFound = [Bool](repeating: false, count: answersArray.count)
        
        
        var wordStart:Int = 0
        for i in 0..<answersArray.count{
            let wordLength = answersArray[i].characters.count
            let array = Array(routeCoOrds[wordStart...wordStart + wordLength - 1])
            coordsOfAnswersArray.append(array)
            firstSquares.append(routeCoOrds[wordStart])
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

        hintViewHeight.constant = 0

        updateScoreButton()
        
        if haveWordedHints == false || dataHasHints == false {
            hintButton.isHidden = true
        }
        
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
            if self.currentlySelectingSquare {
                self.deSelectWord(self.currentWord!)
                self.scrollView.isScrollEnabled = true

                self.currentlySelectingSquare = false
                self.hintsAskedForSoFar = 0
                self.currentSquare = nil
                self.currentWord = nil
                self.translationText.text = ""
            }
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
        if currentSquare != nil && square == currentSquare! {
                return false
            }
        currentSquare = square
        return true
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

    func findTranslation(_ wordNumber:Int) -> String{
        let abc = Data().changeToDataString(dataBeforeTranslation[0] as! String, dataUsed: false)
        let data = Data().makeArrayOfHints(abc)[wordNumber]
        
        return data
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
    
    
    
        
    
    
    
    
    func updateScoreButton(){
        scoreText.text = "\(score)/\(maxScore)"
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
    
    @IBAction func hintButtonPressed(_ sender: AnyObject) {
        if haveWordedHints && dataHasHints {
            if hintPressedOdd {
                hintViewHeight.constant = 0
                hintPressedOdd = false
                let x = scrollView.contentOffset.x
                let y = scrollView.contentOffset.y
                let newY = y + hintViewHeightConstant
                let point = CGPoint(x: x, y: newY)
                scrollView.setContentOffset(point, animated: false)
            } else {
                let translation = findTranslation(selectedWords.count)
                hintText.text = translation
                hintViewHeight.constant = hintViewHeightConstant
                hintPressedOdd = true
                let x = scrollView.contentOffset.x
                let y = scrollView.contentOffset.y
                let newY = y + hintViewHeightConstant
                let point = CGPoint(x: x, y: newY)
                scrollView.setContentOffset(point, animated: false)
                if sameCurrentWord != true {
                    score += 5
                    sameCurrentWord = true
                }
            }
        }
        updateScoreButton()
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
                score += 1
            }
        }
        updateScoreButton()

    }

}




