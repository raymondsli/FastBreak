//
//  BaseStatView.swift
//  FBS
//
//  Created by Raymond Li on 8/15/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class BaseStatView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var row1: StatRow!
    @IBOutlet weak var row2: StatRow!
    @IBOutlet weak var row3: StatRow!
    @IBOutlet weak var row4: StatRow!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("BaseStatView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
}
