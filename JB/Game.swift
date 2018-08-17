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
    
    var MIN: String
    
    var PTS: String
    var OREB: String
    var DREB: String //Not used
    var REB: String
    var AST: String
    var STL: String
    var BLK: String
    var TOV: String
    var PF: String
    var PLUSMINUS: String

    var FGM: String
    var FGA: String
    var FGP: String
    
    var FG3M: String
    var FG3A: String
    var FG3P: String
    
    var FTM: String
    var FTA: String
    var FTP: String
    
    
    init(date: String, opponent: String, gameNumber: Int, winLoss: String, MIN: String, PTS: String, OREB: String, DREB: String, REB: String, AST: String, STL: String, BLK: String, TOV: String, PF: String, PLUSMINUS: String, FGM: String, FGA: String, FGP: String, FG3M: String, FG3A: String, FG3P: String, FTM: String, FTA: String, FTP: String) {
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
