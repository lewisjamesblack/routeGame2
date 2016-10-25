//
//  Enums.swift
//  routeGame2
//
//  Created by Lewis Black on 25/08/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import Foundation


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
