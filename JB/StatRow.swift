//
//  StatRow.swift
//  FBS
//
//  Created by Raymond Li on 8/14/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class StatRow: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stat1: UILabel!
    @IBOutlet weak var stat2: UILabel!
    @IBOutlet weak var stat3: UILabel!
    @IBOutlet weak var stat4: UILabel!
    @IBOutlet weak var amount1: UILabel!
    @IBOutlet weak var amount2: UILabel!
    @IBOutlet weak var amount3: UILabel!
    @IBOutlet weak var amount4: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("StatRow", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        stat1.adjustsFontSizeToFitWidth = true
        stat2.adjustsFontSizeToFitWidth = true
        stat3.adjustsFontSizeToFitWidth = true
        stat4.adjustsFontSizeToFitWidth = true
        amount1.adjustsFontSizeToFitWidth = true
        amount2.adjustsFontSizeToFitWidth = true
        amount3.adjustsFontSizeToFitWidth = true
        amount4.adjustsFontSizeToFitWidth = true
    }
}
