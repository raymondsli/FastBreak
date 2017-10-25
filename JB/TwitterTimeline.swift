//
//  JBTwitterTimeline.swift
//  JB
//
//  Created by Raymond Li on 8/19/16.
//  Copyright © 2016 Raymond Li. All rights reserved.
//

import UIKit
import TwitterKit

class JBTwitterTimeline: TWTRTimelineViewController {
    
    var curPlayer: String! = ""
    var playerDict: [String: [String]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = self.tabBarController?.viewControllers?[0] as! HomeViewController
        playerDict = homeVC.playerDict
        
        let userDefaults = UserDefaults.standard
        if let decoded = userDefaults.object(forKey: "curPlayer") as? Data {
            curPlayer = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! String
        } else {
            curPlayer = "Jaylen Brown"
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: curPlayer)
            userDefaults.set(encodedData, forKey: "curPlayer")
            userDefaults.synchronize()
        }
        
        let client = TWTRAPIClient()
        self.dataSource = TWTRUserTimelineDataSource(screenName: playerDict[curPlayer]![4], apiClient: client)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        if let decoded = userDefaults.object(forKey: "curPlayer") as? Data {
            if NSKeyedUnarchiver.unarchiveObject(with: decoded) as? String != curPlayer {
                self.viewDidLoad()
            }
        }
    }
}
