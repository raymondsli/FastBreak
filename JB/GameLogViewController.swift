//
//  GameLogViewController.swift
//
//  Created by Raymond Li on 8/12/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit
class GameLogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var curPlayer: String! = ""
    var playerDict: [String: [String]] = [:]
    var games = [GameStats]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getGameLogJSON()

        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //Function that gets JSON data from the URL
    func getGameLogJSON() {
        let url = URL(string: "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=1627759&Season=2017-18&SeasonType=Regular+Season")
        
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                    //resultSets is a dictionary
                    let resultSetsTemp: NSArray = json["resultSets"] as! NSArray
                    let resultSets = resultSetsTemp[0] as! [String: Any]
                    //rowSet is an array of arrays, where each subarray is a game
                    let rowSet: NSArray = resultSets["rowSet"] as! NSArray
                    
                    self.turnRowSetIntoGameStats(rowSet)
                    
                    DispatchQueue.main.async(execute: {
                        self.tableView!.reloadData()
                    })
                } catch {
                    print("Could not serialize")
                }
            }
        }).resume()
    }
    
    func turnRowSetIntoGameStats(_ rowSet: NSArray) {
        //rowSet is an array of arrays, where each subarray is a game. Turn each game into a GameStats
        var i: Int = 0
        while i < rowSet.count {
            //Start at i = 0, so rowSet[0] is the first game array. Continue until last game.
            let currentGame: NSArray = rowSet[i] as! NSArray
            let gameInfo = self.getGameInfo(currentGame[3] as! String, opponent: currentGame[4] as! String)
            let gameNumber = String(rowSet.count - i)
            let score = String(describing: currentGame[5])
            let points = String(describing: currentGame[24])
            let rebounds = String(describing: currentGame[18])
            let assists = String(describing: currentGame[19])
            let steals = String(describing: currentGame[20])
            let blocks = String(describing: currentGame[21])
            
            let FGM: String = String(describing: currentGame[7])
            let FGA: String = String(describing: currentGame[8])
            
            let totalShoot = FGM + "/" + FGA
            let totalShootP = String(describing: currentGame[9])
            
            
            let twoPointersMade =  (currentGame[7] as! Int) - (currentGame[10] as! Int)
            let twoPointersAttempted = (currentGame[8] as! Int) - (currentGame[11] as! Int)
            let twoF = String(twoPointersMade) + "/" + String(twoPointersAttempted)
            let twoPtDouble = Double(twoPointersMade) / Double(twoPointersAttempted)
            let twoPtRounded = Double(round(twoPtDouble * 1000) / 1000)
            let twoP = String(twoPtRounded)
            
            let threeF = String(describing: currentGame[10]) + "/" + String(describing: currentGame[11])
            let threeP = String(describing: currentGame[12])
            
            let fF = String(describing: currentGame[13]) + "/" + String(describing: currentGame[14])
            let fP = String(describing: currentGame[15])
            
            let turnovers = String(describing: currentGame[22])
            let minutes = String(describing: currentGame[6])
            let fouls = String(describing: currentGame[23])
            let offensiveRebounds = String(describing: currentGame[16])
            let defensiveRebounds = String(describing: currentGame[17])
            let plus_minus = String(describing: currentGame[25])
            
            //Create a new GameStats and append it to games. So first element in games will be first element in rowSet, which is the most recent game.
            let newGame = GameStats(label: "game", dl: gameInfo, gN: gameNumber, scr: score, bgR: 0, bgG: 0.9, bgB: 0, bgA: 1, p: points, r: rebounds, a: assists, s: steals, b: blocks, tSF: totalShoot, tSP: totalShootP, tPSF: twoF, tPSP: twoP, thPSF: threeF, thPSP: threeP, fTF: fF, ftP: fP, turn: turnovers, min: minutes, foul: fouls, oReb: offensiveRebounds, dReb: defensiveRebounds, pM: plus_minus)
            self.games.append(newGame)
            
            i = i + 1
        }
    }
    
    
    //Function called in turnRowSetIntoGameStats that turns format FEB 09, 2016 GSW vs. DAL into form 2/9/16 vs. DAL through subsetting strings.
    func getGameInfo(_ date: String, opponent: String) -> String {
        let oppIndex = opponent.characters.index(opponent.startIndex, offsetBy: 4)
        let trunOpp = opponent.substring(from: oppIndex)
        
        let day = date.substring(with: (date.characters.index(date.startIndex, offsetBy: 4) ..< date.characters.index(date.endIndex, offsetBy: -6)))
        let year = date.substring(from: date.characters.index(date.endIndex, offsetBy: -2))
        
        let writtenMonth = date.substring(to: date.characters.index(date.startIndex, offsetBy: 3))
        let numberMonth: String
        
        if writtenMonth == "JAN" {
            numberMonth = "1"
        } else if writtenMonth == "FEB" {
            numberMonth = "2"
        } else if writtenMonth == "MAR" {
            numberMonth = "3"
        } else if writtenMonth == "APR" {
            numberMonth = "4"
        } else if writtenMonth == "MAY" {
            numberMonth = "5"
        } else if writtenMonth == "JUN" {
            numberMonth = "6"
        } else if writtenMonth == "JUL" {
            numberMonth = "7"
        } else if writtenMonth == "AUG" {
            numberMonth = "8"
        } else if writtenMonth == "SEP" {
            numberMonth = "9"
        } else if writtenMonth == "OCT" {
            numberMonth = "10"
        } else if writtenMonth == "NOV" {
            numberMonth = "11"
        } else if writtenMonth == "DEC" {
            numberMonth = "12"
        } else {
            numberMonth = "0"
        }
        
        let numberedDate = numberMonth + "/" + day + "/" + year
        
        return numberedDate + " " + trunOpp
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell") as? GameCell {
            cell.accessoryView?.backgroundColor = UIColor.black

            let totalPoints = games[indexPath.row].totalPoints
            let totalRebounds = games[indexPath.row].totalRebounds
            let totalAssists = games[indexPath.row].totalAssists
            let totalSteals = games[indexPath.row].totalSteals
            let totalBlocks = games[indexPath.row].totalBlocks
            let totalShootingFraction = games[indexPath.row].totalShootingFraction
            
            let mainStats = totalPoints + "/" + totalRebounds + "/" + totalAssists + "/" + totalSteals + "/" + totalBlocks
            
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            cell.configureCell(games[indexPath.row].dateLocation, gameMainStats: mainStats, gameShootingF: totalShootingFraction)
            return cell
        } else {
            return GameCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetailedGame", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailedGame" {
//            let upcoming: DetailedGameVC = segue.destination as! DetailedGameVC
//            let indexPath = self.tableView.indexPathForSelectedRow!
//
//            let dateLocation = games[indexPath.row].dateLocation
//            let gameNumber = games[indexPath.row].gameNumber
//            let score = games[indexPath.row].score
//
//            let totalPoints = games[indexPath.row].totalPoints
//            let totalRebounds = games[indexPath.row].totalRebounds
//            let totalAssists = games[indexPath.row].totalAssists
//            let totalSteals = games[indexPath.row].totalSteals
//            let totalBlocks = games[indexPath.row].totalBlocks
//
//            let totalShootingFraction = games[indexPath.row].totalShootingFraction
//            let totalShootingPercentage = games[indexPath.row].totalShootingPercentage
//            let twoPointShootingFraction = games[indexPath.row].twoPointShootingFraction
//            let twoPointShootingPercentage = games[indexPath.row].twoPointShootingPercentage
//            let threePointShootingFraction = games[indexPath.row].threePointShootingFraction
//            let threePointShootingPercentage = games[indexPath.row].threePointShootingPercentage
//            let freeThrowFraction = games[indexPath.row].freeThrowFraction
//            let freeThrowPercentage = games[indexPath.row].freeThrowPercentage
//
//            let turnovers = games[indexPath.row].turnovers
//            let minutes = games[indexPath.row].minutes
//            let fouls = games[indexPath.row].fouls
//            let offensiveRebounds = games[indexPath.row].offensiveRebounds
//            let defensiveRebounds = games[indexPath.row].defensiveRebounds
//            let plusMinus = games[indexPath.row].plusMinus
//
//
//
//            let pointsLabel = "Points: " + totalPoints
//            let reboundsLabel = "Rebounds: " + totalRebounds
//            let assistsLabel = "Assists: " + totalAssists
//            let stealsLabel = "Steals: " + totalSteals
//            let blocksLabel = "Blocks: " + totalBlocks
//
//            let tSFLabel = "Total Shooting Fraction: " + totalShootingFraction
//            let tSPLabel = "Total Shooting Percentage: " + totalShootingPercentage
//            let twoPtSFLabel = "2PT Shooting Fraction: " + twoPointShootingFraction
//            let twoPtSPLabel = "2PT Shooting Percentage: " + twoPointShootingPercentage
//            let threePtSFLabel = "3PT Shooting Fraction: " + threePointShootingFraction
//            let threePtSPLabel = "3PT Shooting Percentage: " + threePointShootingPercentage
//            let freeThrowFLabel = "Free Throws Fraction: " + freeThrowFraction
//            let freeThrowPLabel = "Free Throws Percentage: " + freeThrowPercentage
//
//            let minutesLabel = "Minutes: " + minutes
//            let turnoversLabel = "Turnovers: " + turnovers
//            let foulsLabel = "Fouls: " + fouls
//            let oRebLabel = "Offensive Rebounds: " + offensiveRebounds
//            let dRebLabel = "Defensive Rebounds: " + defensiveRebounds
//            let plusMinusLabel = "Plus Minus: " + plusMinus
//
//
//            let titleLabel = "Game " + gameNumber + "\n" + dateLocation + "\n" + score
//            let mainStatsLabel = pointsLabel + "\n\n" + reboundsLabel + "\n\n" + assistsLabel + "\n\n" + stealsLabel + "\n\n" + blocksLabel
//            let additionalStatsLabel = minutesLabel + "\n\n" + turnoversLabel + "\n\n" + foulsLabel + "\n\n" + oRebLabel + "\n\n" + dRebLabel + "\n\n" + plusMinusLabel
//            let shootingDetailsLabel = tSFLabel + "\n" + tSPLabel + "\n\n" + freeThrowFLabel + "\n" + freeThrowPLabel + "\n\n" + twoPtSFLabel + "\n" + twoPtSPLabel + "\n\n" + threePtSFLabel + "\n" + threePtSPLabel
//
//            upcoming.gameInfoString = titleLabel
//            upcoming.mainStatsString = mainStatsLabel
//            upcoming.additionalStatsString = additionalStatsLabel
//            upcoming.shootingDetailsString = shootingDetailsLabel
            
            self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    
}
