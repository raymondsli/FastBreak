//
//  getImage.swift
//  GT
//
//  Created by Raymond Li on 8/6/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class GetImage {
    
    var myImage: UIImage
    var playerImages: [String: UIImage] = [:]
    
    public init() {
        self.myImage = UIImage(named: "Basketball")!
    }
    
    public func getImage(firstName: String, lastName: String) -> UIImage {
        let urlImage = "https://nba-players.herokuapp.com/players/" + lastName + "/" + firstName
    
        let url = URL(string: urlImage)
        
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if data != nil {
                do {
                    let image = UIImage(data: data!)
                    if (image != nil) {
                        self.myImage = image!
                        self.playerImages[firstName + " " + lastName] = image!
//                        DispatchQueue.main.async(execute: {
//                            self.myImage = image!
//                            self.playerImages[firstName + " " + lastName] = image!
//                        })
                    } else {
                        self.playerImages[firstName + " " + lastName] = self.myImage
//                        DispatchQueue.main.async(execute: {
//                            self.playerImages[firstName + " " + lastName] = self.myImage
//                        })
                    }
                }
            }
        }).resume()
        
        return myImage
    }
    
    func setImage(imageUrl: String) {

    }
    
//    func getPlayers() {
//        for id in playerIds.values {
//            
//            let urlString = "https://stats.nba.com/stats/commonplayerinfo/?PlayerId=" + String(id)
//            let url = URL(string: urlString)
//            
//            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
//                if data != nil {
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
//                        let resultSetsTemp: NSArray = json["resultSets"] as! NSArray
//                        let resultSets = resultSetsTemp[0] as! [String: Any]
//                        let rowSet: NSArray = resultSets["rowSet"] as! NSArray
//                        
//                        self.turnRowSetIntoPlayer(rowSet)
//                        
//                        DispatchQueue.main.async(execute: {
//                            self.tableView.reloadData()
//                        })
//                    } catch {
//                        print("Could not serialize")
//                    }
//                }
//            }).resume()
//        }
//    }
//    
//    func turnRowSetIntoPlayer(_ rowSet: NSArray) {
//        let currentPlayer: NSArray = rowSet[0] as! NSArray
//        let firstName = currentPlayer[1] as! String
//        let lastName = currentPlayer[2] as! String
//        
//        let height = currentPlayer[10] as! String
//        let weight = currentPlayer[11] as! String
//        
//        let position = currentPlayer[14] as! String
//        let currentTeam = currentPlayer[18] as! String
//        let yearsExperience = String(describing: currentPlayer[12])
//        let jerseyNumber = currentPlayer[13] as! String
//        var school = currentPlayer[7] as? String
//        if school == nil {
//            school = "NA"
//        } else {
//            school = currentPlayer[7] as? String
//        }
//        let draftYear = currentPlayer[26] as! String
//        let draftRound = currentPlayer[27] as! String
//        let draftNumber = currentPlayer[28] as! String
//        
//        let newPlayer = Player(firstName: firstName, lastName: lastName, height: height, weight: weight, position: position, currentTeam: currentTeam, yearsExperience: yearsExperience, jerseyNumber: jerseyNumber, school: school!, draftYear: draftYear, draftRound: draftRound, draftNumber: draftNumber)
//        
//        self.players.append(newPlayer)
//    }
}
