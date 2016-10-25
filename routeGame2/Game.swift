//
//  Game.swift
//  routeGame2
//
//  Created by Lewis Black on 02/09/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import Foundation

class Game {
    
    var numberOfCols: Int
    var numberOfRows: Int
    var routeCoOrds: [(Int,Int)]
    var minWordLengthIfNoSmaller: Int
    var maxWordLengthIfNoBigger: Int
    var dataBeforeTranslation: [AnyObject]
    
    init(numberOfCols: Int, numberOfRows: Int, routeCoOrds:[(Int,Int)], minWordLengthIfNoSmaller: Int,maxWordLengthIfNoBigger: Int, dataBeforeTranslation: [AnyObject]) {
        
        self.numberOfCols = numberOfCols
        self.numberOfRows = numberOfRows
        self.routeCoOrds = routeCoOrds
        self.minWordLengthIfNoSmaller = minWordLengthIfNoSmaller
        self.maxWordLengthIfNoBigger = maxWordLengthIfNoBigger
        self.dataBeforeTranslation = dataBeforeTranslation
    }
}
