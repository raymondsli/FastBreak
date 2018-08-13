//
//  HomeViewController.swift
//
//  Created by Raymond Li on 8/12/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit
import MessageUI

class HomeViewController: UIViewController, NSURLConnectionDelegate, MFMailComposeViewControllerDelegate {
    
    
    
    var playerId: Int = -1
    var firstName: String = ""
    var lastName: String = ""
    var displayName: String = ""
    var player: Player = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPlayer()
        sleep(1)
        
        tempNextGameJSON()
    }
    
    
    func getPlayer() {
        let urlString = "https://stats.nba.com/stats/commonplayerinfo/?PlayerId=" + String(playerId)
        let url = URL(string: urlString)

        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                    let resultSetsTemp: NSArray = json["resultSets"] as! NSArray
                    let resultSets = resultSetsTemp[0] as! [String: Any]
                    let rowSet: NSArray = resultSets["rowSet"] as! NSArray

                    self.turnRowSetIntoPlayer(rowSet)
                } catch {
                    print("Could not serialize")
                }
            }
        }).resume()
    }

    func turnRowSetIntoPlayer(_ rowSet: NSArray) {
        let currentPlayer: NSArray = rowSet[0] as! NSArray
        let firstName = currentPlayer[1] as! String
        let lastName = currentPlayer[2] as! String

        let height = currentPlayer[10] as! String
        let weight = currentPlayer[11] as! String

        let position = currentPlayer[14] as! String
        let currentTeam = currentPlayer[18] as! String
        let yearsExperience = String(describing: currentPlayer[12])
        let jerseyNumber = currentPlayer[13] as! String
        var school = currentPlayer[7] as? String
        if school == nil {
            school = "NA"
        } else {
            school = currentPlayer[7] as? String
        }
        let draftYear = currentPlayer[26] as! String
        let draftRound = currentPlayer[27] as! String
        let draftNumber = currentPlayer[28] as! String

        player = Player(firstName: firstName, lastName: lastName, height: height, weight: weight, position: position, currentTeam: currentTeam, yearsExperience: yearsExperience, jerseyNumber: jerseyNumber, school: school!, draftYear: draftYear, draftRound: draftRound, draftNumber: draftNumber)
        
    }
    
    func tempNextGameJSON() {
        guard let teamAbv = player.currentTeam, let team = getTeamName(team: teamAbv) else {
            return
        }
        
        let urlString = "http://data.nba.net/data/10s/prod/v1/2018/teams/" + team + "/schedule.json"
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                    let league = json["league"] as! [String: Any]
                    let games: NSArray = league["standard"] as! NSArray

                    if games.count == 0 {
                        return
                    } else {
                        let nextGame = games[0] as! [String: Any]
                        let startTime = nextGame["startTimeUTC"] as! String
                        let startDate = nextGame["startDateEastern"] as! String
                        let isHomeTeam = nextGame["isHomeTeam"] as! Bool
                        
                        var nextGameOpponent = ""
                        
                        if isHomeTeam {
                            let vTeam = nextGame["vTeam"] as! [String: String]
                            let oppo = vTeam["teamId"]
                            let nextGameOpponent = self.getTeamFromId(teamId: oppo!)
                        } else {
                            let hTeam = nextGame["hTeam"] as! [String: String]
                            let oppo = hTeam["teamId"]
                            let nextGameOpponent = self.getTeamFromId(teamId: oppo!)
                        }
                        
                        let nextGameDate = self.formatDate(date: startDate)
                        let nextGameTime = self.formatTime(time: startTime)
                        
                        DispatchQueue.main.async(execute: {
//                            self.nextOpponent.text = nextGameOpponent
//                            self.gameDate.text = nextGameDate
//                            self.gameTime.text = nextGameTime
                        })
                    }
                } catch {
                    print("Could not serialize")
                }
            }
        }).resume()
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
    
//    func getNextGameJSON(gameLogURL: String) {
//        let url = URL(string: gameLogURL)
//
//        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
//            if data != nil {
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
//                    //eventsList is an array of events
//                    let eventsList: NSArray = json["events"] as! NSArray
//                    if eventsList.count == 0 {
//                        return
//                    } else{
//                        let nextGameEvent = eventsList[0] as! [String: Any]
//
//                        self.nextGameString = nextGameEvent["title"] as! String
//                        let unformattedGameDate: String = nextGameEvent["datetime_local"] as! String
//                        self.nextGameDate = self.formatGameDate(input: unformattedGameDate)
//                        self.nextGameTime = self.formatGameTime(input: unformattedGameDate)
//
//                        DispatchQueue.main.async(execute: {
//                            //                            self.nextGame.text = "Next Game\n" + self.nextGameString + "\n" + self.nextGameDate + "\n" + self.nextGameTime
//                            self.nextGame.text = "Temp"
//                        })
//                    }
//                } catch {
//                    print("Could not serialize")
//                }
//            }
//        }).resume()
//    }
    
    func formatGameDate(input: String) -> String {
        let index1 = input.index(input.startIndex, offsetBy: 4)
        let year: String = input.substring(to: index1)
        
        let index2 = input.index(input.startIndex, offsetBy: 5)
        let index3 = input.index(input.startIndex, offsetBy: 7)
        let range1 = index2..<index3
        let month: String = input.substring(with: range1)
        
        let index4 = input.index(input.startIndex, offsetBy: 8)
        let index5 = input.index(input.startIndex, offsetBy: 10)
        let range2 = index4..<index5
        let date: String = input.substring(with: range2)
        return month + "/" + date + "/" + year
    }
    
    func formatGameTime(input: String) -> String {
        let index1 = input.index(input.startIndex, offsetBy: 14)
        let index2 = input.index(input.startIndex, offsetBy: 16)
        let range1 = index1..<index2
        let minute = input.substring(with: range1)
        
        let index3 = input.index(input.startIndex, offsetBy: 11)
        let index4 = input.index(input.startIndex, offsetBy: 13)
        let range2 = index3..<index4
        let hour1: String = input.substring(with: range2)
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
}


