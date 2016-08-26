//
//  CharacterGridView.swift
//  routeGame2
//
//  Created by Lewis Black on 18/08/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit

class CharacterGridView: UIView {
    
    var numberOfCols:Int!
    var numberOfRows:Int!
    var height:CGFloat!
    var width:CGFloat!
    var route:Array<Array<Int>>! //array of columns of positions in route e.g [[0,13,14],[1,12,9]...]
    var answersOneString:String!
    var arrayOfRows:Array<Array<LetterSquareView>> = []

    
    init(frame: CGRect, numberOfCols:Int, numberOfRows:Int, route:Array<Array<Int>>, answersOneString:String) {
        self.numberOfCols = numberOfCols
        self.numberOfRows = numberOfRows
        self.answersOneString = answersOneString
        self.height = firstLetterDistanceFromTop * 2 + letterSquareViewHeight * CGFloat(self.numberOfRows)
        self.width = firstLetterDistanceFromSide * 2 + letterSquareViewWidth * CGFloat(self.numberOfCols)
        self.route = route
        super.init(frame: frame)

        self.initialise()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialise()
    }
    
    func initialise() {
        for i in 0...numberOfCols - 1 {
            var arrayOfViewsInRow:Array<LetterSquareView> = []
            
            for j in 0...numberOfRows - 1 {
                let x = firstLetterDistanceFromSide + CGFloat(i) * letterSquareViewWidth
                let y = firstLetterDistanceFromTop + CGFloat(j) * letterSquareViewHeight
                let index = answersOneString.startIndex.advancedBy(route[i][j])
                let placeInRoute = answersOneString[index]
                
                let letter = "\(placeInRoute)"
                
                arrayOfViewsInRow.append(LetterSquareView(frame: CGRect(x: x, y: y, width: letterSquareViewWidth, height: letterSquareViewHeight), letter: letter))
                
                self.addSubview(arrayOfViewsInRow[j])
            }
            arrayOfRows.append(arrayOfViewsInRow)
        }
    }    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NSNotificationCenter.defaultCenter().postNotificationName(TOUCH_BEGAN, object: touches)
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NSNotificationCenter.defaultCenter().postNotificationName(TOUCH_MOVED, object: touches)
    
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NSNotificationCenter.defaultCenter().postNotificationName(TOUCH_ENDED, object: touches)
    }
}


    