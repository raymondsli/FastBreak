//
//  DetailedGame.swift
//
//  Created by Raymond Li on 10/24/17.
//  Copyright © 2017 Raymond Li. All rights reserved.
//

import UIKit

class DetailedGameVC: UIViewController {
    
    @IBOutlet weak var gameDetails: UILabel!
    @IBOutlet weak var mainStats: UILabel!
    @IBOutlet weak var additionalStats: UILabel!
    @IBOutlet weak var shootingDetails: UILabel!
    
    var gameInfoString: String!
    var mainStatsString: String!
    var additionalStatsString: String!
    var shootingDetailsString: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Game Details"
        
        gameDetails.text = gameInfoString
        mainStats.text = mainStatsString
        additionalStats.text = additionalStatsString
        shootingDetails.text = shootingDetailsString
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
