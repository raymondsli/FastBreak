//
//  Player.swift
//  GT
//
//  Created by Raymond Li on 8/6/18.
//  Copyright © 2018 Raymond Li. All rights reserved.
//

import UIKit

class Player {

    var firstName: String
    var lastName: String

    var height: String
    var weight: String
    
    var position: String
    var currentTeam: String
    var yearsExperience: String
    var birthDate: String
    var age: String
    var jerseyNumber: String
    var school: String
    var draftYear: String
    var draftRound: String
    var draftNumber: String
    
    public init(firstName: String, lastName: String, height: String, weight: String, position: String, currentTeam: String, yearsExperience: String, birthDate: String, age: String, jerseyNumber: String, school: String, draftYear: String, draftRound: String, draftNumber: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.height = height
        self.weight = weight
        self.position = position
        self.currentTeam = currentTeam
        self.yearsExperience = yearsExperience
        self.birthDate = birthDate
        self.age = age
        self.jerseyNumber = jerseyNumber
        self.school = school
        self.draftYear = draftYear
        self.draftRound = draftRound
        self.draftNumber = draftNumber
    }
    
    public init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.height = ""
        self.weight = ""
        self.position = ""
        self.currentTeam = ""
        self.yearsExperience = ""
        self.birthDate = ""
        self.age = ""
        self.jerseyNumber = ""
        self.school = ""
        self.draftYear = ""
        self.draftRound = ""
        self.draftNumber = ""
    }
    
    public init () {
        self.firstName = ""
        self.lastName = ""
        self.height = ""
        self.weight = ""
        self.position = ""
        self.currentTeam = ""
        self.yearsExperience = ""
        self.birthDate = ""
        self.age = ""
        self.jerseyNumber = ""
        self.school = ""
        self.draftYear = ""
        self.draftRound = ""
        self.draftNumber = ""
    }
    
}
