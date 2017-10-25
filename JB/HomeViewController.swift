//
//  FirstViewController.swift
//
//  Created by Raymond Li on 10/24/17.
//  Copyright © 2017 Raymond Li. All rights reserved.
//

import UIKit
import MessageUI

class HomeViewController: UIViewController, NSURLConnectionDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var nextGame: UILabel!
    
    var curPlayer: String! = ""
    var nextGameString: String! = "0"
    var nextGameDate: String! = "0"
    var nextGameTime: String! = "0"
    var playerDict: [String: [String]] = [
        "Jaylen Brown": ["https://api.seatgeek.com/2/events?performers.id=2088&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=1627759&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1627759", "1", "FCHWPO"],
        "Jabari Bird": ["https://api.seatgeek.com/2/events?performers.id=2088&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=1628444&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1628444", "0", "JabariBird"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        if let decoded = userDefaults.object(forKey: "curPlayer") as? Data {
            curPlayer = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! String
        } else {
            curPlayer = "Jaylen Brown"
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: curPlayer)
            userDefaults.set(encodedData, forKey: "curPlayer")
            userDefaults.synchronize()
        }
        
        nextGame.text = " "
        getNextGameJSON(gameLogURL: playerDict[curPlayer]![0])
    }
    
    
    //Function that gets JSON data from the URL
    func getNextGameJSON(gameLogURL: String) {
        let url = URL(string: gameLogURL)
        
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                    //eventsList is an array of events
                    let eventsList: NSArray = json["events"] as! NSArray
                    if eventsList.count == 0 {
                        DispatchQueue.main.async(execute: {
                            self.nextGame.text = ""
                        })
                    } else{
                        //nextGameEvent is a dictionary
                        let nextGameEvent = eventsList[0] as! [String: Any]
                    
                        self.nextGameString = nextGameEvent["title"] as! String
                        let unformattedGameDate: String = nextGameEvent["datetime_local"] as! String
                        self.nextGameDate = self.formatGameDate(input: unformattedGameDate)
                        self.nextGameTime = self.formatGameTime(input: unformattedGameDate)
                    
                        DispatchQueue.main.async(execute: {
                            self.nextGame.text = "Next Game\n" + self.nextGameString + "\n" + self.nextGameDate + "\n" + self.nextGameTime
                        })
                    }
                } catch {
                    print("Could not serialize")
                }
            }
        }).resume()
    }
    
    func formatGameDate(input: String) -> String{
        let index1 = input.index(input.startIndex, offsetBy: 4)
        let year: String = input.substring(to: index1)
        
        let index2 = input.index(input.startIndex, offsetBy: 5)
        let index3 = input.index(input.startIndex, offsetBy: 7)
        let range1 = index2..<index3
        let month: String = input.substring(with: range1)
        
        let index4 = input.index(input.startIndex, offsetBy: 8)
        let index5 = input.index(input.startIndex, offsetBy: 10)
        let range2 = index4..<index5
        let date: String = input.substring(with: range2)
        return month + "/" + date + "/" + year
    }
    
    func formatGameTime(input: String) -> String {
        let index1 = input.index(input.startIndex, offsetBy: 14)
        let index2 = input.index(input.startIndex, offsetBy: 16)
        let range1 = index1..<index2
        let minute = input.substring(with: range1)
        
        let index3 = input.index(input.startIndex, offsetBy: 11)
        let index4 = input.index(input.startIndex, offsetBy: 13)
        let range2 = index3..<index4
        let hour1: String = input.substring(with: range2)
        var intHour: Int = Int(hour1)!
        var ampm: String = "AM"
        
        //Convert to PST
        intHour = intHour - 3
        
        if (intHour >= 12) {
            ampm = "PM"
        }
        if (intHour >= 13) {
            intHour = intHour - 12
        }
        let hour: String = String(describing: intHour)
        
        return hour + ":" + minute + " "  + ampm + " PST"
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["raymond.s.li@berkeley.edu"])
        mailComposerVC.setSubject("App Feedback")
        mailComposerVC.setMessageBody("Report any bugs or tweets needing to be removed.", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send email. Please check email configuration and try again.", preferredStyle: .alert)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    @IBAction func reportButton(_ sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if (MFMailComposeViewController.canSendMail()) {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func jabariTest(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        curPlayer = "Jabari Bird"
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: curPlayer)
        userDefaults.set(encodedData, forKey: "curPlayer")
        userDefaults.synchronize()
        self.viewDidLoad()
    }
    
    @IBAction func jaylenTest(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        curPlayer = "Jaylen Brown"
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: curPlayer)
        userDefaults.set(encodedData, forKey: "curPlayer")
        userDefaults.synchronize()
        self.viewDidLoad()
    }
    
}


