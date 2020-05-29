//
//  User.swift
//  How To
//
//  Created by Chris Dobek on 5/27/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation

struct User: Codable {
    var identifier: Int16?
    var username: String = ""
    var password: String = ""
}
