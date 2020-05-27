//
//  HowToRepresentation.swift
//  How To
//
//  Created by Chris Dobek on 5/25/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation


struct LifeHacksRepresentation: Codable {
    var title: String
    var lifeHackDescription: String
    var materials: String?
    var instructions: String?
    var id: Int16
    var userID: Int16
    var video: String?
}
