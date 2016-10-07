//
//  LetterSquareView.swift
//  routeGame2
//
//  Created by Lewis Black on 18/08/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit

class LetterSquareView: UIView {
    
    var letter:String!
    var arrayOfViews: Array<UIView> = []
    var selectingView:UIView
    var lastColor:UIColor?
    var hintSubviews:Array<SideView> = []
    
    @IBOutlet weak var letterSquareViewView: LetterSquareViewView!
    @IBOutlet var letterSquareView: UIView!
    @IBOutlet weak var letterLbl: UILabel!
    
    init(frame: CGRect, letter: String) {
        self.selectingView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.lastColor = nil
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("LetterSquareView", owner: self, options:  nil)
        
        letterLbl.text = letter.capitalized
        self.letter = letter
        self.addSubview(letterSquareView)
        letterSquareViewView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
    func makeHint(){
        let topView = SideView(type: SideType.top)
        let leftView = SideView(type: SideType.left)
        let rightView = SideView(type: SideType.right)
        let bottomView = SideView(type: SideType.bottom)

        hintSubviews = [topView, leftView, rightView, bottomView]
        
        for subview in hintSubviews {
            letterSquareViewView.addSubview(subview)
        }
    }
    
    func deleteHint(){
        print(letterSquareViewView.subviews)
    }
    
    func changeSelectionColor(_ color: UIColor){
        selectingView.backgroundColor = color
    }
    
    func makeViewsFor(_ borderType: BorderType, color: UIColor) {
        let subViews = letterSquareViewView.subviews
        for subview in subViews{
            if (subview is UILabel) {
            } else {
                subview.removeFromSuperview()
            }
        }
        
        if borderType == BorderType.none {
            return
        }
        if borderType == BorderType.unknown {
            return
        }
        
        var left = squareViewSelectionOutside
        var right = squareViewSelectionOutside
        var top = squareViewSelectionOutside
        var bottom = squareViewSelectionOutside
        var whiteSpace:Bool = false
        var x:CGFloat = 0
        var y:CGFloat = 0
        let letterViewWidth = letterSquareViewView.frame.width
        let letterViewHeight = letterSquareViewView.frame.height
       
        if borderType == BorderType.endFromTop {
            left = squareViewSelectionWidth
            right = squareViewSelectionWidth
            bottom = squareViewSelectionWidth
        } else if borderType == BorderType.endFromLeft {
            top = squareViewSelectionWidth
            bottom = squareViewSelectionWidth
            right = squareViewSelectionWidth
        } else if borderType == BorderType.endFromRight {
            top = squareViewSelectionWidth
            bottom = squareViewSelectionWidth
            left = squareViewSelectionWidth
        } else if borderType == BorderType.endFromBottom {
            left = squareViewSelectionWidth
            right = squareViewSelectionWidth
            top  = squareViewSelectionWidth
        } else if borderType == BorderType.tubeVertical {
            left = squareViewSelectionWidth
            right = squareViewSelectionWidth
        } else if borderType == BorderType.tubeHorizontal {
            top = squareViewSelectionWidth
            bottom = squareViewSelectionWidth
        } else if borderType == BorderType.cornerTopToLeft {
            bottom = squareViewSelectionWidth
            right = squareViewSelectionWidth
            whiteSpace = true
        } else if borderType == BorderType.cornerTopToRight {
            bottom = squareViewSelectionWidth
            left = squareViewSelectionWidth
            whiteSpace = true
            x = letterViewWidth - squareViewSelectionWidth
        } else if borderType == BorderType.cornerBottomToLeft {
            top = squareViewSelectionWidth
            right = squareViewSelectionWidth
            whiteSpace = true
            y = letterViewHeight - squareViewSelectionWidth

        } else if borderType == BorderType.cornerBottomToRight {
            top = squareViewSelectionWidth
            left = squareViewSelectionWidth
            whiteSpace = true
            x = letterViewWidth - squareViewSelectionWidth
            y = letterViewHeight - squareViewSelectionWidth
        }
        
        if whiteSpace {
            let whiteSpaceView = UIView(frame: CGRect(x: x, y: y, width: squareViewSelectionWidth, height: squareViewSelectionWidth))
            whiteSpaceView.backgroundColor = gridBackgroundColour
            letterSquareViewView.addSubview(whiteSpaceView)
        }
        
        selectingView.translatesAutoresizingMaskIntoConstraints = false
        
        selectingView.layer.borderWidth = 0
        selectingView.backgroundColor = color
        selectingView.layer.cornerRadius = squareViewSelectionCornerRadius
        selectingView.clipsToBounds = true
        letterSquareViewView.addSubview(selectingView)
        letterSquareViewView.sendSubview(toBack: selectingView)
        
        let leftContraints = NSLayoutConstraint(item: selectingView, attribute:.leadingMargin, relatedBy: .equal, toItem: letterSquareViewView, attribute: .leadingMargin, multiplier: 1.0, constant: left)
        let rightContraints = NSLayoutConstraint(item: selectingView, attribute:.trailingMargin, relatedBy: .equal, toItem: letterSquareViewView, attribute: .trailingMargin, multiplier: 1.0, constant: -right)
        let topContraints = NSLayoutConstraint(item: selectingView, attribute:.topMargin, relatedBy: .equal, toItem: letterSquareViewView, attribute: .topMargin, multiplier: 1.0,constant: top)
        let bottomContraints = NSLayoutConstraint(item: selectingView, attribute:.bottomMargin, relatedBy: .equal, toItem: letterSquareViewView, attribute: .bottomMargin, multiplier: 1.0,constant: -bottom)
        
        NSLayoutConstraint.activate([leftContraints, rightContraints, topContraints, bottomContraints])

    }
}

enum SideType {
    case top
    case left
    case right
    case bottom
}

class SideView:UIView {
    
    init(type:SideType){
        let offset = (1 - letterSquareViewWidthPercentage)/2
        let width = letterSquareViewWidth * offset
        let length = letterSquareViewWidth * letterSquareViewWidthPercentage
        var frame: CGRect
        switch type {
        case SideType.top: frame = CGRect(x: width, y: width, width: length, height: 1)
        case SideType.left: frame = CGRect(x: width, y: width, width: 1, height: length)
        case SideType.right: frame = CGRect(x: length + width, y: width, width: 1, height: length + 1)
        case SideType.bottom: frame = CGRect(x: width, y: width + length, width: length, height: 1)
        }
        super.init(frame: frame)
        self.backgroundColor = UIColor.black


    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

