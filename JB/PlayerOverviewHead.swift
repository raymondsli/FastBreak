//
//  PlayerOverviewHead.swift
//  FBS
//
//  Created by Raymond Li on 8/12/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class PlayerOverviewHead: UIView {
    
    @IBOutlet var contentView: PlayerOverviewHead!
    @IBOutlet weak var headshot: UIImageView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var team: UILabel!
    @IBOutlet weak var gameDate: UILabel!
    @IBOutlet weak var gameDetail: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PlayerOverviewHead", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        headshot.contentMode = .scaleAspectFit
        headshot.clipsToBounds = true
        
        position.adjustsFontSizeToFitWidth = true
        name.adjustsFontSizeToFitWidth = true
        team.adjustsFontSizeToFitWidth = true
        gameDate.adjustsFontSizeToFitWidth = true
        gameDetail.adjustsFontSizeToFitWidth = true
        number.adjustsFontSizeToFitWidth = true
    }
}
