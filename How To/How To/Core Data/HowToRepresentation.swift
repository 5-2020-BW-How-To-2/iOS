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
    var identifier: Int32?
    var userID: Int32
    enum CodingKeys: String, CodingKey {
        case lifeHackDescription = "description"
        case userID = "user_id"
        case title, materials, identifier
    }
}
