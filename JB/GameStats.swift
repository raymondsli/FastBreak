//
//  gameStats.swift
//  JB
//
//  Created by Raymond Li on 8/18/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit
class GameStats {
    
    var label: String
    var dateLocation: String
    var gameNumber: String
    var score: String
    
    var backgroundRed: CGFloat
    var backgroundGreen: CGFloat
    var backgroundBlue: CGFloat
    var backgroundAlpha: CGFloat
    
    var totalPoints: String
    var totalRebounds: String
    var totalAssists: String
    var totalSteals: String
    var totalBlocks: String
    
    var totalShootingFraction: String
    var totalShootingPercentage: String
    var twoPointShootingFraction: String
    var twoPointShootingPercentage: String
    var threePointShootingFraction: String
    var threePointShootingPercentage: String
    
    var freeThrowFraction: String
    var freeThrowPercentage: String
    
    var turnovers: String
    var minutes: String
    var fouls: String
    var offensiveRebounds: String
    var defensiveRebounds: String
    var plusMinus: String


    init(label: String = "", dl: String = "", gN: String = "", scr: String = "", bgR: CGFloat = 0, bgG: CGFloat = 0, bgB: CGFloat = 0, bgA: CGFloat = 0.9, p: String = "", r: String = "", a: String = "", s: String = "", b: String = "", tSF: String = "", tSP: String = "", tPSF: String = "", tPSP: String = "", thPSF: String = "", thPSP: String = "", fTF: String = "", ftP: String = "", turn: String = "", min: String = "", foul: String = "", oReb: String = "", dReb: String = "", pM: String = "") {
        
        self.label = label
        dateLocation = dl
        gameNumber = gN
        score = scr
        
        backgroundRed = bgR
        backgroundGreen = bgG
        backgroundBlue = bgB
        backgroundAlpha = bgA
        
        totalPoints = p
        totalRebounds = r
        totalAssists = a
        totalSteals = s
        totalBlocks = b
        
        totalShootingFraction = tSF
        totalShootingPercentage = tSP
        twoPointShootingFraction = tPSF
        twoPointShootingPercentage = tPSP
        threePointShootingFraction = thPSF
        threePointShootingPercentage = thPSP
        
        freeThrowFraction = fTF
        freeThrowPercentage = ftP
        
        turnovers = turn
        minutes = min
        fouls = foul
        offensiveRebounds = oReb
        defensiveRebounds = dReb
        plusMinus = pM
    }
}
