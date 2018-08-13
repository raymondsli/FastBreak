//
//  PlayerPersonal.swift
//  FBS
//
//  Created by Raymond Li on 8/12/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class PlayerPersonal: UIView {
    
    @IBOutlet var contentView: PlayerPersonal!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var draftLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var heightWeightLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PlayerPersonal", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        birthDateLabel.adjustsFontSizeToFitWidth = true
        draftLabel.adjustsFontSizeToFitWidth = true
        schoolLabel.adjustsFontSizeToFitWidth = true
        experienceLabel.adjustsFontSizeToFitWidth = true
        heightWeightLabel.adjustsFontSizeToFitWidth = true
    }
    
}
