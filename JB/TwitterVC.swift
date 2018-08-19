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
    @IBOutlet weak var twitterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        twitterButton.setTitle("@" + twitterHandle,for: .normal)
        
        let childTwitter = self.childViewControllers.last as! JBTwitterTimeline
        childTwitter.twitterHandle = twitterHandle
    }
    
    @IBAction func twitterPressed(_ sender: Any) {
        let childTwitter = self.childViewControllers.last as! JBTwitterTimeline
        if childTwitter.tableView.numberOfRows(inSection: 0) > 0 {
            childTwitter.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
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
