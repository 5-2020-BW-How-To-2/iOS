//
//  HowTo+Convenience.swift
//  How To
//
//  Created by Chris Dobek on 5/25/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import CoreData

extension User {
    
    convenience init(username: String,
                     password: String,
                     context: NSManagedObjectContext = CoreDataUserStack.shared.mainContext) {
        
        self.init(context:context)
        self.username = username
        self.password = password
    }
}

extension EntryList {
    
    convenience init(entry: String,
                     title: String,
                     user: String,
                     id: UUID,
                     context: NSManagedObjectContext = CoreDataEntryListStack.shared.mainContext) {
        
        self.init(context: context)
        self.entry = entry
        self.title = title
        self.user = user
        self.id = id
    }
                     
}
