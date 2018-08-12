//
//  HomeTableScreen.swift
//  GT
//
//  Created by Raymond Li on 8/6/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class HomeTableScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var playerIds: [String: Int] = [:]
    var namesToLabel: [String: String] = [:]
    var playerFirstNames: [String] = []
    var playerLastNames: [String] = []
    var playerImages: [String: UIImage] = [:]
    var playerTeams: [String: String] = [:]
    var playerPositions: [String: String] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "PlayerCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "PlayerCell")
        
//        if (playerIds.count == 0) {
//            getPlayerIds(urlAllPlayers: "https://stats.nba.com/stats/commonallplayers/?LeagueID=00&Season=2017-18&IsOnlyCurrentSeason=1")
//            sleep(1)
//        }

        populateData()
        
        DispatchQueue.global(qos: .background).async {
            self.getPlayerImages()
        }

        DispatchQueue.global(qos: .background).async {
            self.getPlayerImages2()
        }

        DispatchQueue.global(qos: .background).async {
            self.getPlayerImages3()
        }

        DispatchQueue.global(qos: .background).async {
            self.getPlayerImages4()
        }

        DispatchQueue.global(qos: .background).async {
            self.getPlayerImages5()
        }

        DispatchQueue.global(qos: .background).async {
            self.getPlayerImages6()
        }

        DispatchQueue.global(qos: .background).async {
            self.getPlayerImages7()
        }

        DispatchQueue.global(qos: .background).async {
            self.getPlayerImages8()
        }
        
        tableView.reloadData()
    }

    func getPlayerIds(urlAllPlayers: String) {
        let url = URL(string: urlAllPlayers)
        
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                    let resultSetsTemp: NSArray = json["resultSets"] as! NSArray
                    let resultSets = resultSetsTemp[0] as! [String: Any]
                    let rowSet: NSArray = resultSets["rowSet"] as! NSArray
                    
                    self.turnRowSetIntoPlayerIds(rowSet)
                } catch {
                    print("Could not serialize")
                }
            }
        }).resume()
    }
    
    func populateData() {
        if let path = Bundle.main.path(forResource: "allplayers", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: Any]
                let resultSetsTemp: NSArray = json["resultSets"] as! NSArray
                let resultSets = resultSetsTemp[0] as! [String: Any]
                let rowSet: NSArray = resultSets["rowSet"] as! NSArray
                
                turnRowSetIntoPlayerIds(rowSet)
            } catch {
                print("Could not parse JSON")
            }
        }
    }
    
    func turnRowSetIntoPlayerIds(_ rowSet: NSArray) {
        var i: Int = 0
        
        while i < rowSet.count {
            let currentPlayer: NSArray = rowSet[i] as! NSArray
            let playerId = currentPlayer[0] as! Int
            let playerName = currentPlayer[2] as! String
            
            let fullNameArr = playerName.components(separatedBy: " ")
            
            var firstName = ""
            var lastName = ""
            
            var characterSet = CharacterSet.letters.inverted
            characterSet.remove(charactersIn: "-")
            
            if fullNameArr.count == 1 {
                lastName = fullNameArr[0].components(separatedBy: characterSet).joined()
            } else if fullNameArr.count == 2 {
                firstName = fullNameArr[0].components(separatedBy: characterSet).joined()
                lastName = fullNameArr[1].components(separatedBy: characterSet).joined()
            } else {
                i = i + 1
                continue
            }
            
            playerIds[firstName + " " + lastName] = playerId
            namesToLabel[firstName + " " + lastName] = playerName
            
            playerFirstNames.append(firstName)
            playerLastNames.append(lastName)
            
            var team = currentPlayer[10] as! String
            if team == "" {
                team = "NA"
            }
            
            playerTeams[firstName + " " + lastName] = team
            
            i = i + 1
        }
    }
    
    func getPlayerData() {
        var i = 0
        
        while i < playerFirstNames.count {
            let fullName = playerFirstNames[i] + " " + playerLastNames[i]
            let id = String(playerIds[fullName]!)
            
            let urlString = "https://stats.nba.com/stats/commonplayerinfo/?PlayerId=" + id
            let url = URL(string: urlString)
            
            let request = URLRequest(url: url!)
            do {
                print("Calling \(fullName)")
                let response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
                let data = try NSURLConnection.sendSynchronousRequest(request, returning: response)
                
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]

                //let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                let resultSetsTemp: NSArray = json["resultSets"] as! NSArray
                let resultSets = resultSetsTemp[0] as! [String: Any]
                let rowSet: NSArray = resultSets["rowSet"] as! NSArray
                let currentPlayer: NSArray = rowSet[0] as! NSArray

                let position = self.convertPosition(position: currentPlayer[14] as? String)
                
                playerPositions[fullName] = position
            } catch {
                print("Could not serialize")
            }
            
            i = i + 1
        }
    }
    
    func convertPosition(position: String?) -> String {
        if position == "Guard-Forward" || position == "Forward-Guard" {
            return "G/F"
        } else if position == "Guard" {
            return "G"
        } else if position == "Forward" {
            return "F"
        } else if position == "Center" {
            return "C"
        } else if position == "Forward-Center" || position == "Center-Forward" {
            return "F/C"
        } else {
            return "NA"
        }
    }
    
    func getImage(i: Int) {
        if i < 0 || i >= playerFirstNames.count || i >= playerLastNames.count {
            return
        }
        let firstName = playerFirstNames[i]
        let lastName = playerLastNames[i]
        
        let fullName = firstName + " " + lastName
        
        if playerImages[fullName] != nil {
            return
        }
        
        let urlImage = "https://nba-players.herokuapp.com/players/" + lastName + "/" + firstName
        let url = URL(string: urlImage)
        let data = try? Data(contentsOf: url!)
        
        if (data == nil) {
            return
        }
        
        let image = UIImage(data: data!)
        
        if image != nil {
            playerImages[fullName] = image
        } else {
            playerImages[fullName] = UIImage(named: "Neutral")!
        }
    }
    
    func getPlayerImages() {
        var i: Int = 0

        while i < playerLastNames.count {
            if playerImages.count == playerLastNames.count {
                print("Raymond finished")
                return
            }
            getImage(i: i)
            i = i + 1
        }
    }
    
    func getPlayerImages2() {
        var i: Int = playerLastNames.count - 1
        
        while i >= 0 {
            if playerImages.count == playerLastNames.count {
                print("Raymond finished")
                return
            }
            getImage(i: i)
            i = i - 1
        }
    }
    
    func getPlayerImages3() {
        var i: Int = playerLastNames.count / 2
        
        while i < playerLastNames.count {
            if playerImages.count == playerLastNames.count {
                print("Raymond finished")
                return
            }
            getImage(i: i)
            i = i + 1
        }
    }
    
    func getPlayerImages4() {
        var i: Int = playerLastNames.count / 2
        
        while i >= 0 {
            if playerImages.count == playerLastNames.count {
                print("Raymond finished")
                return
            }
            getImage(i: i)
            i = i - 1
        }
    }
    
    func getPlayerImages5() {
        var i: Int = playerLastNames.count / 4
        
        while i >= 0 {
            if playerImages.count == playerLastNames.count {
                print("Raymond finished")
                return
            }
            getImage(i: i)
            i = i - 1
        }
    }
    
    func getPlayerImages6() {
        var i: Int = playerLastNames.count / 4
        
        while i < playerLastNames.count / 2 {
            if playerImages.count == playerLastNames.count {
                print("Raymond finished")
                return
            }
            getImage(i: i)
            i = i + 1
        }
    }
    
    func getPlayerImages7() {
        var i: Int = playerLastNames.count * 3 / 4
        
        while i < playerLastNames.count {
            if playerImages.count == playerLastNames.count {
                print("Raymond finished")
                return
            }
            getImage(i: i)
            i = i + 1
        }
    }
    
    func getPlayerImages8() {
        var i: Int = playerLastNames.count * 3 / 4
        
        while i > playerLastNames.count / 2 {
            if playerImages.count == playerLastNames.count {
                print("Raymond finished")
                return
            }
            getImage(i: i)
            i = i - 1
        }
    }
    
    
    func getPlayerImage(firstName: String, lastName: String) -> UIImage {
        let urlImage = "https://nba-players.herokuapp.com/players/" + lastName + "/" + firstName
        
        let url = URL(string: urlImage)
        
        let data = try? Data(contentsOf: url!)
        
        let image = UIImage(data: data!)
        if image != nil {
            return image!
        } else {
            return UIImage(named: "Neutral")!
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell") as? PlayerCell {
            let firstName = playerFirstNames[indexPath.row]
            let lastName = playerLastNames[indexPath.row]
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.headshot.contentMode = .scaleAspectFit
            cell.headshot.backgroundColor = .lightGray
            
            let fullName = firstName + " " + lastName
            
            cell.name.adjustsFontSizeToFitWidth = true
            cell.team.adjustsFontSizeToFitWidth = true
            
            cell.name.text = namesToLabel[fullName]
            cell.team.text = playerTeams[fullName]
            
            if let image = playerImages[fullName] {
                cell.headshot.image = image
            } else {
                cell.headshot.image = UIImage(named: "Neutral")!
                
                DispatchQueue.global(qos: .userInitiated).async {
                    let urlImage = "https://nba-players.herokuapp.com/players/" + lastName + "/" + firstName
                
                    let url = URL(string: urlImage)
                
                    let data = try? Data(contentsOf: url!)
                
                    if data == nil {
                        return
                    }
                
                    let image = UIImage(data: data!)
                    if image != nil {
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            self.playerImages[firstName + " " + lastName] = image
                            
                            if tableView.cellForRow(at: indexPath) != nil {
                                cell.headshot.image = self.playerImages[firstName + " " + lastName]
                            }
                        })
                    } else {
                        self.playerImages[firstName + " " + lastName] = UIImage(named: "Neutral")!
                    }
                }
            }
            
            return cell
        } else {
            return PlayerCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "showDetailedGame", sender: self)
//        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Called before the segue is executed. Sets the labels of the detailed game view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetailedGame" {
//            let upcoming: DetailedGameVC = segue.destination as! DetailedGameVC
//            let indexPath = self.tableView.indexPathForSelectedRow!
//
//            upcoming.gameInfoString = titleLabel
//            upcoming.mainStatsString = mainStatsLabel
//            upcoming.additionalStatsString = additionalStatsLabel
//            upcoming.shootingDetailsString = shootingDetailsLabel
//
//            self.tableView.deselectRow(at: indexPath, animated: true)
//        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerIds.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}
