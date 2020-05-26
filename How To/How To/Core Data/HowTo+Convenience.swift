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
    
    @discardableResult convenience init(username: String,
                                        password: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.username = username
        self.password = password
    }
    
    @discardableResult convenience init?(userRepresentation: UserRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        self.init(username: userRepresentation.username,
                  password: userRepresentation.password,
                  context: context)
    }
}

extension LifeHacks {
    
    var lifeHacksRepresentation: LifeHacksRepresentation? {
        guard let id = id,
            let title = title,
            let reason = reason,
            let instructions = instructions,
            let user = user else { return nil }
        let numberSteps = Int16()
        
        return LifeHacksRepresentation(id: id, title: title, reason: reason, numberSteps: Int(numberSteps), instructions: instructions, user: user)
    }
    
    @discardableResult convenience init(id: String = UUID().uuidString,
                                        title: String,
                                        reason: String,
                                        numberSteps: Int16,
                                        instructions: String,
                                        user: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.reason = reason
        self.numberSteps = Int16(numberSteps)
        self.instructions = instructions
        self.id = id
        self.user = user
    }
    
    @discardableResult convenience init?(lifeHacksRepresentation: LifeHacksRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
      guard let id = lifeHacksRepresentation.id else {return nil}
      self.init(id: id,
                title: lifeHacksRepresentation.title,
                reason: lifeHacksRepresentation.reason,
                numberSteps: Int16(lifeHacksRepresentation.numberSteps),
                instructions: lifeHacksRepresentation.instructions,
                user: lifeHacksRepresentation.user,
                context: context)
    }
}
