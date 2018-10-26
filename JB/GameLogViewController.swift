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
    var showGames = [Game]()
    var favoriteGames = Set<String>()
    
    @IBOutlet weak var tableView: UITableView!

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var loadingView: UIView = UIView()
    
    var getGamesTask = URLSessionTask()
    var assignedTask = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        
        let nib = UINib(nibName: "GameCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "GameCell")
        
        let window = UIApplication.shared.keyWindow!
        
        var navBarHeight: CGFloat = 40
        var tabBarHeight: CGFloat = 49
        if #available(iOS 11.0, *) {
            navBarHeight += window.safeAreaInsets.top
            tabBarHeight += window.safeAreaInsets.bottom
        }
        loadingView = UIView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y + navBarHeight, width: window.frame.width, height: window.frame.height - navBarHeight - tabBarHeight))
        loadingView.backgroundColor = .white
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        loadingView.addSubview(activityIndicator)
        window.addSubview(loadingView)
        
        activityIndicator.startAnimating()
        
        getGameLogJSON()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !assignedTask {
            getGameLogJSON()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if getGamesTask.state != .completed {
            getGamesTask.cancel()
            assignedTask = false
            if activityIndicator.isAnimating {
                self.activityIndicator.stopAnimating()
                self.loadingView.removeFromSuperview()
            }
        }
    }
    
    func getGameLogJSON() {
        let url = URL(string: "https://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&SeasonType=Regular+Season&Season=2018-19&PlayerID=" + String(playerId))
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5
        sessionConfig.timeoutIntervalForResource = 5
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: url!, completionHandler: {(data, response, error) in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                    let resultSetsTemp: NSArray = json["resultSets"] as! NSArray
                    let resultSets = resultSetsTemp[0] as! [String: Any]
                    let rowSet: NSArray = resultSets["rowSet"] as! NSArray
                    
                    self.turnRowSetIntoGames(rowSet)
                    
                    DispatchQueue.main.async(execute: {
                        self.activityIndicator.stopAnimating()
                        self.loadingView.removeFromSuperview()
                        self.tableView.reloadData()
                    })
                } catch {
                    print("Could not serialize")
                }
            }
        })
        
        getGamesTask = task
        assignedTask = true
        task.resume()
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
            
            let MIN = convertToString(val: currentGame[6] as! Double)
            
            let PTS = convertToString(val: currentGame[24] as! Double)
            let OREB = convertToString(val: currentGame[16] as! Double)
            let DREB = convertToString(val: currentGame[17] as! Double)
            let REB = convertToString(val: currentGame[18] as! Double)
            let AST = convertToString(val: currentGame[19] as! Double)
            let STL = convertToString(val: currentGame[20] as! Double)
            let BLK = convertToString(val: currentGame[21] as! Double)
            let TOV = convertToString(val: currentGame[22] as! Double)
            let PF = convertToString(val: currentGame[23] as! Double)
            let PLUSMINUS = convertToString(val: currentGame[25] as! Double)
            
            let FGM = convertToString(val: currentGame[7] as! Double)
            let FGA = convertToString(val: currentGame[8] as! Double)
            let FGP = convertToString(val: currentGame[9] as! Double * 100)
            
            let FG3M = convertToString(val: currentGame[10] as! Double)
            let FG3A = convertToString(val: currentGame[11] as! Double)
            let FG3P = convertToString(val: currentGame[12] as! Double * 100)
            
            let FTM = convertToString(val: currentGame[13] as! Double)
            let FTA = convertToString(val: currentGame[14] as! Double)
            let FTP = convertToString(val: currentGame[15] as! Double * 100)
            
            let game = Game(date: date, opponent: opponent, gameNumber: gameNumber, winLoss: winLoss, MIN: MIN, PTS: PTS, OREB: OREB, DREB: DREB, REB: REB, AST: AST, STL: STL, BLK: BLK, TOV: TOV, PF: PF, PLUSMINUS: PLUSMINUS, FGM: FGM, FGA: FGA, FGP: FGP, FG3M: FG3M, FG3A: FG3A, FG3P: FG3P, FTM: FTM, FTA: FTA, FTP: FTP)
            self.games.append(game)
            self.showGames.append(game)
            
            i = i + 1
        }
    }
    
    func convertToString(val: Double) -> String {
        let valString = String(val)
        let valArr = valString.components(separatedBy: ".")
        
        guard valArr.count == 2 else {
            return ""
        }
        
        var wholeNumberString = valArr[0]
        var decimalString = String(valArr[1].prefix(3))
        
        if decimalString.count == 3 {
            let lastString = decimalString.last
            let lastInt = Int(String(lastString!))
            
            guard lastInt != nil else {
                return ""
            }
            
            decimalString = String(decimalString.dropLast())
            
            if lastInt! >= 5 {
                let secondLastString = decimalString.last
                var secondLastInt = Int(String(secondLastString!))
                
                if secondLastInt == 9 {
                    secondLastInt = 0
                    var firstLastInt = Int(decimalString.prefix(1))
                    
                    if firstLastInt == 9 {
                        firstLastInt = 0
                        wholeNumberString = String(Int(wholeNumberString)! + 1)
                    } else {
                        firstLastInt = firstLastInt! + 1
                    }
                    
                    decimalString = String(firstLastInt!) + String(secondLastInt!)
                } else {
                    secondLastInt = secondLastInt! + 1
                    decimalString = decimalString.prefix(1) + String(secondLastInt!)
                }
            }
        }
        
        decimalString = removeTrailingZeroes(dec: decimalString)
        
        if decimalString == "" {
            return wholeNumberString
        }
        
        return wholeNumberString + "." + decimalString
    }
    
    
    
    func removeTrailingZeroes(dec: String) -> String {
        var decString = dec
        while decString.last == "0" {
            decString = String(decString.dropLast())
        }
        
        return decString
    }
    
    @objc func handleMarkAsFavorite(sender: FavoriteGameButton) {
        if sender.currentImage == UIImage(named: "Star") {
            sender.setImage(UIImage(named: "FilledStar")!, for: .normal)
            favoriteGames.insert(sender.gameDate)
        } else {
            sender.setImage(UIImage(named: "Star")!, for: .normal)
            favoriteGames.remove(sender.gameDate)
        }
        
        var favoriteGamesArray : [String] = []
        for gameDate in favoriteGames {
            favoriteGamesArray.append(gameDate)
        }
        
        let userDefaults = UserDefaults.standard
        let encodedPT: Data = NSKeyedArchiver.archivedData(withRootObject: favoriteGamesArray)
        userDefaults.set(encodedPT, forKey: "FavoriteGames")
        userDefaults.synchronize()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "GameCell") as? GameCell {
            let game = showGames[indexPath.row]
            
            cell.gameNumber.adjustsFontSizeToFitWidth = true
            cell.gameDetails.adjustsFontSizeToFitWidth = true
            cell.winLoss.adjustsFontSizeToFitWidth = true
            
            cell.gameNumber.text = "Game " + String(game.gameNumber)
            cell.gameDetails.text = game.date + " " + game.opponent
            cell.winLoss.text = game.winLoss
            
            if game.winLoss == "W" {
                cell.winLoss.textColor = UIColor(red: 38/255, green: 166/255, blue: 91/255, alpha: 1.0)
            } else if game.winLoss == "L" {
                cell.winLoss.textColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
            }
            
            cell.row1.stat1.text = "MIN"
            cell.row1.stat2.text = "PTS"
            cell.row1.stat3.text = "REB"
            cell.row1.stat4.text = "OREB"
            cell.row1.amount1.text = game.MIN
            cell.row1.amount2.text = game.PTS
            cell.row1.amount3.text = game.REB
            cell.row1.amount4.text = game.OREB
            
            cell.row2.stat1.text = "AST"
            cell.row2.stat2.text = "STL"
            cell.row2.stat3.text = "FG%"
            cell.row2.stat4.text = "FGM | FGA"
            cell.row2.amount1.text = game.AST
            cell.row2.amount2.text = game.STL
            cell.row2.amount3.text = game.FGP + "%"
            cell.row2.amount4.text = game.FGM + " | " + game.FGA
            
            cell.row3.stat1.text = "BLK"
            cell.row3.stat2.text = "TOV"
            cell.row3.stat3.text = "3P%"
            cell.row3.stat4.text = "3PM | 3PA"
            cell.row3.amount1.text = game.BLK
            cell.row3.amount2.text = game.TOV
            cell.row3.amount3.text = game.FG3P + "%"
            cell.row3.amount4.text = game.FG3M + " | " + game.FG3A
            
            cell.row4.stat1.text = "PF"
            cell.row4.stat2.text = "+/-"
            cell.row4.stat3.text = "FT%"
            cell.row4.stat4.text = "FTM | FTA"
            cell.row4.amount1.text = game.PF
            cell.row4.amount2.text = game.PLUSMINUS
            cell.row4.amount3.text = game.FTP + "%"
            cell.row4.amount4.text = game.FTM + " | " + game.FTA
            
            return cell
        } else {
            return GameCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if games.count == 0 {
            self.tableView.setEmptyMessage("No games played")
        } else if showGames.count == 0 {
            self.tableView.setEmptyMessage("No games to show")
        } else {
            self.tableView.restore()
        }
        return showGames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 370.0
    }
    
    @IBAction func gameLogPressed(_ sender: Any) {
        if games.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        if getGamesTask.state != .completed {
            getGamesTask.cancel()
            assignedTask = false
            if activityIndicator.isAnimating {
                self.activityIndicator.stopAnimating()
                self.loadingView.removeFromSuperview()
            }
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
    
}

class FavoriteGameButton : UIButton {
    var gameDate = ""
}
