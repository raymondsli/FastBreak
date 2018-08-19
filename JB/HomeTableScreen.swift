//
//  HomeTableScreen.swift
//  GT
//
//  Created by Raymond Li on 8/6/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class HomeTableScreen: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var playerIds: [String: Int] = [:]
    var namesToLabel: [String: String] = [:]
    var playerFirstNames: [String] = []
    var playerLastNames: [String] = []
    var playerNames: [String] = []
    var playerImages: [String: UIImage] = [:]
    var playerTeams: [String: String] = [:]
    
    var twitterHandles: [String: String] = [:]
    
    var currentPlayerNames: [String] = []
    var currentTeamFilter: String = "All Teams"
    var currentSearchFilter: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var drop: DropMenuButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drop.setTitle("All Teams", for: .normal)
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        let nib = UINib(nibName: "PlayerCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "PlayerCell")
        
        if (playerIds.count == 0) {
            getPlayerIds(urlAllPlayers: "https://stats.nba.com/stats/commonallplayers/?LeagueID=00&Season=2018-19&IsOnlyCurrentSeason=1")
            sleep(1)
        }
        
        getTwitters()
        
//        if playerIds.count == 0 {
//            populateData()
//        }
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        drop.initMenu(["All Teams", "ATL", "BKN", "BOS", "CHA", "CHI", "CLE", "DAL", "DEN", "DET", "GSW", "HOU", "IND", "LAC", "LAL", "MEM", "MIA", "MIL", "MIN", "NOP", "NYK", "OKC", "ORL", "PHI", "PHX", "POR", "SAC", "SAS", "TOR", "UTA", "WAS"],
        actions: [({ () -> (Void) in
            self.dropMenuPressed(team: "All Teams")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "ATL")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "BKN")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "BOS")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "CHA")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "CHI")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "CLE")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "DAL")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "DEN")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "DET")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "GSW")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "HOU")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "IND")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "LAC")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "LAL")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "MEM")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "MIA")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "MIL")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "MIN")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "NOP")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "NYK")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "OKC")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "ORL")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "PHI")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "PHX")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "POR")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "SAC")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "SAS")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "TOR")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "UTA")
        }), ({ () -> (Void) in
            self.dropMenuPressed(team: "WAS")
        }),
            ])
    }
    
    func dropMenuPressed(team: String) {
        searchBarTextDidEndEditing(searchBar)
        
        if team == "All Teams" {
            if currentSearchFilter == "" {
                currentPlayerNames = playerNames
            } else {
                currentPlayerNames = playerNames.filter { $0.lowercased().contains(currentSearchFilter) }
            }
            currentTeamFilter = "All Teams"
        } else {
            if currentSearchFilter == "" {
                currentPlayerNames = playerNames.filter { return playerTeams[$0] == team }
            } else {
                currentPlayerNames = playerNames.filter {
                    playerTeams[$0] == team && $0.lowercased().contains(currentSearchFilter)
                }
            }
            currentTeamFilter = team
        }
        if currentPlayerNames.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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
    
    func getTwitters() {
        if let newPath = Bundle.main.path(forResource: "twitterJSON", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: newPath), options:.mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: String]
                self.twitterHandles = json
            } catch {
                print("Could not parse Twitter JSON")
            }
        }
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
                print("Could not parse Player JSON")
            }
        }
        
        if let newPath = Bundle.main.path(forResource: "twitterJSON", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: newPath), options:.mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: String]
                self.twitterHandles = json
            } catch {
                print("Could not parse Twitter JSON")
            }
        }
    }
    
    func turnRowSetIntoPlayerIds(_ rowSet: NSArray) {
        var i: Int = 0
        
        while i < rowSet.count {
            let currentPlayer: NSArray = rowSet[i] as! NSArray
            let playerId = currentPlayer[0] as! Int
            let playerName = currentPlayer[2] as! String
            
            if playerName == "Michael Porter Jr." {
                playerTeams["Michael Porter"] = "DEN"
                playerImages["Michael Porter"] = UIImage(named: "NoHeadshot")!
                namesToLabel["Michael Porter"] = "Michael Porter Jr."
                playerNames.append("Michael Porter Jr.")
                playerFirstNames.append("Michael")
                playerLastNames.append("Porter")
                i = i + 1
                continue
            }
            
            let firstName = getFirstName(playerName: playerName)
            let lastName = getLastName(playerName: playerName)
            
            playerIds[firstName + " " + lastName] = playerId
            namesToLabel[firstName + " " + lastName] = playerName
            playerNames.append(playerName)
            
            playerFirstNames.append(firstName)
            playerLastNames.append(lastName)
            
            
            var team = currentPlayer[10] as! String
            if team == "" {
                team = "NA"
            }
            
            playerTeams[playerName] = team
            
            i = i + 1
        }
        
        currentPlayerNames = playerNames
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
            playerImages[fullName] = UIImage(named: "NoHeadshot")!
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
            return UIImage(named: "NoHeadshot")!
        }
        
    }
    
    func getFirstName(playerName: String) -> String {
        let fullNameArr = playerName.components(separatedBy: " ")
        
        var characterSet = CharacterSet.letters.inverted
        characterSet.remove(charactersIn: "-")
        
        if fullNameArr.count < 2 {
            return ""
        }
        
        return fullNameArr[fullNameArr.count - 2].components(separatedBy: characterSet).joined()
    }
    
    func getLastName(playerName: String) -> String {
        let fullNameArr = playerName.components(separatedBy: " ")
        
        var characterSet = CharacterSet.letters.inverted
        characterSet.remove(charactersIn: "-")
        
        if fullNameArr.count == 1 {
            return fullNameArr[0].components(separatedBy: characterSet).joined()
        } else if fullNameArr.count >= 2 {
            return fullNameArr[fullNameArr.count - 1].components(separatedBy: characterSet).joined()
        }
        
        return ""
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell") as? PlayerCell {
            let firstName = getFirstName(playerName: currentPlayerNames[indexPath.row])
            let lastName = getLastName(playerName: currentPlayerNames[indexPath.row])
            
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.headshot.contentMode = .scaleAspectFit
            cell.headshot.backgroundColor = .lightGray
            
            let fullName = firstName + " " + lastName
            
            cell.name.adjustsFontSizeToFitWidth = true
            cell.team.adjustsFontSizeToFitWidth = true
            
            if currentPlayerNames[indexPath.row] == "Michael Porter Jr." {
                cell.name.text = "Michael Porter Jr."
                cell.team.text = "DEN"
                cell.headshot.image = UIImage(named: "NoHeadshot")!
                return cell
            }
            
            let displayName = namesToLabel[fullName]
            cell.name.text = displayName
            cell.team.text = playerTeams[displayName!]
            
            if let image = playerImages[fullName] {
                cell.headshot.image = image
            } else {
                cell.headshot.image = UIImage(named: "NoHeadshot")!
                
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
                        self.playerImages[firstName + " " + lastName] = UIImage(named: "NoHeadshot")!
                    }
                }
            }
            
            return cell
        } else {
            return PlayerCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        drop.closeItems()
        self.performSegue(withIdentifier: "toPlayer", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlayer" {
            let upcomingTabVC: UITabBarController = segue.destination as! UITabBarController
            let upcoming: HomeViewController = upcomingTabVC.viewControllers?[0] as! HomeViewController
            let gameLogVC: GameLogViewController = upcomingTabVC.viewControllers?[1] as! GameLogViewController
            let seasonStatsVC: SeasonStatsViewController = upcomingTabVC.viewControllers?[2] as! SeasonStatsViewController
            let twitterVC: TwitterVC = upcomingTabVC.viewControllers?[3] as! TwitterVC
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            let playerName = currentPlayerNames[indexPath.row]
            let firstName = getFirstName(playerName: playerName)
            let lastName = getLastName(playerName: playerName)
            
            if let image = playerImages[firstName + " " + lastName] {
                upcoming.playerImage = image
            }
            
            upcoming.playerId = playerIds[firstName + " " + lastName]!
            upcoming.firstName = firstName
            upcoming.lastName = lastName
            upcoming.displayName = playerName
            if let team = playerTeams[playerName] {
                upcoming.team = team
            }
            
            gameLogVC.playerId = playerIds[firstName + " " + lastName]!
            seasonStatsVC.playerId = playerIds[firstName + " " + lastName]!
            seasonStatsVC.playerName = playerName
            
            if let twitterHandle = twitterHandles[playerName] {
                twitterVC.twitterHandle = twitterHandle
            }
            
            if playerName == "Michael Porter Jr." {
                upcoming.playerImage = UIImage(named: "NoHeadshot")!
                upcoming.playerId = 1629008
                upcoming.team = "DEN"
                gameLogVC.playerId = 1629008
                seasonStatsVC.playerId = 1629008
            }

            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPlayerNames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.isEmpty == false && searchText != "\\" else {
            if currentTeamFilter == "All Teams" {
                currentPlayerNames = playerNames
            } else {
                currentPlayerNames = playerNames.filter { playerTeams[$0] == currentTeamFilter }
            }
            tableView.reloadData()
            return
        }
        
        if currentTeamFilter == "All Teams" {
            currentPlayerNames = playerNames.filter { $0.lowercased().contains(searchText.lowercased()) }
        } else {
            currentPlayerNames = playerNames.filter {
                $0.lowercased().contains(searchText.lowercased()) && playerTeams[$0] == currentTeamFilter
            }
        }
        tableView.reloadData()
        if currentPlayerNames.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if currentPlayerNames.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        drop.closeItems()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if let text = searchBar.text {
            currentSearchFilter = text.lowercased()
        } else {
            currentSearchFilter = ""
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
        drop.closeItems()
    }
}
