//
//  PlayerCell.swift
//  GT
//
//  Created by Raymond Li on 8/6/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class PlayerCell: UITableViewCell {
    

    @IBOutlet weak var imageHeadshot: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var firstName: String = ""
    var lastName: String = ""
    
    func setValues(firstName: String, lastName: String, image: UIImage) {
        name.text = firstName + " " + lastName
        imageHeadshot.image = image
    }
    func configureCell(_ firstName: String, lastName: String) {
        name.text = firstName + " " + lastName
        
        let urlImage = "https://nba-players.herokuapp.com/players/" + lastName + "/" + firstName
        
        setImage(imageUrl: urlImage)
        
    }
    
    func setImage(imageUrl: String) {
        let url = URL(string: imageUrl)
        let data = try? Data(contentsOf: url!)
        if data != nil {
            imageHeadshot.image = UIImage(data: data!)
        } else {
            imageHeadshot.image = UIImage(named: "Basketball")
        }
        imageHeadshot.contentMode = .scaleAspectFit
        
//        let url = URL(string: imageUrl)
//
//        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
//            if data != nil {
//                do {
//                    let image = UIImage(data: data!)
//                    if (image != nil) {
//                        self.imageHeadshot.image = image
//                        self.imageHeadshot.contentMode = .scaleAspectFit
////                        DispatchQueue.main.async(execute: {
////                            self.imageHeadshot.image = image
////                            self.imageHeadshot.contentMode = .scaleAspectFit
////                        })
//                    } else {
//                        DispatchQueue.main.async(execute: {
//                            self.imageHeadshot.image = UIImage(named: "Basketball")
//                            self.imageHeadshot.contentMode = .scaleAspectFit
//                        })
//                    }
//                }
//            }
//        }).resume()
    }
}
