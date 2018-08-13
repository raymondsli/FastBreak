//
//  SeasonStatsViewController.swift
//
//  Created by Raymond Li on 10/24/17.
//  Copyright © 2017 Raymond Li. All rights reserved.
//

import UIKit

class SeasonStatsViewController: UIViewController, NSURLConnectionDelegate {
    
    var teamString: String! = "0"
    var gamesString: String! = "0"
    var MPGString: String! = "0"
    var pointsString: String! = "0"
    var reboundsString: String! = "0"
    var assistsString: String! = "0"
    var stealsString: String! = "0"
    var blocksString: String! = "0"
    var turnoversString: String! = "0"
    var totalFGString: String! = "0"
    var totalFGPerString: String! = "0"
    var threePTString: String! = "0"
    var threePTPerString: String! = "0"
    var ftString: String! = "0"
    var ftPerString: String! = "0"
    
    var lteamString: String! = ""
    var lgamesString: String! = ""
    var lMPGString: String! = ""
    var lpointsString: String! = ""
    var lreboundsString: String! = ""
    var lassistsString: String! = ""
    var lstealsString: String! = ""
    var lblocksString: String! = ""
    var lturnoversString: String! = ""
    var ltotalFGString: String! = ""
    var ltotalFGPerString: String! = ""
    var lthreePTString: String! = ""
    var lthreePTPerString: String! = ""
    var lftString: String! = ""
    var lftPerString: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSeasonJSON(gameLogURL: "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1627759")
    }
    
    //Function that gets JSON data from the URL
    func getSeasonJSON(gameLogURL: String) {
        let url = URL(string: gameLogURL)
        
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                    let resultSetsTemp: NSArray = json["resultSets"] as! NSArray
                    let resultSets = resultSetsTemp[0] as! [String: Any]
                    //resultSets is a dictionary
                    let rowSet: NSArray = resultSets["rowSet"] as! NSArray
                    //rowSet is an array of arrays, where each subarray is a season
                    let season: NSArray = rowSet[1] as! NSArray
                    self.turnRowSetIntoSeasonStats(rowSet: season)
                    
                    let lastSeason: NSArray = rowSet[0] as! NSArray
                    self.turnRowSetIntoLastSeasonStats(rowSet: lastSeason)

                    
                    DispatchQueue.main.async(execute: {

                    })
                } catch {
                    print("Could not serialize")
                }
            }
        }).resume()
    }
    

    func turnRowSetIntoSeasonStats(rowSet: NSArray) {
        var pointsDouble: Double = rowSet[26] as! Double
        pointsDouble = Double(round(1000 * pointsDouble) / 1000)
        pointsString = String(describing: pointsDouble)
        
        teamString = abvToTeam(team: String(describing: rowSet[4]))
        gamesString = String(describing: rowSet[6])
        var mpgDouble: Double = rowSet[8] as! Double
        mpgDouble = Double(round(1000 * mpgDouble) / 1000)
        MPGString = String(describing: mpgDouble)
        var rebDouble: Double = rowSet[20] as! Double
        rebDouble = Double(round(1000 * rebDouble) / 1000)
        reboundsString = String(describing: rebDouble)
        var assistsDouble: Double = rowSet[21] as! Double
        assistsDouble = Double(round(1000 * assistsDouble) / 1000)
        assistsString = String(describing: assistsDouble)
        var stealsDouble: Double = rowSet[22] as! Double
        stealsDouble = Double(round(1000 * stealsDouble) / 1000)
        stealsString = String(describing: stealsDouble)
        var blocksDouble: Double = rowSet[23] as! Double
        blocksDouble = Double(round(1000 * blocksDouble) / 1000)
        blocksString = String(describing: blocksDouble)
        var toDouble: Double = rowSet[24] as! Double
        toDouble = Double(round(1000 * toDouble) / 1000)
        turnoversString = String(describing: toDouble)
        
        var fgMDouble: Double = rowSet[9] as! Double
        fgMDouble = Double(round(1000 * fgMDouble) / 1000)
        var fgADouble: Double = rowSet[10] as! Double
        fgADouble = Double(round(1000 * fgADouble) / 1000)
        totalFGString = String(describing: fgMDouble) + "/" + String(describing: fgADouble)
        totalFGPerString = String(100*(rowSet[11] as! Double)) + "%"
        
        var tPDouble: Double = rowSet[12] as! Double
        tPDouble = Double(round(1000 * tPDouble) / 1000)
        var tpADouble: Double = rowSet[13] as! Double
        tpADouble = Double(round(1000 * tpADouble) / 1000)
        threePTString = String(describing: tPDouble) + "/" + String(describing: tpADouble)
        threePTPerString = String(100*(rowSet[14] as! Double)) + "%"
        
        var ftmDouble: Double = rowSet[15] as! Double
        ftmDouble = Double(round(1000 * ftmDouble) / 1000)
        var ftaDouble: Double = rowSet[16] as! Double
        ftaDouble = Double(round(1000 * ftaDouble) / 1000)
        ftString = String(describing: ftmDouble) + "/" + String(describing: ftaDouble)
        ftPerString = String(100*(rowSet[17] as! Double)) + "%"
    }
    
    func turnRowSetIntoLastSeasonStats(rowSet: NSArray) {
        var pointsDouble: Double = rowSet[26] as! Double
        pointsDouble = Double(round(1000 * pointsDouble) / 1000)
        lpointsString = String(describing: pointsDouble)
        
        lteamString = abvToTeam(team: String(describing: rowSet[4]))
        lgamesString = String(describing: rowSet[6])
        var mpgDouble: Double = rowSet[8] as! Double
        mpgDouble = Double(round(1000 * mpgDouble) / 1000)
        lMPGString = String(describing: mpgDouble)
        var rebDouble: Double = rowSet[20] as! Double
        rebDouble = Double(round(1000 * rebDouble) / 1000)
        lreboundsString = String(describing: rebDouble)
        var assistsDouble: Double = rowSet[21] as! Double
        assistsDouble = Double(round(1000 * assistsDouble) / 1000)
        lassistsString = String(describing: assistsDouble)
        var stealsDouble: Double = rowSet[22] as! Double
        stealsDouble = Double(round(1000 * stealsDouble) / 1000)
        lstealsString = String(describing: stealsDouble)
        var blocksDouble: Double = rowSet[23] as! Double
        blocksDouble = Double(round(1000 * blocksDouble) / 1000)
        lblocksString = String(describing: blocksDouble)
        var toDouble: Double = rowSet[24] as! Double
        toDouble = Double(round(1000 * toDouble) / 1000)
        lturnoversString = String(describing: toDouble)
        
        var fgMDouble: Double = rowSet[9] as! Double
        fgMDouble = Double(round(1000 * fgMDouble) / 1000)
        var fgADouble: Double = rowSet[10] as! Double
        fgADouble = Double(round(1000 * fgADouble) / 1000)
        ltotalFGString = String(describing: fgMDouble) + "/" + String(describing: fgADouble)
        ltotalFGPerString = String(100*(rowSet[11] as! Double)) + "%"
        
        var tPDouble: Double = rowSet[12] as! Double
        tPDouble = Double(round(1000 * tPDouble) / 1000)
        var tpADouble: Double = rowSet[13] as! Double
        tpADouble = Double(round(1000 * tpADouble) / 1000)
        lthreePTString = String(describing: tPDouble) + "/" + String(describing: tpADouble)
        lthreePTPerString = String(100*(rowSet[14] as! Double)) + "%"
        
        var ftmDouble: Double = rowSet[15] as! Double
        ftmDouble = Double(round(1000 * ftmDouble) / 1000)
        var ftaDouble: Double = rowSet[16] as! Double
        ftaDouble = Double(round(1000 * ftaDouble) / 1000)
        lftString = String(describing: ftmDouble) + "/" + String(describing: ftaDouble)
        lftPerString = String(100*(rowSet[17] as! Double)) + "%"
    }
    
    func abvToTeam(team: String) -> String {
        if team == "ATL" {
            return "Atlanta Hawks"
        }
        if team == "BOS" {
            return "Boston Celtics"
        }
        if team == "BKN" {
            return "Brooklyn Nets"
        }
        if team == "CHA" {
            return "Charlotte Hornets"
        }
        if team == "CHI" {
            return "Chicago Bulls"
        }
        if team == "CLE" {
            return "Cleveland Cavaliers"
        }
        if team == "DAL" {
            return "Dallas Mavericks"
        }
        if team == "DEN" {
            return "Denver Nuggets"
        }
        if team == "DET" {
            return "Detroit Pistons"
        }
        if team == "GSW" {
            return "Golden State Warriors"
        }
        if team == "HOU" {
            return "Houston Rockets"
        }
        if team == "IND" {
            return "Indiana Pacers"
        }
        if team == "LAC" {
            return "LA Clippers"
        }
        if team == "LAL" {
            return "LA Lakers"
        }
        if team == "MEM" {
            return "Memphis Grizzlies"
        }
        if team == "MIA" {
            return "Miami Heat"
        }
        if team == "MIL" {
            return "Milwaukee Bucks"
        }
        if team == "MIN" {
            return "Minnesota Timberwolves"
        }
        if team == "NOP" {
            return "New Orleans Pelicans"
        }
        if team == "NYK" {
            return "New York Knicks"
        }
        if team == "OKC" {
            return "Oklahoma City Thunder"
        }
        if team == "ORL" {
            return "Orlando Magic"
        }
        if team == "PHI" {
            return "Philadelphia 76ers"
        }
        if team == "PHX" {
            return "Phoenix Suns"
        }
        if team == "POR" {
            return "Portland Trail Blazers"
        }
        if team == "SAC" {
            return "Sacramento Kings"
        }
        if team == "SAS" {
            return "San Antonio Spurs"
        }
        if team == "TOR" {
            return "Toronto Rapters"
        }
        if team == "UTA" {
            return "Utah Jazz"
        }
        if team == "WAS" {
            return "Washington Wizards"
        }
        return "Team"
    }
}
