//
//  PlayerCell.swift
//  GT
//
//  Created by Raymond Li on 8/6/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class PlayerCell: UITableViewCell {
    
    @IBOutlet weak var headshot: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var team: UILabel!
    
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "PlayerCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func setValues(firstName: String, lastName: String, team: String, image: UIImage) {
        name.text = firstName + " " + lastName
        self.team.text = team
        headshot.image = image
    }
}
