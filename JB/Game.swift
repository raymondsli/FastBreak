//
//  Game.swift
//  FBS
//
//  Created by Raymond Li on 8/14/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class Game {
    
    var date: String
    var opponent: String
    var winLoss: String
    
    var gameNumber: Int
    
    var MIN: Double
    
    var PTS: Double
    var OREB: Double
    var DREB: Double
    var REB: Double
    var AST: Double
    var STL: Double
    var BLK: Double
    var TOV: Double
    var PF: Double
    var PLUSMINUS: Double

    var FGM: Double
    var FGA: Double
    var FGP: Double
    
    var FG3M: Double
    var FG3A: Double
    var FG3P: Double
    
    var FTM: Double
    var FTA: Double
    var FTP: Double
    
    
    init(date: String, opponent: String, gameNumber: Int, winLoss: String, MIN: Double, PTS: Double, OREB: Double, DREB: Double, REB: Double, AST: Double, STL: Double, BLK: Double, TOV: Double, PF: Double, PLUSMINUS: Double, FGM: Double, FGA: Double, FGP: Double, FG3M: Double, FG3A: Double, FG3P: Double, FTM: Double, FTA: Double, FTP: Double) {
        self.date = date
        self.opponent = opponent
        self.gameNumber = gameNumber
        self.winLoss = winLoss
        self.MIN = MIN
        self.PTS = PTS
        self.OREB = OREB
        self.DREB = DREB
        self.REB = REB
        self.AST = AST
        self.STL = STL
        self.BLK = BLK
        self.TOV = TOV
        self.PF = PF
        self.PLUSMINUS = PLUSMINUS
        self.FGM = FGM
        self.FGA = FGA
        self.FGP = FGP
        self.FG3M = FG3M
        self.FG3A = FG3A
        self.FG3P = FG3P
        self.FTM = FTM
        self.FTA = FTA
        self.FTP = FTP
    }
}
