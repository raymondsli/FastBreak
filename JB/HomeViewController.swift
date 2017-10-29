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
    @IBOutlet weak var drop: DropMenuButton!
    
    var curPlayer: String! = ""
    var nextGameString: String! = "0"
    var nextGameDate: String! = "0"
    var nextGameTime: String! = "0"
    
    var teamToSG: [String: String] = [
        "Bucks": "2097",
        "Bulls": "2093",
        "Cavs": "2094",
        "Celtics": "2088",
        "Clippers": "2109",
        "Grizzlies": "2115",
        "Hawks": "2098",
        "Heat": "2100",
        "Hornets": "2099",
        "Jazz": "2107",
        "Kings": "2112",
        "Knicks": "2090",
        "Lakers": "2110",
        "Magic": "2101",
        "Mavericks": "2113",
        "Nets": "2089",
        "Nuggets": "2103",
        "Pacers": "mate",
        "Pelicans": "2116",
        "Pistons": "2095",
        "Raptors": "2092",
        "Rockets": "2114",
        "Sixers": "2091",
        "Spurs": "2117",
        "Suns": "2111",
        "Timberwolves": "2104",
        "Thunder": "2105",
        "Trail Blazers": "2106",
        "Warriors": "2108",
        "Wizards": "2102"
    ]
    
    var playerDict: [String: [String]] = [
        "Jaylen Brown": ["https://api.seatgeek.com/2/events?performers.id=2088&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=1627759&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1627759", "1", "FCHWPO"],
        "Jabari Bird": ["https://api.seatgeek.com/2/events?performers.id=2088&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=1628444&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1628444", "0", "JabariBird"],
        "Ivan Rabb": ["https://api.seatgeek.com/2/events?performers.id=2115&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=1628397&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1628397", "0", "YoungIvee"],
        "Allen Crabbe": ["https://api.seatgeek.com/2/events?performers.id=2089&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=203459&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=203459", "4", "allencrabbe"],
        "Ryan Anderson": ["https://api.seatgeek.com/2/events?performers.id=2114&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=201583&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=201583", "9", "NBA"],
        "Kevin Durant": ["https://api.seatgeek.com/2/events?performers.id=2108&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=201142&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=201142", "10", "KDTrey5"],
        "Stephen Curry": ["https://api.seatgeek.com/2/events?performers.id=2108&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=201939&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=201939", "8", "StephenCurry30"],
        "Klay Thompson": ["https://api.seatgeek.com/2/events?performers.id=2108&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=202691&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=202691", "6", "KlayThompson"],
        "Draymond Green": ["https://api.seatgeek.com/2/events?performers.id=2108&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=203110&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=203110", "5", "Money23Green"],
        "Jeremy Lin": ["https://api.seatgeek.com/2/events?performers.id=2089&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=202391&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=202391", "7", "JLin7"],
        "Giannis Antetokounmpo": ["https://api.seatgeek.com/2/events?performers.id=2097&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=203507&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=203507", "4", "Giannis_An34"],
        "James Harden": ["https://api.seatgeek.com/2/events?performers.id=2114&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=201935&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=201935", "8", "JHarden13"],
        "Chris Paul": ["https://api.seatgeek.com/2/events?performers.id=2114&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=101108&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=101108", "12", "CP3"],
        "Kawhi Leonard": ["https://api.seatgeek.com/2/events?performers.id=2117&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=202695&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=202695", "6", "kawhileonard"],
        "Russell Westbrook": ["https://api.seatgeek.com/2/events?performers.id=2105&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=201566&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=201566", "9", "russwest44"],
        "Paul George": ["https://api.seatgeek.com/2/events?performers.id=2105&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=202331&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=202331", "7", "Yg_Trece"],
        "Carmelo Anthony": ["https://api.seatgeek.com/2/events?performers.id=2105&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=2546&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=2546", "16", "carmeloanthony"],
        "LeBron James": ["https://api.seatgeek.com/2/events?performers.id=2094&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=2544&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=2544", "14", "KingJames"],
        "Joel Embiid": ["https://api.seatgeek.com/2/events?performers.id=2091&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=203954&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=203954", "2", "JoelEmbiid"],
        "Ben Simmons": ["https://api.seatgeek.com/2/events?performers.id=2091&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=1627732&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1627732", "0", "BenSimmons25"],
        "Markelle Fultz": ["https://api.seatgeek.com/2/events?performers.id=2091&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=1628365&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1628365", "0", "MarkelleF"],
        "Demarcus Cousins": ["https://api.seatgeek.com/2/events?performers.id=2116&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=202326&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=202326", "9", "boogiecousins"],
        "Anthony Davis": ["https://api.seatgeek.com/2/events?performers.id=2116&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=203076&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=203076", "5", "AntDavis23"],
        "Jimmy Butler": ["https://api.seatgeek.com/2/events?performers.id=2104&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=202710&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=202710", "6", "JimmyButler"],
        "Karl-Anthony Towns": ["https://api.seatgeek.com/2/events?performers.id=2104&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=1626157&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1626157", "2", "KarlTowns"],
        "Andrew Wiggins": ["https://api.seatgeek.com/2/events?performers.id=2104&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=203952&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=203952", "3", "22wiggins"],
        "Blake Griffin": ["https://api.seatgeek.com/2/events?performers.id=2109&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=201933&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=201933", "7", "blakegriffin32"],
        "Harrison Barnes": ["https://api.seatgeek.com/2/events?performers.id=2113&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=203084&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=203084", "5", "hbarnes"],
        "John Wall": ["https://api.seatgeek.com/2/events?performers.id=2102&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=202322&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=202322", "7", "JohnWall"],
        "Rudy Gobert": ["https://api.seatgeek.com/2/events?performers.id=2107&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=203497&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=203497", "4", "rudygobert27"],
        "Damian Lillard": ["https://api.seatgeek.com/2/events?performers.id=2106&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=203081&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=203081", "5", "Dame_Lillard"],
        "Kristaps Porzingis": ["https://api.seatgeek.com/2/events?performers.id=2090&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=204001&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=204001", "2", "kporzee"],
        "Hassan Whiteside": ["https://api.seatgeek.com/2/events?performers.id=2100&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=202355&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=202355", "5", "youngwhiteside"],
        "Andre Drummond": ["https://api.seatgeek.com/2/events?performers.id=2095&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=203083&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=203083", "5", "AndreDrummond"],
        "D'Angelo Russell": ["https://api.seatgeek.com/2/events?performers.id=2089&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=1626156&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1626156", "2", "DeangeloRusselI"],
        "De'Aaron Fox": ["https://api.seatgeek.com/2/events?performers.id=2112&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=1628368&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1628368", "0", "swipathefox"],
        "Kyle Lowry": ["https://api.seatgeek.com/2/events?performers.id=2092&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=200768&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=200768", "13", "Klow7"],
        "DeMar DeRozan": ["https://api.seatgeek.com/2/events?performers.id=2092&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=201942&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=201942", "8", "DeMar_DeRozan"],
        "Nikola Jokic": ["https://api.seatgeek.com/2/events?performers.id=2103&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=203999&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=203999", "2", "JokicNikola15"],
        "Gary Harris": ["https://api.seatgeek.com/2/events?performers.id=2103&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=203914&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=203914", "3", "thats_G_"],
        "Malik Monk": ["https://api.seatgeek.com/2/events?performers.id=2099&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=1628370&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1628370", "0", "AhmadMonk"],
        "Kyrie Irving": ["https://api.seatgeek.com/2/events?performers.id=2088&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=202681&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=202681", "6", "KyrieIrving"],
        "Gordon Hayward": ["https://api.seatgeek.com/2/events?performers.id=2088&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=202330&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=202330", "7", "gordonhayward"],
        "Jayson Tatum": ["https://api.seatgeek.com/2/events?performers.id=2088&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=1628369&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1628369", "0", "jaytatum0"],
        "Devin Booker": ["https://api.seatgeek.com/2/events?performers.id=2111&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=1626164&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1626164", "2", "DevinBook"],
        "Josh Jackson": ["https://api.seatgeek.com/2/events?performers.id=2111&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=1628367&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1628367", "0", "j_josh11"],
        "Derrick Rose": ["https://api.seatgeek.com/2/events?performers.id=2094&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=201565&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=201565", "8", "drose"],
        "Dwyane Wade": ["https://api.seatgeek.com/2/events?performers.id=2094&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=2548&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=2548", "14", "DwyaneWade"],
        "Brandon Ingram": ["https://api.seatgeek.com/2/events?performers.id=2110&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=1627742&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1627742", "1", "B_Ingram13"],
        "Lonzo Ball": ["https://api.seatgeek.com/2/events?performers.id=2110&per_page=25&client_id=MTIwNzV8MTM2NTQ1MDQyMg", "http://stats.nba.com/stats/playergamelog?DateFrom=&DateTo=&LeagueID=00&PlayerID=1628366&Season=2017-18&SeasonType=Regular+Season", "http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1628366", "0", "ZO2_"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        if let decoded = userDefaults.object(forKey: "curPlayer") as? Data {
            curPlayer = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! String
        } else {
            curPlayer = "Jaylen Brown"
            encodeCurPlayer(player: curPlayer)
        }
        
        drop.setTitle(curPlayer, for: .normal)
        nextGame.text = " "
        getNextGameJSON(gameLogURL: playerDict[curPlayer]![0])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        drop.initMenu(["Anderson, Ryan", "Antetokounmpo, G", "Anthony, Carmelo", "Ball, Lonzo", "Barnes, Harrison", "Bird, Jabari", "Booker, Devin", "Brown, Jaylen", "Butler, Jimmy", "Cousins, Demarcus", "Crabbe, Allen", "Curry, Stephen", "Davis, Anthony", "DeRozan, DeMar", "Drummond, Andre", "Durant, Kevin", "Embiid, Joel", "Fox, De'Aaron", "Fultz, Markelle", "George, Paul", "Gobert, Rudy", "Green, Draymond", "Griffin, Blake", "Harden, James", "Harris, Gary", "Hayward, Gordon", "Ingram, Brandon", "Irving, Kyrie", "Jackson, Josh", "James, LeBron", "Jokic, Nikola", "Leonard, Kawhi", "Lillard, Damian", "Lin, Jeremy", "Lowry, Kyle", "Monk, Malik", "Paul, Chris", "Porzingis, Kristaps", "Simmons, Ben", "Thompson, Klay", "Towns, Karl", "Rabb, Ivan", "Rose, Derrick", "Russell, D'Angelo", "Tatum, Jayson", "Wade, Dwyane", "Wall, John", "Westbrook, Russell", "Whiteside, Hassan", "Wiggins, Andrew"], actions: [({ () -> (Void) in
            self.curPlayer = "Ryan Anderson"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Giannis Antetokounmpo"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Carmelo Anthony"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Lonzo Ball"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Harrison Barnes"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Jabari Bird"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Devin Booker"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Jaylen Brown"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Jimmy Butler"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Demarcus Cousins"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Allen Crabbe"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Stephen Curry"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Anthony Davis"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "DeMar DeRozan"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Andre Drummond"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Kevin Durant"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Joel Embiid"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "De'Aaron Fox"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Markelle Fultz"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Paul George"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Rudy Gobert"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Draymond Green"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Blake Griffin"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "James Harden"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Gary Harris"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Gordon Hayward"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Brandon Ingram"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Kyrie Irving"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Josh Jackson"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "LeBron James"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Nikola Jokic"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Kawhi Leonard"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Damian Lillard"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Jeremy Lin"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Kyle Lowry"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Malik Monk"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Chris Paul"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Kristaps Porzingis"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Ben Simmons"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Klay Thompson"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Karl-Anthony Towns"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Ivan Rabb"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Derrick Rose"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "D'Angelo Russell"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Jayson Tatum"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Dwyane Wade"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "John Wall"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Russell Westbrook"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Hassan Whiteside"
            self.dropMenuPressed()
        }), ({ () -> (Void) in
            self.curPlayer = "Andrew Wiggins"
            self.dropMenuPressed()
        })
            ])
    }
    
    func dropMenuPressed() {
        encodeCurPlayer(player: curPlayer)
        getNextGameJSON(gameLogURL: playerDict[curPlayer]![0])
        drop.setTitle(curPlayer, for: .normal)
    }
    
    func encodeCurPlayer(player: String) {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: player)
        userDefaults.set(encodedData, forKey: "curPlayer")
        userDefaults.synchronize()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        drop.showItems()
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
        mailComposerVC.setMessageBody("Report any bugs or tweets, or request a player to be added.", isHTML: false)
        
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
    
}


