//
//  HowToRepresentation.swift
//  How To
//
//  Created by Chris Dobek on 5/25/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable {
    var username: String
    var password: String
}

struct LifeHacksRepresentation: Codable {
    var id: String?
    var title: String
    var reason: String
    var numberSteps: Int
    var instructions: String
    var user: String
}
