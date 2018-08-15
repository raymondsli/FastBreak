//
//  PlayerRankings.swift
//  FBS
//
//  Created by Raymond Li on 8/12/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class PlayerRankings: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stat1: RankingRow!
    @IBOutlet weak var stat2: RankingRow!
    @IBOutlet weak var stat3: RankingRow!
    @IBOutlet weak var stat4: RankingRow!
    @IBOutlet weak var stat5: RankingRow!
    @IBOutlet weak var stat6: RankingRow!
    @IBOutlet weak var stat7: RankingRow!
    @IBOutlet weak var stat8: RankingRow!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PlayerRankings", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        stat1.backgroundColor = .white
        stat2.backgroundColor = .white
        stat3.backgroundColor = .white
        stat4.backgroundColor = .white
        stat5.backgroundColor = .white
        stat6.backgroundColor = .white
        stat7.backgroundColor = .white
        stat8.backgroundColor = .white
    }
}
