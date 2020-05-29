//
//  User.swift
//  How To
//
//  Created by Chris Dobek on 5/27/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation

struct User: Codable {
    var userID: Int32?
    var username: String = ""
    var password: String = ""
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case username, password
    }
}
