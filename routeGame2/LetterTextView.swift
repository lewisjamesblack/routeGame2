//
//  LetterTextView.swift
//  routeGame2
//
//  Created by Lewis Black on 18/08/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import Foundation
import UIKit

class LetterSquareViewTextLabel: UILabel {
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return false
    }
}

class LetterSquareViewView: UIView {
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return false
    }
}

class ViewToStopScrolling:UIView{
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return true
    }
}