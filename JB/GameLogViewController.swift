//
//  GameLogViewController.swift
//
//  Created by Raymond Li on 8/12/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit
class GameLogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var playerId = 0
    var games = [Game]()
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "GameCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "GameCell")
        
        getGameLogJSON()

        tableView.reloadData()
    }
    
    func getGameLogJSON() {
        let url = URL(string: "https://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&SeasonType=Regular+Season&Season=2017-18&PlayerID=" + String(playerId))
        
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                    let resultSetsTemp: NSArray = json["resultSets"] as! NSArray
                    let resultSets = resultSetsTemp[0] as! [String: Any]
                    let rowSet: NSArray = resultSets["rowSet"] as! NSArray
                    
                    self.turnRowSetIntoGames(rowSet)
                    
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                } catch {
                    print("Could not serialize")
                }
            }
        }).resume()
    }
    
    func turnRowSetIntoGames(_ rowSet: NSArray) {
        var i: Int = 0
        
        while i < rowSet.count {
            let currentGame: NSArray = rowSet[i] as! NSArray
            
            let gameNumber = rowSet.count - i
            let date = currentGame[3] as! String
            
            var opponent = currentGame[4] as! String
            opponent = opponent.substring(from: opponent.index(opponent.startIndex, offsetBy: 4))
            
            let winLoss = currentGame[5] as! String
            
            let MIN = currentGame[6] as! Double
            
            let PTS = currentGame[24] as! Double
            let OREB = currentGame[16] as! Double
            let DREB = currentGame[17] as! Double
            let REB = currentGame[18] as! Double
            let AST = currentGame[19] as! Double
            let STL = currentGame[20] as! Double
            let BLK = currentGame[21] as! Double
            let TOV = currentGame[22] as! Double
            let PF = currentGame[23] as! Double
            let PLUSMINUS = currentGame[25] as! Double
            
            let FGM = currentGame[7] as! Double
            let FGA = currentGame[8] as! Double
            let FGP = currentGame[9] as! Double
            
            let FG3M = currentGame[10] as! Double
            let FG3A = currentGame[11] as! Double
            let FG3P = currentGame[12] as! Double
            
            let FTM = currentGame[13] as! Double
            let FTA = currentGame[14] as! Double
            let FTP = currentGame[15] as! Double
            
            let game = Game(date: date, opponent: opponent, gameNumber: gameNumber, winLoss: winLoss, MIN: MIN, PTS: PTS, OREB: OREB, DREB: DREB, REB: REB, AST: AST, STL: STL, BLK: BLK, TOV: TOV, PF: PF, PLUSMINUS: PLUSMINUS, FGM: FGM, FGA: FGA, FGP: FGP, FG3M: FG3M, FG3A: FG3A, FG3P: FG3P, FTM: FTM, FTA: FTA, FTP: FTP)
            self.games.append(game)
            
            i = i + 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "GameCell") as? GameCell {
            let game = games[indexPath.row]
            
            cell.gameNumber.adjustsFontSizeToFitWidth = true
            cell.gameDetails.adjustsFontSizeToFitWidth = true
            cell.winLoss.adjustsFontSizeToFitWidth = true
            
            cell.gameNumber.text = "Game " + String(game.gameNumber)
            cell.gameDetails.text = game.date + " " + game.opponent
            cell.winLoss.text = game.winLoss
            
            cell.row1.stat1.text = "MIN"
            cell.row1.stat2.text = "PTS"
            cell.row1.stat3.text = "REB"
            cell.row1.stat4.text = "OREB"
            cell.row1.amount1.text = String(game.MIN)
            cell.row1.amount2.text = String(game.PTS)
            cell.row1.amount3.text = String(game.REB)
            cell.row1.amount4.text = String(game.OREB)
            
            cell.row2.stat1.text = "AST"
            cell.row2.stat2.text = "STL"
            cell.row2.stat3.text = "FG%"
            cell.row2.stat4.text = "FGM | FGA"
            cell.row2.amount1.text = String(game.AST)
            cell.row2.amount2.text = String(game.STL)
            cell.row2.amount3.text = String(game.FGP) + "%"
            cell.row2.amount4.text = String(game.FGM) + " | " + String(game.FGA)
            
            cell.row3.stat1.text = "BLK"
            cell.row3.stat2.text = "TOV"
            cell.row3.stat3.text = "3P%%"
            cell.row3.stat4.text = "3PM | 3PA"
            cell.row3.amount1.text = String(game.BLK)
            cell.row3.amount2.text = String(game.TOV)
            cell.row3.amount3.text = String(game.FG3P) + "%"
            cell.row3.amount4.text = String(game.FG3M) + " | " + String(game.FG3A)
            
            cell.row4.stat1.text = "PF"
            cell.row4.stat2.text = "+/-"
            cell.row4.stat3.text = "FT%"
            cell.row4.stat4.text = "FTM | FTA"
            cell.row4.amount1.text = String(game.PF)
            cell.row4.amount2.text = String(game.PLUSMINUS)
            cell.row4.amount3.text = String(game.FTP) + "%"
            cell.row4.amount4.text = String(game.FTM) + " | " + String(game.FTA)
            
            return cell
        } else {
            return GameCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    
}
