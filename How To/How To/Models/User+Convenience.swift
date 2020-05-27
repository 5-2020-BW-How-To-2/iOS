//
//  User+Convenience.swift
//  How To
//
//  Created by Chris Dobek on 5/27/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation

extension User {
    
    var userRepresentation: UserRepresentation? {
       
        return UserRepresentation(id: Int16(id), username: username, password: password)
    }
    
    @discardableResult convenience init(userRepresentation: UserRepresentation) {
        
        self.init(id: Int16(id),
                  username: username,
                  password: password)
    }
    
    @discardableResult convenience init(id: Int16,
                                        username: String,
                                        password: String) {
        
        self.id = Int16(id)
        self.username = username
        self.password = password
    }
}
