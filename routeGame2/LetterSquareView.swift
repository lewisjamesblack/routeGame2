//
//  LetterSquareView.swift
//  routeGame2
//
//  Created by Lewis Black on 18/08/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit

class LetterSquareView: UIView {
    
    //var isSelected:Bool
    var letter:String!
    
    @IBOutlet weak var topToLeft: UIView!
    @IBOutlet weak var topToRight: UIView!
    @IBOutlet weak var bottomToRight: UIView!
    @IBOutlet weak var bottomToLeft: UIView!
    @IBOutlet weak var horizontalTube: UIView!
    @IBOutlet weak var verticalTube: UIView!
    @IBOutlet weak var endFromLeft: UIView!
    @IBOutlet weak var endFromRight: UIView!
    @IBOutlet weak var endFromTop: UIView!
    @IBOutlet weak var endFromBottom: UIView!
    
    @IBOutlet weak var topToLeftWhiteSpace: UIView!
    @IBOutlet weak var topToRightWhiteSpace: UIView!
    @IBOutlet weak var bottomToRightWhiteSpace: UIView!
    @IBOutlet weak var bottomToLeftWhiteSpace: UIView!
    
    @IBOutlet weak var letterSquareViewView: LetterSquareViewView!
    @IBOutlet var letterSquareView: UIView!
    @IBOutlet weak var letterLbl: UILabel!
    
    init(frame: CGRect, letter: String) {
                
        super.init(frame: frame)
        
        NSBundle.mainBundle().loadNibNamed("LetterSquareView", owner: self, options:  nil)
        
        letterLbl.text = letter.capitalizedString
        self.letter = letter
        self.addSubview(letterSquareView)
        
        topToLeft.layer.cornerRadius = squareViewSelectionCornerRadius
        topToRight.layer.cornerRadius = squareViewSelectionCornerRadius
        bottomToRight.layer.cornerRadius = squareViewSelectionCornerRadius
        bottomToLeft.layer.cornerRadius = squareViewSelectionCornerRadius
        horizontalTube.layer.cornerRadius = squareViewSelectionCornerRadius
        verticalTube.layer.cornerRadius = squareViewSelectionCornerRadius
        endFromLeft.layer.cornerRadius = squareViewSelectionCornerRadius
        endFromRight.layer.cornerRadius = squareViewSelectionCornerRadius
        endFromTop.layer.cornerRadius = squareViewSelectionCornerRadius
        endFromBottom.layer.cornerRadius = squareViewSelectionCornerRadius
//        topToLeftWhiteSpace.layer.cornerRadius = squareViewSelectionInsideCornerRadius
//        topToRightWhiteSpace.layer.cornerRadius = squareViewSelectionInsideCornerRadius
//        bottomToRightWhiteSpace.layer.cornerRadius = squareViewSelectionInsideCornerRadius
//        bottomToLeftWhiteSpace.layer.cornerRadius = squareViewSelectionInsideCornerRadius

        topToLeft.clipsToBounds = true
        topToRight.clipsToBounds = true
        bottomToRight.clipsToBounds = true
        bottomToLeft.clipsToBounds = true
        horizontalTube.clipsToBounds = true
        verticalTube.clipsToBounds = true
        endFromLeft.clipsToBounds = true
        endFromRight.clipsToBounds = true
        endFromTop.clipsToBounds = true
        endFromBottom.clipsToBounds = true
//        topToLeftWhiteSpace.clipsToBounds = true
//        topToRightWhiteSpace.clipsToBounds = true
//        bottomToRightWhiteSpace.clipsToBounds = true
//        bottomToLeftWhiteSpace.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return false
    }
    
    func changeBackgroundColors(colour:UIColor?) {
        for view in [topToRight, topToLeft, bottomToRight, bottomToLeft, horizontalTube, verticalTube, endFromLeft, endFromRight, endFromTop, endFromBottom] {
            view.backgroundColor = colour
        }
    }
    
    func hideAllViewsExcept(exceptionView: UIView){
        for view in [topToRight, topToLeft, bottomToRight, bottomToLeft, horizontalTube, verticalTube, endFromLeft, endFromRight, endFromTop, endFromBottom] {
            view.hidden = true
        }
        exceptionView.hidden = false
    }
    
    
}
