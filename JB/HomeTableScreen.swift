//
//  HomeTableScreen.swift
//  FBS
//
//  Created by Raymond Li on 8/6/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class HomeTableScreen: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var playerNames: [String] = []
    var playerIds: [String: Int] = [:]
    var playerImages: [String: UIImage] = [:]
    var playerTeams: [String: String] = [:]
    var twitterHandles: [String: String] = [:]
    
    var favoritePlayers = Set<String>()
    var currentPlayerNames: [String] = []
    var currentTeamFilter: String = "All Teams"
    var currentSearchFilter: String = ""
    var lastIndex = 0
    
    var getPlayerIdTask = URLSessionDataTask()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var drop: DropMenuButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favButton.setImage(UIImage(named: "Star")!, for: .normal)
        favButton.tintColor = UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 1)
        
        drop.setTitle("All Teams", for: .normal)
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        let nib = UINib(nibName: "PlayerCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "PlayerCell")
        
        getPlayerIds(urlAllPlayers: "https://stats.nba.com/stats/commonallplayers/?LeagueID=00&Season=2018-19&IsOnlyCurrentSeason=1")
        sleep(1)
        
        if getPlayerIdTask.state != .completed {
            getPlayerIdTask.cancel()
            useBackupPlayerIds()
        }
        
        if let decoded = UserDefaults.standard.object(forKey: "FavoritePlayers") as? Data {
            let favoritePlayersArray = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [String]
            for playerName in favoritePlayersArray {
                favoritePlayers.insert(playerName)
            }
        }
        
        getTwitters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.allowsSelection = true
        
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

    func getPlayerIds(urlAllPlayers: String) {
        let url = URL(string: urlAllPlayers)
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                    let resultSetsTemp: NSArray = json["resultSets"] as! NSArray
                    let resultSets = resultSetsTemp[0] as! [String: Any]
                    let rowSet: NSArray = resultSets["rowSet"] as! NSArray
                    
                    self.turnRowSetIntoPlayerIds(rowSet)
                    
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                } catch {
                    print("Could not serialize")
                }
            }
        })
        getPlayerIdTask = task
        task.resume()
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
    
    func useBackupPlayerIds() {
        if let path = Bundle.main.path(forResource: "allplayers", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: Any]
                let resultSetsTemp: NSArray = json["resultSets"] as! NSArray
                let resultSets = resultSetsTemp[0] as! [String: Any]
                let rowSet: NSArray = resultSets["rowSet"] as! NSArray
                
                turnRowSetIntoPlayerIds(rowSet)
            } catch {
                print("Could not parse player JSON")
            }
        }
    }
    
    func turnRowSetIntoPlayerIds(_ rowSet: NSArray) {
        var i: Int = 0
        
        while i < rowSet.count {
            let currentPlayer: NSArray = rowSet[i] as! NSArray
            let playerId = currentPlayer[0] as! Int
            let playerName = currentPlayer[2] as! String
            
            if playerName == "Justin Jackson" && currentPlayer[4] as! String == "2018" {
                playerNames.append("Justin Jackson")
                playerIds["Jackson 2"] = playerId
                playerTeams["Jackson 2"] = "ORL"
                playerImages["Jackson 2"] = UIImage(named: "NoHeadshot")!
                i = i + 1
                continue
            }
            
            playerNames.append(playerName)
            playerIds[playerName] = playerId
            
            var team = currentPlayer[10] as! String
            if team == "" {
                team = "NA"
            }
            
            playerTeams[playerName] = team
            
            i = i + 1
        }
        
        currentPlayerNames = playerNames
    }
    
    
    func getPlayerImage(playerName: String) -> UIImage {
        guard let id = playerIds[playerName] else {
            return UIImage(named: "NoHeadshot")!
        }
        
        let playerId = String(id)
        
        let urlImage = "https://ak-static.cms.nba.com/wp-content/uploads/headshots/nba/latest/260x190/" + playerId + ".png"
        let url = URL(string: urlImage)
    
        let _data = try? Data(contentsOf: url!)
        
        guard let data = _data, let image = UIImage(data: data) else {
            return UIImage(named: "NoHeadshot")!
        }
        
        return image
    }
    
    @objc func handleMarkAsFavorite(sender: DisclosureButton) {
        if sender.currentImage == UIImage(named: "Star") {
            sender.setImage(UIImage(named: "FilledStar")!, for: .normal)
            favoritePlayers.insert(sender.playerName)
        } else {
            sender.setImage(UIImage(named: "Star")!, for: .normal)
            favoritePlayers.remove(sender.playerName)
        }
        
        var favoritePlayersArray : [String] = []
        for playerName in favoritePlayers {
            favoritePlayersArray.append(playerName)
        }
        
        let userDefaults = UserDefaults.standard
        let encodedPT: Data = NSKeyedArchiver.archivedData(withRootObject: favoritePlayersArray)
        userDefaults.set(encodedPT, forKey: "FavoritePlayers")
        userDefaults.synchronize()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell") as? PlayerCell {
            lastIndex = indexPath.row
            let playerName = currentPlayerNames[indexPath.row]
            
            
            let starButton = DisclosureButton(type: .system)
            starButton.playerName = playerName
            if favoritePlayers.contains(playerName) {
                starButton.setImage(UIImage(named: "FilledStar")!, for: .normal)
            } else {
                starButton.setImage(UIImage(named: "Star")!, for: .normal)
            }
            starButton.tintColor = UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 1)
            starButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            starButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
            //cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.accessoryView = starButton
            
            cell.headshot.contentMode = .scaleAspectFit
            cell.headshot.backgroundColor = .lightGray
            cell.name.adjustsFontSizeToFitWidth = true
            cell.team.adjustsFontSizeToFitWidth = true
            
            if indexPath.row != currentPlayerNames.count - 1 && playerName == "Justin Jackson" && currentPlayerNames[indexPath.row + 1] == "Justin Jackson" {
                cell.name.text = "Justin Jackson"
                cell.team.text = playerTeams["Jackson 2"]!
                cell.headshot.image = playerImages["Jackson 2"]!
                return cell
            }

            cell.name.text = playerName
            cell.team.text = playerTeams[playerName]
            
            if let image = playerImages[playerName] {
                cell.headshot.image = image
            } else {
                cell.headshot.image = UIImage(named: "NoHeadshot")!
                
                DispatchQueue.global(qos: .userInitiated).async {
                    if indexPath.row < self.lastIndex - 8 || indexPath.row > self.lastIndex + 8 {
                        return
                    }
                    
                    let urlImage = "https://ak-static.cms.nba.com/wp-content/uploads/headshots/nba/latest/260x190/" + String(self.playerIds[playerName]!) + ".png"
                    let url = URL(string: urlImage)

                    let _data = try? Data(contentsOf: url!)
                    
                    guard let data = _data, let image = UIImage(data: data) else {
                        self.playerImages[playerName] = UIImage(named: "NoHeadshot")!
                        return
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.playerImages[playerName] = image
                        
                        if tableView.cellForRow(at: indexPath) != nil {
                            cell.headshot.image = self.playerImages[playerName]
                        }
                    })
                }
            }
            
            return cell
        } else {
            return PlayerCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.allowsSelection = false //prevents double tapping cell
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
            
            if let image = playerImages[playerName] {
                upcoming.playerImage = image
            } else {
                upcoming.playerImage = getPlayerImage(playerName: playerName)
            }
            
            upcoming.playerId = playerIds[playerName]!
            upcoming.displayName = playerName
            if let team = playerTeams[playerName] {
                upcoming.team = team
            }
            
            gameLogVC.playerId = playerIds[playerName]!
            seasonStatsVC.playerId = playerIds[playerName]!
            seasonStatsVC.playerName = playerName
            
            if let twitterHandle = twitterHandles[playerName] {
                twitterVC.twitterHandle = twitterHandle
            }
            
            if indexPath.row != currentPlayerNames.count - 1 && playerName == "Justin Jackson" && currentPlayerNames[indexPath.row + 1] == "Justin Jackson" {
                upcoming.playerImage = playerImages["Jackson 2"]!
                upcoming.playerId = playerIds["Jackson 2"]!
                upcoming.team = playerTeams["Jackson 2"]!
                gameLogVC.playerId = playerIds["Jackson 2"]!
                seasonStatsVC.playerId = playerIds["Jackson 2"]!
                twitterVC.twitterHandle = "j5t4l_"
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
    
    func updateCurrentPlayerNamesAndReload() {
        currentPlayerNames = playerNames
        
        if currentTeamFilter != "All Teams" {
            currentPlayerNames = currentPlayerNames.filter { playerTeams[$0] == currentTeamFilter }
        }
        
        if currentSearchFilter != "" {
            currentPlayerNames = currentPlayerNames.filter { $0.lowercased().contains(currentSearchFilter) }
        }
        
        if favButton.imageView?.image == UIImage(named: "FilledStar")! {
            currentPlayerNames = currentPlayerNames.filter { favoritePlayers.contains($0) }
        }
        
        tableView.reloadData()
        
        if currentPlayerNames.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func dropMenuPressed(team: String) {
        searchBarTextDidEndEditing(searchBar)
        
        currentPlayerNames = playerNames
        currentTeamFilter = team
        
        updateCurrentPlayerNamesAndReload()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.isEmpty == false && searchText != "\\" else {
            currentPlayerNames = playerNames
            if currentTeamFilter != "All Teams" {
                currentPlayerNames = currentPlayerNames.filter { playerTeams[$0] == currentTeamFilter }
            }
            if favButton.imageView?.image == UIImage(named: "FilledStar")! {
                currentPlayerNames = currentPlayerNames.filter { favoritePlayers.contains($0) }
            }
            
            tableView.reloadData()
            return
        }
        
        currentSearchFilter = searchText.lowercased()
        
        if currentTeamFilter == "All Teams" {
            if favButton.imageView?.image == UIImage(named: "FilledStar")! {
                currentPlayerNames = playerNames.filter { $0.lowercased().contains(searchText.lowercased()) && favoritePlayers.contains($0) }
            } else {
                currentPlayerNames = playerNames.filter { $0.lowercased().contains(searchText.lowercased()) }
            }
        } else {
            if favButton.imageView?.image == UIImage(named: "FilledStar")! {
                currentPlayerNames = playerNames.filter { $0.lowercased().contains(searchText.lowercased()) && playerTeams[$0] == currentTeamFilter && favoritePlayers.contains($0) }
            } else {
                currentPlayerNames = playerNames.filter {
                    $0.lowercased().contains(searchText.lowercased()) && playerTeams[$0] == currentTeamFilter
                }
            }
        }
        
        tableView.reloadData()
        
        if currentPlayerNames.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    @IBAction func favButtonTouched(_ sender: Any) {
        searchBarTextDidEndEditing(searchBar)
        
        if favButton.imageView?.image == UIImage(named: "FilledStar")! {
            currentPlayerNames = playerNames
            favButton.setImage(UIImage(named: "Star")!, for: .normal)
        } else if favButton.imageView?.image == UIImage(named: "Star")!{
            currentPlayerNames = []
            for player in playerNames {
                if favoritePlayers.contains(player) {
                    currentPlayerNames.append(player)
                }
            }
            favButton.setImage(UIImage(named: "FilledStar")!, for: .normal)
        }
        tableView.reloadData()
        
        if favoritePlayers.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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


class DisclosureButton: UIButton {
    var playerName = ""
}
