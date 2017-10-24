//
//  SeasonStatsViewController.swift
//  JB
//
//  Created by Raymond Li on 8/19/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit

class SeasonStatsViewController: UIViewController, NSURLConnectionDelegate {
    
    @IBOutlet weak var seasonStats: UILabel!

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Calling")
        seasonStats.text = "Testing..."
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
                    
                    DispatchQueue.main.async(execute: {
                        self.seasonStats.text = "Boston Celtics 2017-2018" + "\n\n" + "Games: " + self.gamesString + "\n" + "MPG: " + self.MPGString + "\n" + "Points: " + self.pointsString + "\n" + "Rebounds: " + self.reboundsString + "\n" + "Assists: " + self.assistsString + "\n" + "Steals: " + self.stealsString + "\n" + "Blocks: " + self.blocksString + "\n" + "Turnovers: " + self.turnoversString + "\n" + "Total FG: " + self.totalFGString + " = " + self.totalFGPerString + "\n" + "3PT FG: " + self.threePTString + " = " + self.threePTPerString + "\n" + "Free Throws: " + self.ftString + " = " + self.ftPerString
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
        
        gamesString = String(describing: rowSet[6])
        MPGString = String(describing: rowSet[8])
        reboundsString = String(describing: rowSet[20])
        assistsString = String(describing: rowSet[21])
        stealsString = String(describing: rowSet[22])
        blocksString = String(describing: rowSet[23])
        turnoversString = String(describing: rowSet[24])
        totalFGString = String(describing: rowSet[9]) + "/" + String(describing: rowSet[10])
        //totalFGPerString = String(describing: rowSet[11])
        totalFGPerString = String(100*(rowSet[11] as! Double)) + "%"
        threePTString = String(describing: rowSet[12]) + "/" + String(describing: rowSet[13])
        //threePTPerString = String(describing: rowSet[14])
        threePTPerString = String(100*(rowSet[14] as! Double)) + "%"
        ftString = String(describing: rowSet[15]) + "/" + String(describing: rowSet[16])
        //ftPerString = String(describing: rowSet[17])
        ftPerString = String(100*(rowSet[17] as! Double)) + "%"
    }
}
