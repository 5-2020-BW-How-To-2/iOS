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

struct EntryListRepresentation: Codable {
    var id: String?
    var title: String
    var entry: String
    var user: String
}
