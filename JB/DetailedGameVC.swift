//
//  DetailedGame.swift
//
//  Created by Raymond Li on 10/24/17.
//  Copyright © 2017 Raymond Li. All rights reserved.
//

import UIKit

class DetailedGameVC: UIViewController {

    
    
    var gameInfoString: String!
    var mainStatsString: String!
    var additionalStatsString: String!
    var shootingDetailsString: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Game Details"
//
//        gameDetails.text = gameInfoString
//        mainStats.text = mainStatsString
//        additionalStats.text = additionalStatsString
//        shootingDetails.text = shootingDetailsString
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

}
