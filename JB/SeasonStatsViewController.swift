//
//  SeasonStatsViewController.swift
//
//  Created by Raymond Li on 10/24/17.
//  Copyright © 2017 Raymond Li. All rights reserved.
//

import UIKit

class SeasonStatsViewController: UIViewController, NSURLConnectionDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var baseStatView: BaseStatView!
    @IBOutlet weak var advancedStatView: AdvancedStatView!
    
    var baseStat: BaseStat = BaseStat()
    var advancedStat: AdvancedStat = AdvancedStat()
    var playerId = 0
    var playerName = ""
    var currentSeason: String = ""
    var baseHeaders: [String: Int] = [:]
    var advancedHeaders: [String: Int] = [:]
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var loadingView: UIView = UIView()
    
    var baseTask = URLSessionTask()
    var advancedTask = URLSessionTask()
    var assignedTask = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let currentDate = Date()
        let calendar = Calendar.current
        let curYear = calendar.component(.year, from: currentDate)
        let curMonth = calendar.component(.month, from: currentDate)
        
        if curMonth >= 10 {
            currentSeason = String(curYear) + "-" + String(curYear - 2000 + 1)
            yearLabel.text = String(curYear) + "-" + String(curYear + 1)
        } else {
            currentSeason = String(curYear - 1) + "-" + String(curYear - 2000)
            yearLabel.text = String(curYear - 1) + "-" + String(curYear)
        }
        
        nameLabel.text = ""
        yearLabel.adjustsFontSizeToFitWidth = true
        nameLabel.adjustsFontSizeToFitWidth = true
        
        getSeasonJSON(type: "Base")
        getSeasonJSON(type: "Advanced")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !assignedTask {
            getSeasonJSON(type: "Base")
            getSeasonJSON(type: "Advanced")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if baseTask.state != .completed || advancedTask.state != .completed {
            baseTask.cancel()
            advancedTask.cancel()
            assignedTask = false
            if activityIndicator.isAnimating {
                self.activityIndicator.stopAnimating()
                self.loadingView.removeFromSuperview()
            }
        }
    }
    
    func getSeasonJSON(type: String) {
        let urlString = "https://stats.nba.com/stats/playerdashboardbyyearoveryear?DateFrom=&DateTo=&GameSegment=&LastNGames=0&LeagueID=00&Location=&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PaceAdjust=N&PerMode=PerGame&Period=0&PlusMinus=N&Rank=N&Season=" + currentSeason + "&SeasonSegment=&SeasonType=Regular+Season&ShotClockRange=&Split=yoy&VsConference=&VsDivision=&MeasureType=" + type + "&PlayerID=" + String(playerId)
        let url = URL(string: urlString)
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5
        sessionConfig.timeoutIntervalForResource = 5
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: url!, completionHandler: {(data, response, error) in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                    let resultSetsTemp: NSArray = json["resultSets"] as! NSArray
                    let resultSets = resultSetsTemp[1] as! [String: Any]
                    let headers: NSArray = resultSets["headers"] as! NSArray
                    let rowSetTemp: NSArray = resultSets["rowSet"] as! NSArray
                    
                    if (rowSetTemp.count == 0) {
                        DispatchQueue.main.async(execute: {
                            self.nameLabel.text = self.playerName
                            self.setToNA(type: type)
                            self.activityIndicator.stopAnimating()
                            self.loadingView.removeFromSuperview()
                        })
                        return
                    }
                    
                    let season: NSArray = rowSetTemp[0] as! NSArray
                    
                    if season[1] as! String != self.currentSeason {
                        DispatchQueue.main.async(execute: {
                            self.nameLabel.text = self.playerName
                            self.setToNA(type: type)
                            self.activityIndicator.stopAnimating()
                            self.loadingView.removeFromSuperview()
                        })
                        return
                    }
                    
                    if type == "Base" {
                        self.fillBaseHeaderDict(headers: headers)
                        self.turnRowSetIntoBaseStat(rowSet: season)
                    } else if type == "Advanced" {
                        self.fillAdvancedHeaderDict(headers: headers)
                        self.turnRowSetIntoAdvancedStat(rowSet: season)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.nameLabel.text = self.playerName
                        
                        self.baseStatView.row1.stat1.text = "GP"
                        self.baseStatView.row1.stat2.text = "MIN"
                        self.baseStatView.row1.stat3.text = "PTS"
                        self.baseStatView.row1.stat4.text = "REB"
                        self.baseStatView.row1.amount1.text = self.baseStat.GP
                        self.baseStatView.row1.amount2.text = self.baseStat.MIN
                        self.baseStatView.row1.amount3.text = self.baseStat.PTS
                        self.baseStatView.row1.amount4.text = self.baseStat.TREB
                        
                        self.baseStatView.row2.stat1.text = "OREB"
                        self.baseStatView.row2.stat2.text = "DREB"
                        self.baseStatView.row2.stat3.text = "FG%"
                        self.baseStatView.row2.stat4.text = "FGM | FGA"
                        self.baseStatView.row2.amount1.text = self.baseStat.OREB
                        self.baseStatView.row2.amount2.text = self.baseStat.DREB
                        self.baseStatView.row2.amount3.text = self.baseStat.FGP + "%"
                        self.baseStatView.row2.amount4.text = self.baseStat.FGM + " | " + self.baseStat.FGA

                        self.baseStatView.row3.stat1.text = "AST"
                        self.baseStatView.row3.stat2.text = "STL"
                        self.baseStatView.row3.stat3.text = "3P%"
                        self.baseStatView.row3.stat4.text = "3PM | 3PA"
                        self.baseStatView.row3.amount1.text = self.baseStat.AST
                        self.baseStatView.row3.amount2.text = self.baseStat.STL
                        self.baseStatView.row3.amount3.text = self.baseStat.FG3P + "%"
                        self.baseStatView.row3.amount4.text = self.baseStat.FG3M + " | " + self.baseStat.FG3A

                        self.baseStatView.row4.stat1.text = "BLK"
                        self.baseStatView.row4.stat2.text = "TOV"
                        self.baseStatView.row4.stat3.text = "FT%"
                        self.baseStatView.row4.stat4.text = "FTM | FTA"
                        self.baseStatView.row4.amount1.text = self.baseStat.BLK
                        self.baseStatView.row4.amount2.text = self.baseStat.TOV
                        self.baseStatView.row4.amount3.text = self.baseStat.FTP + "%"
                        self.baseStatView.row4.amount4.text = self.baseStat.FTM + " | " + self.baseStat.FTA
                        
                        self.advancedStatView.row1.stat1.text = "TPACE"
                        self.advancedStatView.row1.stat2.text = "USG"
                        self.advancedStatView.row1.stat3.text = "OREB%"
                        self.advancedStatView.row1.stat4.text = "OFFRAT"
                        self.advancedStatView.row1.amount1.text = self.advancedStat.PACE
                        self.advancedStatView.row1.amount2.text = self.advancedStat.USG + "%"
                        self.advancedStatView.row1.amount3.text = self.advancedStat.OREBP + "%"
                        self.advancedStatView.row1.amount4.text = self.advancedStat.ORAT
                        
                        self.advancedStatView.row2.stat1.text = "EFG"
                        self.advancedStatView.row2.stat2.text = "TS%"
                        self.advancedStatView.row2.stat3.text = "DREB%"
                        self.advancedStatView.row2.stat4.text = "DRAT"
                        self.advancedStatView.row2.amount1.text = self.advancedStat.EFG + "%"
                        self.advancedStatView.row2.amount2.text = self.advancedStat.TSP + "%"
                        self.advancedStatView.row2.amount3.text = self.advancedStat.DREBP + "%"
                        self.advancedStatView.row2.amount4.text = self.advancedStat.DRAT
                        
                        self.advancedStatView.row3.stat1.text = "AST/TO"
                        self.advancedStatView.row3.stat2.text = "AST%"
                        self.advancedStatView.row3.stat3.text = "REB%"
                        self.advancedStatView.row3.stat4.text = "NETRAT"
                        self.advancedStatView.row3.amount1.text = self.advancedStat.A2T
                        self.advancedStatView.row3.amount2.text = self.advancedStat.ASTP + "%"
                        self.advancedStatView.row3.amount3.text = self.advancedStat.REBP + "%"
                        self.advancedStatView.row3.amount4.text = self.advancedStat.NRAT
                        
                        self.activityIndicator.stopAnimating()
                        self.loadingView.removeFromSuperview()
                    })
                } catch {
                    print("Could not serialize")
                }
            }
        })
        if type == "Base" {
            baseTask = task
        } else if type == "Advanced" {
            advancedTask = task
            assignedTask = true
        }
        task.resume()
    }
    
    
    func turnRowSetIntoBaseStat(rowSet: NSArray) {
        let year = rowSet[baseHeaders["GROUP_VALUE"]!] as! String
        let team = rowSet[baseHeaders["TEAM_ABBREVIATION"]!] as! String
        
        let GP = String(rowSet[baseHeaders["GP"]!] as! Int)
        let MIN = convertToString(val: rowSet[baseHeaders["MIN"]!] as! Double)
        let PF = convertToString(val: rowSet[baseHeaders["PF"]!] as! Double)
        
        let FGM = convertToString(val: rowSet[baseHeaders["FGM"]!] as! Double)
        let FGA = convertToString(val: rowSet[baseHeaders["FGA"]!] as! Double)
        let FGP = convertToString(val: rowSet[baseHeaders["FG_PCT"]!] as! Double * 100)
        
        let FG3M = convertToString(val: rowSet[baseHeaders["FG3M"]!] as! Double)
        let FG3A = convertToString(val: rowSet[baseHeaders["FG3A"]!] as! Double)
        let FG3P = convertToString(val: rowSet[baseHeaders["FG3_PCT"]!] as! Double * 100)
        
        let FTM = convertToString(val: rowSet[baseHeaders["FTM"]!] as! Double)
        let FTA = convertToString(val: rowSet[baseHeaders["FTA"]!] as! Double)
        let FTP = convertToString(val: rowSet[baseHeaders["FT_PCT"]!] as! Double * 100)
        
        let OREB = convertToString(val: rowSet[baseHeaders["OREB"]!] as! Double)
        let DREB = convertToString(val: rowSet[baseHeaders["DREB"]!] as! Double)
        let TREB = convertToString(val: rowSet[baseHeaders["REB"]!] as! Double)
        
        let PTS = convertToString(val: rowSet[baseHeaders["PTS"]!] as! Double)
        let AST = convertToString(val: rowSet[baseHeaders["AST"]!] as! Double)
        let STL = convertToString(val: rowSet[baseHeaders["STL"]!] as! Double)
        let BLK = convertToString(val: rowSet[baseHeaders["BLK"]!] as! Double)
        let TOV = convertToString(val: rowSet[baseHeaders["TOV"]!] as! Double)
        
        self.baseStat = BaseStat(year: year, team: team, GP: GP, MIN: MIN, PF: PF, FGM: FGM, FGA: FGA, FGP: FGP, FG3M: FG3M, FG3A: FG3A, FG3P: FG3P, FTM: FTM, FTA: FTA, FTP: FTP, OREB: OREB, DREB: DREB, TREB: TREB, PTS: PTS, AST: AST, STL: STL, BLK: BLK, TOV: TOV)
    }
    
    func turnRowSetIntoAdvancedStat(rowSet: NSArray) {
        let ORAT = convertToString(val: rowSet[advancedHeaders["OFF_RATING"]!] as! Double)
        let DRAT = convertToString(val: rowSet[advancedHeaders["DEF_RATING"]!] as! Double)
        let NRAT = convertToString(val: rowSet[advancedHeaders["NET_RATING"]!] as! Double)
        let USG = convertToString(val: rowSet[advancedHeaders["USG_PCT"]!] as! Double * 100)
        let EFG = convertToString(val: rowSet[advancedHeaders["EFG_PCT"]!] as! Double * 100)
        let TSP = convertToString(val: rowSet[advancedHeaders["TS_PCT"]!] as! Double * 100)
        let ASTP = convertToString(val: rowSet[advancedHeaders["AST_PCT"]!] as! Double * 100)
        let A2T = convertToString(val: rowSet[advancedHeaders["AST_TO"]!] as! Double)
        let REBP = convertToString(val: rowSet[advancedHeaders["REB_PCT"]!] as! Double * 100)
        let OREBP = convertToString(val: rowSet[advancedHeaders["OREB_PCT"]!] as! Double * 100)
        let DREBP = convertToString(val: rowSet[advancedHeaders["DREB_PCT"]!] as! Double * 100)
        let PACE = convertToString(val: rowSet[advancedHeaders["PACE"]!] as! Double)
        
        self.advancedStat = AdvancedStat(ORAT: ORAT, DRAT: DRAT, NRAT: NRAT, USG: USG, EFG: EFG, TSP: TSP, ASTP: ASTP, A2T: A2T, REBP: REBP, OREBP: OREBP, DREBP: DREBP, PACE: PACE)
    }
    
    func fillBaseHeaderDict(headers: NSArray) {
        for i in 0..<headers.count {
            baseHeaders[headers[i] as! String] = i
        }
    }
    
    func fillAdvancedHeaderDict(headers: NSArray) {
        for i in 0..<headers.count {
            advancedHeaders[headers[i] as! String] = i
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
    
    func setToNA(type: String) {
        if type == "Base" {
            self.baseStatView.row1.stat1.text = "GP"
            self.baseStatView.row1.stat2.text = "MIN"
            self.baseStatView.row1.stat3.text = "PTS"
            self.baseStatView.row1.stat4.text = "REB"
            self.baseStatView.row1.amount1.text = "NA"
            self.baseStatView.row1.amount2.text = "NA"
            self.baseStatView.row1.amount3.text = "NA"
            self.baseStatView.row1.amount4.text = "NA"
            
            self.baseStatView.row2.stat1.text = "OREB"
            self.baseStatView.row2.stat2.text = "DREB"
            self.baseStatView.row2.stat3.text = "FG%"
            self.baseStatView.row2.stat4.text = "FGM | FGA"
            self.baseStatView.row2.amount1.text = "NA"
            self.baseStatView.row2.amount2.text = "NA"
            self.baseStatView.row2.amount3.text = "NA"
            self.baseStatView.row2.amount4.text = "NA | NA"
            
            self.baseStatView.row3.stat1.text = "AST"
            self.baseStatView.row3.stat2.text = "STL"
            self.baseStatView.row3.stat3.text = "3P%"
            self.baseStatView.row3.stat4.text = "3PM | 3PA"
            self.baseStatView.row3.amount1.text = "NA"
            self.baseStatView.row3.amount2.text = "NA"
            self.baseStatView.row3.amount3.text = "NA"
            self.baseStatView.row3.amount4.text = "NA | NA"
            
            self.baseStatView.row4.stat1.text = "BLK"
            self.baseStatView.row4.stat2.text = "TOV"
            self.baseStatView.row4.stat3.text = "FT%"
            self.baseStatView.row4.stat4.text = "FTM | FTA"
            self.baseStatView.row4.amount1.text = "NA"
            self.baseStatView.row4.amount2.text = "NA"
            self.baseStatView.row4.amount3.text = "NA"
            self.baseStatView.row4.amount4.text = "NA | NA"
        } else if type == "Advanced" {
            self.advancedStatView.row1.stat1.text = "TPACE"
            self.advancedStatView.row1.stat2.text = "USG"
            self.advancedStatView.row1.stat3.text = "OREB%"
            self.advancedStatView.row1.stat4.text = "OFFRAT"
            self.advancedStatView.row1.amount1.text = "NA"
            self.advancedStatView.row1.amount2.text = "NA"
            self.advancedStatView.row1.amount3.text = "NA"
            self.advancedStatView.row1.amount4.text = "NA"
            
            self.advancedStatView.row2.stat1.text = "EFG"
            self.advancedStatView.row2.stat2.text = "TS%"
            self.advancedStatView.row2.stat3.text = "DREB%"
            self.advancedStatView.row2.stat4.text = "DRAT"
            self.advancedStatView.row2.amount1.text = "NA"
            self.advancedStatView.row2.amount2.text = "NA"
            self.advancedStatView.row2.amount3.text = "NA"
            self.advancedStatView.row2.amount4.text = "NA"
            
            self.advancedStatView.row3.stat1.text = "AST/TO"
            self.advancedStatView.row3.stat2.text = "AST%"
            self.advancedStatView.row3.stat3.text = "REB%"
            self.advancedStatView.row3.stat4.text = "NETRAT"
            self.advancedStatView.row3.amount1.text = "NA"
            self.advancedStatView.row3.amount2.text = "NA"
            self.advancedStatView.row3.amount3.text = "NA"
            self.advancedStatView.row3.amount4.text = "NA"
        }
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
        return team
    }
    
    @IBAction func backPressed(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        if baseTask.state != .completed || advancedTask.state != .completed {
            baseTask.cancel()
            advancedTask.cancel()
            assignedTask = false
            if activityIndicator.isAnimating {
                self.activityIndicator.stopAnimating()
                self.loadingView.removeFromSuperview()
            }
        }
        self.dismiss(animated: false, completion: nil)
    }
    
}

struct BaseStat {
    var year: String = ""
    var team: String = ""
    var GP: String = ""
    
    var MIN: String = ""
    var PF: String = "" //Not used
    
    var FGM: String = ""
    var FGA: String = ""
    var FGP: String = ""
    
    var FG3M: String = ""
    var FG3A: String = ""
    var FG3P: String = ""
    
    var FTM: String = ""
    var FTA: String = ""
    var FTP: String = ""
    
    var OREB: String = ""
    var DREB: String = ""
    var TREB: String = ""
    
    var PTS: String = ""
    var AST: String = ""
    var STL: String = ""
    var BLK: String = ""
    var TOV: String = ""
    
    init(year: String, team: String, GP: String, MIN: String, PF: String, FGM: String, FGA: String, FGP: String, FG3M: String, FG3A: String, FG3P: String, FTM: String, FTA: String, FTP: String, OREB: String, DREB: String, TREB: String, PTS: String, AST: String, STL: String, BLK: String, TOV: String) {
        self.year = year
        self.team = team
        self.GP = GP
        self.MIN = MIN
        self.PF = PF
        self.FGM = FGM
        self.FGA = FGA
        self.FGP = FGP
        self.FG3M = FG3M
        self.FG3A = FG3A
        self.FG3P = FG3P
        self.FTM = FTM
        self.FTA = FTA
        self.FTP = FTP
        self.OREB = OREB
        self.DREB = DREB
        self.TREB = TREB
        self.PTS = PTS
        self.AST = AST
        self.STL = STL
        self.BLK = BLK
        self.TOV = TOV
    }
    
    init() {}
}

struct AdvancedStat {
    var ORAT: String = ""
    var DRAT: String = ""
    var NRAT: String = ""
    var USG: String = ""
    var EFG: String = ""
    var TSP: String = ""
    var ASTP: String = ""
    var A2T: String = ""
    var REBP: String = ""
    var OREBP: String = ""
    var DREBP: String = ""
    var PACE: String = ""
    
    init(ORAT: String, DRAT: String, NRAT: String, USG: String, EFG: String, TSP: String, ASTP: String, A2T: String, REBP: String, OREBP: String, DREBP: String, PACE: String) {
        self.ORAT = ORAT
        self.DRAT = DRAT
        self.NRAT = NRAT
        self.USG = USG
        self.EFG = EFG
        self.TSP = TSP
        self.ASTP = ASTP
        self.A2T = A2T
        self.REBP = REBP
        self.OREBP = OREBP
        self.DREBP = DREBP
        self.PACE = PACE
    }
    
    init() {}
}

