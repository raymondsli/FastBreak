//
//  HomeViewController.swift
//
//  Created by Raymond Li on 8/12/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, NSURLConnectionDelegate {
    
    @IBOutlet weak var headerView: PlayerOverviewHead!
    @IBOutlet weak var personalView: PlayerPersonal!
    @IBOutlet weak var rankingsView: PlayerRankings!
    
    var playerImage: UIImage = UIImage(named: "NoHeadshot")!
    var playerId: Int = -1
    var displayName: String = ""
    var team: String = ""
    var player: Player = Player()
    var pDHeaders: [String: Int] = [:]
    var rankingHeaders: [String: Int] = [:]
    
    var numPlayers = 0
    var currentSeason: String = ""
    var currentYear: String = ""
    
    var getPlayerTask = URLSessionTask()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDate = Date()
        let calendar = Calendar.current
        let curYear = calendar.component(.year, from: currentDate)
        let curMonth = calendar.component(.month, from: currentDate)
        
        currentYear = String(curYear)
        
        if curMonth >= 10 {
            currentSeason = String(curYear) + "-" + String(curYear - 2000 + 1)
        } else {
            currentSeason = String(curYear - 1) + "-" + String(curYear - 2000)
        }
        
        headerView.headshot.image = playerImage
        headerView.name.text = displayName
        headerView.team.text = team
        headerView.gameDate.text = ""
        headerView.gameDetail.text = ""
        
        personalView.birthDateLabel.text = ""
        personalView.draftLabel.text = ""
        personalView.schoolLabel.text = ""
        personalView.experienceLabel.text = ""
        personalView.heightWeightLabel.text = ""
        
        getPlayer()
        
        getNextGameJSON()
        getStatRankings(category: "EFF")
        getStatRankings(category: "MIN")
        getStatRankings(category: "PTS")
        getStatRankings(category: "REB")
        getStatRankings(category: "AST")
        getStatRankings(category: "STL")
        getStatRankings(category: "BLK")
        getStatRankings(category: "TOV")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if getPlayerTask.state != .completed {
            getPlayerTask.cancel()
        }
    }
    
    
    func getPlayer() {
        let urlString = "https://stats.nba.com/stats/commonplayerinfo/?PlayerId=" + String(playerId)
        let url = URL(string: urlString)
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10
        sessionConfig.timeoutIntervalForResource = 10
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: url!, completionHandler: {(data, response, error) in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                    let resultSetsTemp: NSArray = json["resultSets"] as! NSArray
                    let resultSets = resultSetsTemp[0] as! [String: Any]
                    let head = resultSets["headers"] as! NSArray
                    let rowSet: NSArray = resultSets["rowSet"] as! NSArray
                    
                    self.fillPDHeadersDict(head: head)
                    self.turnRowSetIntoPlayer(rowSet)
                    
                    var birthDetails = self.player.birthDate + " (Age: " + self.player.age + ")"
                    if self.player.age == "" {
                        birthDetails = "NA"
                    }
                    
                    var draftDetails = self.player.draftYear + ": Rd " + self.player.draftRound + ", Pick " + self.player.draftNumber
                    if self.player.draftYear == "Undrafted" {
                        draftDetails = "Undrafted"
                    }
                    
                    if self.player.school == "" {
                        self.player.school = "None"
                    } else if self.player.school == "California-Los Angeles" {
                        self.player.school = "UCLA"
                    }
                    
                    if self.player.yearsExperience == "" {
                        self.player.yearsExperience = "NA"
                    }
                    
                    var heightWeightDetails = self.player.height + ", " + self.player.weight + " lbs"
                    if self.player.height == "" && self.player.weight == "" {
                        heightWeightDetails = "NA"
                    } else if self.player.height == "" {
                        heightWeightDetails = "NA, " + self.player.weight + " lbs"
                    } else if self.player.weight == "" {
                        heightWeightDetails = self.player.height + ", NA"
                    }
                    
                    var teamDetails = self.player.currentTeam + " | #" + self.player.jerseyNumber + " | " + self.player.position
                    if self.player.currentTeam == "" {
                        if self.player.position == "NA" {
                            teamDetails = "No Team"
                        } else {
                            teamDetails = "No Team | " + self.player.position
                        }
                    } else if self.player.jerseyNumber == "" {
                        if self.player.position == "NA" {
                            teamDetails = self.player.currentTeam
                        } else {
                            teamDetails = self.player.currentTeam + " | " + self.player.position
                        }
                    } else if self.player.position == "NA" {
                        if self.player.jerseyNumber == "" {
                            teamDetails = self.player.currentTeam
                        } else {
                            teamDetails = self.player.currentTeam + " | #" + self.player.jerseyNumber
                        }
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.headerView.headshot.image = self.playerImage
                        self.headerView.name.text = self.displayName
                        self.headerView.team.text = teamDetails
                        
                        self.personalView.birthDateLabel.text = birthDetails
                        self.personalView.draftLabel.text = draftDetails
                        self.personalView.schoolLabel.text = self.player.school
                        self.personalView.experienceLabel.text = self.player.yearsExperience
                        self.personalView.heightWeightLabel.text = heightWeightDetails
                    })
                } catch {
                    print("Could not serialize")
                }
            }
        })
        getPlayerTask = task
        task.resume()
    }
    
    func fillPDHeadersDict(head: NSArray) {
        for i in 0..<head.count {
            pDHeaders[head[i] as! String] = i
        }
    }
    
    func fillRankingHeadersDict(head: NSArray) {
        for i in 0..<head.count {
            rankingHeaders[head[i] as! String] = i
        }
    }
    
    func getNextGameJSON() {
        guard let pTeam = getTeamName(team: self.team) else {
            self.headerView.gameDate.text = "No Next Game"
            self.headerView.gameDetail.text = "No Opponent"
            return
        }
        
        let urlString = "http://data.nba.net/data/10s/prod/v1/" + currentYear + "/teams/" + pTeam + "/schedule.json"
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                    let league = json["league"] as! [String: Any]
                    let games: NSArray = league["standard"] as! NSArray

                    let nextGameOptional = self.findNextGame(games: games)
                    
                    guard let nextGame = nextGameOptional else {
                        return
                    }
                    
                    let startTime = nextGame["startTimeUTC"] as! String
                    let startDate = nextGame["startDateEastern"] as! String
                    let isHomeTeam = nextGame["isHomeTeam"] as! Bool
                    
                    var nextGameOpponent = ""
                    var homeOAway = ""
                    
                    if isHomeTeam {
                        let vTeam = nextGame["vTeam"] as! [String: String]
                        let oppo = vTeam["teamId"]
                        nextGameOpponent = self.getTeamFromId(teamId: oppo!)
                        homeOAway = "vs. "
                    } else {
                        let hTeam = nextGame["hTeam"] as! [String: String]
                        let oppo = hTeam["teamId"]
                        nextGameOpponent = self.getTeamFromId(teamId: oppo!)
                        homeOAway = "@"
                    }
                    
                    let nextGameDate = self.formatDate(date: startDate)
                    let nextGameTime = self.formatTime(time: startTime)
                    let nextGameDetails = homeOAway + nextGameOpponent + " - " + nextGameTime
                    
                    DispatchQueue.main.async(execute: {
                        self.headerView.gameDate.text = "Next Game: " + nextGameDate
                        self.headerView.gameDetail.text = nextGameDetails
                    })
                } catch {
                    print("Could not serialize")
                }
            }
        }).resume()
    }
    
    func getStatRankings(category: String) {
        let urlString = "https://stats.nba.com/stats/leagueleaders/?LeagueID=00&Season=" + currentSeason + "&PerMode=PerGame&SeasonType=Regular+Season&Scope=RS&StatCategory=" + category
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                    let resultSets = json["resultSet"] as! [String: Any]
                    let head = resultSets["headers"] as! NSArray
                    let rowSet: NSArray = resultSets["rowSet"] as! NSArray
                    
                    self.fillRankingHeadersDict(head: head)
                    let rankingArr = self.findRanking(rowSet, category: category)
                    let rank = rankingArr[0]
                    let amount = rankingArr[1]
                    
                    switch category {
                    case "EFF":
                        DispatchQueue.main.async(execute: {
                            self.rankingsView.stat1.statType.text = category
                            self.rankingsView.stat1.statAmount.text = amount
                            self.rankingsView.stat1.rank.text = rank
                        })
                    case "MIN":
                        DispatchQueue.main.async(execute: {
                            self.rankingsView.stat2.statType.text = category
                            self.rankingsView.stat2.statAmount.text = amount
                            self.rankingsView.stat2.rank.text = rank
                        })
                    case "PTS":
                        DispatchQueue.main.async(execute: {
                            self.rankingsView.stat3.statType.text = category
                            self.rankingsView.stat3.statAmount.text = amount
                            self.rankingsView.stat3.rank.text = rank
                        })
                    case "REB":
                        DispatchQueue.main.async(execute: {
                            self.rankingsView.stat4.statType.text = category
                            self.rankingsView.stat4.statAmount.text = amount
                            self.rankingsView.stat4.rank.text = rank
                        })
                    case "AST":
                        DispatchQueue.main.async(execute: {
                            self.rankingsView.stat5.statType.text = category
                            self.rankingsView.stat5.statAmount.text = amount
                            self.rankingsView.stat5.rank.text = rank
                        })
                    case "STL":
                        DispatchQueue.main.async(execute: {
                            self.rankingsView.stat6.statType.text = category
                            self.rankingsView.stat6.statAmount.text = amount
                            self.rankingsView.stat6.rank.text = rank
                        })
                    case "BLK":
                        DispatchQueue.main.async(execute: {
                            self.rankingsView.stat7.statType.text = category
                            self.rankingsView.stat7.statAmount.text = amount
                            self.rankingsView.stat7.rank.text = rank
                        })
                    case "TOV":
                        DispatchQueue.main.async(execute: {
                            self.rankingsView.stat8.statType.text = category
                            self.rankingsView.stat8.statAmount.text = amount
                            self.rankingsView.stat8.rank.text = rank
                        })
                    default:
                        print("No stat category")
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.rankingsView.numPlayersLabel.text = "\(self.numPlayers) Qualified Players \n (Need to play over 70% of games to qualify)"
                    })
                } catch {
                    print("Could not serialize")
                }
            }
        }).resume()
    }
    
    func findRanking(_ rowSet: NSArray, category: String) -> [String] {
        self.numPlayers = rowSet.count
        var i = 0
        
        while i < rowSet.count {
            let curPlayer: NSArray = rowSet[i] as! NSArray
            let curId = curPlayer[rankingHeaders["PLAYER_ID"]!] as! Int
            
            if curId == playerId {
                switch category {
                case "EFF":
                    let amountFloat = curPlayer[rankingHeaders["EFF"]!] as! Double
                    let roundedAmount = Double(round(100 * amountFloat) / 100)
                    let amount = String(roundedAmount)
                    return ["#" + String(i + 1), amount]
                case "MIN":
                    let amountFloat = curPlayer[rankingHeaders["MIN"]!] as! Double
                    let roundedAmount = Double(round(100 * amountFloat) / 100)
                    let amount = String(roundedAmount)
                    return ["#" + String(i + 1), amount]
                case "PTS":
                    let amountFloat = curPlayer[rankingHeaders["PTS"]!] as! Double
                    let roundedAmount = Double(round(100 * amountFloat) / 100)
                    let amount = String(roundedAmount)
                    return ["#" + String(i + 1), amount]
                case "REB":
                    let amountFloat = curPlayer[rankingHeaders["REB"]!] as! Double
                    let roundedAmount = Double(round(100 * amountFloat) / 100)
                    let amount = String(roundedAmount)
                    return ["#" + String(i + 1), amount]
                case "AST":
                    let amountFloat = curPlayer[rankingHeaders["AST"]!] as! Double
                    let roundedAmount = Double(round(100 * amountFloat) / 100)
                    let amount = String(roundedAmount)
                    return ["#" + String(i + 1), amount]
                case "STL":
                    let amountFloat = curPlayer[rankingHeaders["STL"]!] as! Double
                    let roundedAmount = Double(round(100 * amountFloat) / 100)
                    let amount = String(roundedAmount)
                    return ["#" + String(i + 1), amount]
                case "BLK":
                    let amountFloat = curPlayer[rankingHeaders["BLK"]!] as! Double
                    let roundedAmount = Double(round(100 * amountFloat) / 100)
                    let amount = String(roundedAmount)
                    return ["#" + String(i + 1), amount]
                case "TOV":
                    let amountFloat = curPlayer[rankingHeaders["TOV"]!] as! Double
                    let roundedAmount = Double(round(100 * amountFloat) / 100)
                    let amount = String(roundedAmount)
                    return ["#" + String(i + 1), amount]
                default:
                    return ["No Rank", "No Rank"]
                }
            }
            
            i = i + 1
        }
        
        return ["No Rank", "No Rank"]
    }
    
    func findNextGame(games: NSArray) -> [String: Any]? {
        
        for i in 0..<games.count {
            let currentGame = games[i] as! [String: Any]
            let statusNum = currentGame["statusNum"] as! Int
            if statusNum == 1 || statusNum == 2 {
                return currentGame
            }
        }
        return nil
    }
    
    func formatDate(date: String) -> String {
        let monthStartIndex = date.index(date.startIndex, offsetBy: 4)
        let dayStartIndex = date.index(date.startIndex, offsetBy: 6)

        let monthRange = monthStartIndex..<dayStartIndex
        
        let month = date[monthRange]
        let day = date.suffix(from: dayStartIndex)
        
        return month + "/" + day
    }
    
    func formatTime(time: String) -> String {
        let hourStartIndex = time.index(time.startIndex, offsetBy: 11)
        let hourEndIndex = time.index(time.startIndex, offsetBy: 13)
        
        let minuteStartIndex = time.index(time.startIndex, offsetBy: 14)
        let minuteEndIndex = time.index(time.startIndex, offsetBy: 16)
        
        let hourRange = hourStartIndex..<hourEndIndex
        let minuteRange = minuteStartIndex..<minuteEndIndex
        
        let utcHour = time[hourRange]
        let minuteString = time[minuteRange]
        
        guard let intHour = Int(utcHour) else {
            return "00:00"
        }
        
        var hourString = "00"
        var timeHalf = "PM"
        
        if intHour <= 6 {
            hourString = String(5 + intHour)
            timeHalf = "PM"
        } else if 7 <= intHour && intHour <= 18 {
            hourString = String(intHour - 7)
            timeHalf = "AM"
        } else if intHour == 19 {
            hourString = String(12)
            timeHalf = "PM"
        } else if 20 <= intHour && intHour <= 23 {
            hourString = String(intHour - 19)
            timeHalf = "PM"
        }
        
        return hourString + ":" + minuteString + " " + timeHalf + " PST"
    }
    
    func turnRowSetIntoPlayer(_ rowSet: NSArray) {
        let currentPlayer: NSArray = rowSet[pDHeaders["PERSON_ID"]!] as! NSArray
        let firstName = currentPlayer[pDHeaders["FIRST_NAME"]!] as! String
        let lastName = currentPlayer[pDHeaders["LAST_NAME"]!] as! String
        
        let heightString = currentPlayer[pDHeaders["HEIGHT"]!] as! String
        let height = convertHeight(height: heightString)
        let weight = currentPlayer[pDHeaders["WEIGHT"]!] as! String
        
        let positionLong = currentPlayer[pDHeaders["POSITION"]!] as! String
        let position = convertPosition(position: positionLong)
        let currentTeam = currentPlayer[pDHeaders["TEAM_ABBREVIATION"]!] as! String
        let yearsExperience = String(describing: currentPlayer[pDHeaders["SEASON_EXP"]!])
        let birthDateString = currentPlayer[pDHeaders["BIRTHDATE"]!] as! String
        let stringArr = convertBirthDate(birthDate: birthDateString)
        let birthDate = stringArr[0]
        let age = stringArr[1]
        let jerseyNumber = currentPlayer[pDHeaders["JERSEY"]!] as! String
        var school = currentPlayer[pDHeaders["SCHOOL"]!] as? String
        if school == nil {
            school = "NA"
        } else {
            school = currentPlayer[pDHeaders["SCHOOL"]!] as? String
        }
        let draftYear = currentPlayer[pDHeaders["DRAFT_YEAR"]!] as! String
        let draftRound = currentPlayer[pDHeaders["DRAFT_ROUND"]!] as! String
        let draftNumber = currentPlayer[pDHeaders["DRAFT_NUMBER"]!] as! String
        
        player = Player(firstName: firstName, lastName: lastName, height: height, weight: weight, position: position, currentTeam: currentTeam, yearsExperience: yearsExperience, birthDate: birthDate, age: age, jerseyNumber: jerseyNumber, school: school!, draftYear: draftYear, draftRound: draftRound, draftNumber: draftNumber)
        
    }
    
    func formatGameDate(input: String) -> String {
        let index1 = input.index(input.startIndex, offsetBy: 4)
        let year: String = String(input[..<index1])
        
        let index2 = input.index(input.startIndex, offsetBy: 5)
        let index3 = input.index(input.startIndex, offsetBy: 7)
        let month: String = String(input[index2..<index3])
        
        let index4 = input.index(input.startIndex, offsetBy: 8)
        let index5 = input.index(input.startIndex, offsetBy: 10)
        let date: String = String(input[index4..<index5])
        return month + "/" + date + "/" + year
    }
    
    func formatGameTime(input: String) -> String {
        let index1 = input.index(input.startIndex, offsetBy: 14)
        let index2 = input.index(input.startIndex, offsetBy: 16)
        let minute = String(input[index1..<index2])
        
        let index3 = input.index(input.startIndex, offsetBy: 11)
        let index4 = input.index(input.startIndex, offsetBy: 13)
        let hour1: String = String(input[index3..<index4])
        var intHour: Int = Int(hour1)!
        var ampm: String = "AM"
        
        //Convert to PST
        intHour = intHour - 3
        
        if (intHour >= 12) {
            ampm = "PM"
        }
        if (intHour >= 13) {
            intHour = intHour - 12
        }
        let hour: String = String(describing: intHour)
        
        return hour + ":" + minute + " "  + ampm + " PST"
    }
    
    func convertHeight(height: String) -> String {
        let heightArr = height.components(separatedBy: "-")
        if heightArr.count < 2 {
            return ""
        }
        
        return heightArr[0] + "'" + heightArr[1] + "''"
    }
    
    func convertPosition(position: String) -> String {
        if position == "Guard" {
            return "G"
        } else if position == "Forward" {
            return "F"
        } else if position == "Center" {
            return "C"
        } else if position == "Guard-Forward" || position == "Forward-Guard" {
            return "G/F"
        } else if position == "Forward-Center" || position == "Center-Forward" {
            return "F/C"
        }
        
        return "NA"
    }
    
    func convertBirthDate(birthDate: String) -> [String] {
        let yearEndIndex = birthDate.index(birthDate.startIndex, offsetBy: 4)
        
        let monthStartIndex = birthDate.index(birthDate.startIndex, offsetBy: 5)
        let monthEndIndex = birthDate.index(birthDate.startIndex, offsetBy: 7)
        
        let dayStartIndex = birthDate.index(birthDate.startIndex, offsetBy: 8)
        let dayEndIndex = birthDate.index(birthDate.startIndex, offsetBy: 10)
        
        let yearRange = birthDate.startIndex..<yearEndIndex
        let monthRange = monthStartIndex..<monthEndIndex
        let dayRange = dayStartIndex..<dayEndIndex
        
        let yearString = birthDate[yearRange]
        let monthStringNumber = birthDate[monthRange]
        let monthString = convertMonth(month: String(monthStringNumber))
        let dayString = birthDate[dayRange]
        
        let age = findAge(dayString: String(dayString), monthString: String(monthStringNumber), yearString: String(yearString))
        
        
        return [monthString + " " + dayString + ", " + yearString, age]
    }
    
    func findAge(dayString: String, monthString: String, yearString: String) -> String {
        guard let day = Int(dayString), let month = Int(monthString), let year = Int(yearString) else {
            return ""
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        let curYear = calendar.component(.year, from: currentDate)
        let curMonth = calendar.component(.month, from: currentDate)
        let curDay = calendar.component(.day, from: currentDate)
        
        if curMonth == month {
            if curDay >= day {
                return String(curYear - year)
            } else {
                return String(curYear - year - 1)
            }
        } else if curMonth < month {
            return String(curYear - year - 1)
        }
        
        return String(curYear - year)
    }
    
    func convertMonth(month: String) -> String {
        switch month {
        case "01":
            return "Jan"
        case "02":
            return "Feb"
        case "03":
            return "Mar"
        case "04":
            return "Apr"
        case "05":
            return "May"
        case "06":
            return "June"
        case "07":
            return "July"
        case "08":
            return "Aug"
        case "09":
            return "Sep"
        case "10":
            return "Oct"
        case "11":
            return "Nov"
        case "12":
            return "Dec"
        default:
            return ""
        }
    }
    
    
    func getTeamName(team: String) -> String? {
        switch team {
        case "ATL":
            return "hawks"
        case "BKN":
            return "nets"
        case "BOS":
            return "celtics"
        case "CHA":
            return "hornets"
        case "CHI":
            return "bulls"
        case "CLE":
            return "cavaliers"
        case "DAL":
            return "mavericks"
        case "DEN":
            return "nuggets"
        case "DET":
            return "pistons"
        case "GSW":
            return "warriors"
        case "HOU":
            return "rockets"
        case "IND":
            return "pacers"
        case "LAC":
            return "clippers"
        case "LAL":
            return "lakers"
        case "MEM":
            return "grizzlies"
        case "MIA":
            return "heat"
        case "MIL":
            return "bucks"
        case "MIN":
            return "timberwolves"
        case "NOP":
            return "pelicans"
        case "NYK":
            return "knicks"
        case "OKC":
            return "thunder"
        case "ORL":
            return "magic"
        case "PHI":
            return "sixers"
        case "PHX":
            return "suns"
        case "POR":
            return "blazers"
        case "SAC":
            return "kings"
        case "SAS":
            return "spurs"
        case "TOR":
            return "raptors"
        case "UTA":
            return "jazz"
        case "WAS":
            return "wizards"
        default:
            return nil
        }
    }
    
    func getTeamFromId(teamId: String) -> String {
        switch teamId {
        case "1610612737":
            return "ATL"
        case "1610612751":
            return "BKN"
        case "1610612738":
            return "BOS"
        case "1610612766":
            return "CHA"
        case "1610612741":
            return "CHI"
        case "1610612739":
            return "CLE"
        case "1610612742":
            return "DAL"
        case "1610612743":
            return "DEN"
        case "1610612765":
            return "DET"
        case "1610612744":
            return "GSW"
        case "1610612745":
            return "HOU"
        case "1610612754":
            return "IND"
        case "1610612746":
            return "LAC"
        case "1610612747":
            return "LAL"
        case "1610612763":
            return "MEM"
        case "1610612748":
            return "MIA"
        case "1610612749":
            return "MIL"
        case "1610612750":
            return "MIN"
        case "1610612740":
            return "NOP"
        case "1610612752":
            return "NYK"
        case "1610612760":
            return "OKC"
        case "1610612753":
            return "ORL"
        case "1610612755":
            return "PHI"
        case "1610612756":
            return "PHX"
        case "1610612757":
            return "POR"
        case "1610612758":
            return "SAC"
        case "1610612759":
            return "SAS"
        case "1610612761":
            return "TOR"
        case "1610612762":
            return "UTA"
        case "1610612764":
            return "WAS"
        default:
            return ""
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
}


