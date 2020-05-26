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
    
    var userRepresentation: UserRepresentation? {
        guard let username = username,
            let password = password else { return nil }
        
        return UserRepresentation(username: username,
                                  password: password)
    }
    
    @discardableResult convenience init?(userRepresentation: UserRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(username: userRepresentation.username,
                  password: userRepresentation.password,
                  context: context)
    }
    
    convenience init(username: String,
                     password: String,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context:context)
        self.username = username
        self.password = password
    }
}

extension EntryList {
    
    var entryListRepresentation: EntryListRepresentation? {
        guard let entry = entry,
            let title = title,
            let id = id,
            let user = user else {return nil}
        
        return EntryListRepresentation(id: id, title: title, entry: entry, user: user)
    }
    
    @discardableResult convenience init?(entryListRepresentation: EntryListRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        guard let id = entryListRepresentation.id else {return nil}
        
        self.init(entry: entryListRepresentation.entry,
                  title: entryListRepresentation.title,
                  user: entryListRepresentation.user,
                  id: id,
                  context: context)
    }
    
    convenience init(entry: String,
                     title: String,
                     user: String,
                     id: String = UUID().uuidString,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.entry = entry
        self.title = title
        self.user = user
        self.id = id
    }
                     
}
