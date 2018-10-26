//
//  gameCell.swift
//  FBS
//
//  Created by Raymond Li on 8/14/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {
    
    @IBOutlet weak var star: FavoriteGameButton!
    @IBOutlet weak var gameNumber: UILabel!
    @IBOutlet weak var gameDetails: UILabel!
    @IBOutlet weak var winLoss: UILabel!
    @IBOutlet weak var row1: StatRow!
    @IBOutlet weak var row2: StatRow!
    @IBOutlet weak var row3: StatRow!
    @IBOutlet weak var row4: StatRow!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "GameCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
}
