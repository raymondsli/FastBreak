//
//  GameLogViewController.swift
//
//  Created by Raymond Li on 8/12/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit
class GameLogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let playerId = ""
    var games = [Game]()
    
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
    
    func getGameLogJSON() {
        let url = URL(string: "https://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&SeasonType=Regular+Season&Season=2017-18&PlayerID=" + playerId)
        
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell") as? GameCell {
            
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
    
    
}
