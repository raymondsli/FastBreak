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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = TWTRAPIClient()
        self.dataSource = TWTRUserTimelineDataSource(screenName: "FCHWPO", apiClient: client)
    }
}
