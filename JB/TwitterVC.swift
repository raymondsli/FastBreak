//
//  TwitterVC.swift
//  FBS
//
//  Created by Raymond Li on 8/19/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class TwitterVC: UIViewController {
    
    var twitterHandle = "NBA"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let childTwitter = self.childViewControllers.last as! JBTwitterTimeline
        childTwitter.twitterHandle = twitterHandle
    }
    
    @IBAction func backPressed(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
}
