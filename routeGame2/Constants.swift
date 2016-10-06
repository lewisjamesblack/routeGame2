//
//  Constants.swift
//  routeGame2
//
//  Created by Lewis Black on 18/08/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit

let firstLetterDistanceFromSide:CGFloat = 0
let firstLetterDistanceFromTop:CGFloat = 0

let letterSquareViewWidth:CGFloat = 50 //change in .xib file
let letterSquareViewHeight:CGFloat = 50 //change in .xib file
let letterSquareViewWidthPercentage:CGFloat = 0.7
let squareViewSelectionOutside:CGFloat = -20
let squareViewSelectionWidth:CGFloat = 10
let squareViewSelectionCornerRadius: CGFloat = 10
let squareViewSelectionInsideCornerRadius: CGFloat = 3

let gridBackgroundColour = UIColor.white
let deleteColourChangeLetterLabelColor = UIColor.lightGray

//let colours = [UIColor.redColor(), UIColor.blueColor(), UIColor.greenColor()]
let colours = [UIColor(netHex:0x59ABE3), UIColor(netHex:0x9A12B3), UIColor(netHex:0xBF55EC), UIColor(netHex:0x9B59B6), UIColor(netHex:0x59ABE3), UIColor(netHex:0x81CFE0), UIColor(netHex:0x22A7F0), UIColor(netHex:0x4183D7), UIColor(netHex:0x81CFE0), UIColor(netHex:0x19B5FE), UIColor(netHex:0x3498DB), UIColor(netHex:0x336E7B)]


let WORD_CORRECT = "wordCorrect"
let WORD_INCORRECT = "wordInCorrect"

let TOUCH_BEGAN = "touchBegan"
let TOUCH_MOVED = "touchMoved"
let TOUCH_ENDED = "touchEnded"

let LETTER_SELECTED = "letterSelected"

let SEGUE_GAME_SELECTED = "gameSelected"
