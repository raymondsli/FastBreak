//
//  JBTwitterTimeline.swift
//  JB
//
//  Created by Raymond Li on 8/13/18
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit
import TwitterKit

class JBTwitterTimeline: TWTRTimelineViewController {
    
    var twitterHandle: String = "NBA"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = TWTRAPIClient()
        self.dataSource = TWTRUserTimelineDataSource(screenName: twitterHandle, apiClient: client)
    }
}
