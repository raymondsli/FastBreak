//
//  SlideLeftSegue.swift
//  FBS
//
//  Created by Raymond Li on 8/19/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class SlideLeftSegue: UIStoryboardSegue {
    
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.2,
                       options: .curveEaseInOut,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)},
                       completion: { finished in
                        src.present(dst, animated: false, completion: nil)
                        })
    }
    
}
