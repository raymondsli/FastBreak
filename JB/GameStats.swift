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
    var turnovers: String
    var minutes: String
    var fouls: String
    
    var shotClose: String
    var shotMedium: String
    
    var openMidrange: String
    var semiContestedMidrange: String
    var contestedMidrange: String
    var open3PT: String
    var semiContestedThree: String
    var contestedThree: String
    
    var dunks: String

    init(label: String, dl: String, gN: String, scr: String, bgR: CGFloat, bgG: CGFloat, bgB: CGFloat, bgA: CGFloat, p: String, r: String, a: String, s: String, b: String, tSF: String, tSP: String, tPSF: String, tPSP: String, thPSF: String, thPSP: String, fTF: String, turn: String, min: String, foul: String, shotClose: String, shotMedium: String, oMid: String, sMid: String, cMid: String, oThree: String, sThree: String, cThree: String, dunks: String) {
        
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
        turnovers = turn
        minutes = min
        fouls = foul
        
        self.shotClose = shotClose
        self.shotMedium = shotMedium
        
        openMidrange = oMid
        semiContestedMidrange = sMid
        contestedMidrange = cMid
        open3PT = oThree
        semiContestedThree = sThree
        contestedThree = cThree
        
        self.dunks = dunks
    }
    
    init() {
        label = ""
        dateLocation = ""
        gameNumber = ""
        score = ""
        
        backgroundRed = 0
        backgroundGreen = 0
        backgroundBlue = 0
        backgroundAlpha = 0.9
        
        totalPoints = ""
        totalRebounds = ""
        totalAssists = ""
        totalSteals = ""
        totalBlocks = ""
        
        totalShootingFraction = ""
        totalShootingPercentage = ""
        twoPointShootingFraction = ""
        twoPointShootingPercentage = ""
        threePointShootingFraction = ""
        threePointShootingPercentage = ""
        
        freeThrowFraction = ""
        turnovers = ""
        minutes = ""
        fouls = ""
        
        shotClose = ""
        shotMedium = ""
        
        openMidrange = ""
        semiContestedMidrange = ""
        contestedMidrange = ""
        open3PT = ""
        semiContestedThree = ""
        contestedThree = ""
        
        dunks = ""
    }
    
    init(label: String) {
        self.label = label
        dateLocation = ""
        gameNumber = ""
        score = ""
        
        backgroundRed = 0
        backgroundGreen = 0
        backgroundBlue = 0
        backgroundAlpha = 0
        
        totalPoints = ""
        totalRebounds = ""
        totalAssists = ""
        totalSteals = ""
        totalBlocks = ""
        
        totalShootingFraction = ""
        totalShootingPercentage = ""
        twoPointShootingFraction = ""
        twoPointShootingPercentage = ""
        threePointShootingFraction = ""
        threePointShootingPercentage = ""
        
        freeThrowFraction = ""
        turnovers = ""
        minutes = ""
        fouls = ""
        
        shotClose = ""
        shotMedium = ""
        
        openMidrange = ""
        semiContestedMidrange = ""
        contestedMidrange = ""
        open3PT = ""
        semiContestedThree = ""
        contestedThree = ""
        
        dunks = ""
    }
    
    init(label: String, secondaryLabel: String, bgR: CGFloat, bgG: CGFloat, bgB: CGFloat, bgA: CGFloat) {
        self.label = label
        dateLocation = secondaryLabel
        gameNumber = ""
        score = ""
        
        backgroundRed = bgR
        backgroundGreen = bgG
        backgroundBlue = bgB
        backgroundAlpha = bgA
        
        totalPoints = ""
        totalRebounds = ""
        totalAssists = ""
        totalSteals = ""
        totalBlocks = ""
        
        totalShootingFraction = ""
        totalShootingPercentage = ""
        twoPointShootingFraction = ""
        twoPointShootingPercentage = ""
        threePointShootingFraction = ""
        threePointShootingPercentage = ""
        
        freeThrowFraction = ""
        turnovers = ""
        minutes = ""
        fouls = ""
        
        shotClose = ""
        shotMedium = ""
        
        openMidrange = ""
        semiContestedMidrange = ""
        contestedMidrange = ""
        open3PT = ""
        semiContestedThree = ""
        contestedThree = ""
        
        dunks = ""
    }
}