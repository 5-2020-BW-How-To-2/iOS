//
//  HowTo+Convenience.swift
//  How To
//
//  Created by Chris Dobek on 5/25/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import CoreData

extension LifeHacks {
    
    var lifeHacksRepresentation: LifeHacksRepresentation? {
        guard let title = title,
            let lifeHackDescription = lifeHackDescription,
            let materials = materials,
            let video = video,
            let instructions = instructions else {return nil }
        
        return LifeHacksRepresentation(title: title,
                                       lifeHackDescription: lifeHackDescription,
                                       materials: materials,
                                       instructions: instructions,
                                       id: id,
                                       userID: userID,
                                       video: video)
    }
    
    @discardableResult convenience init(title: String,
                                        lifeHackDescription: String,
                                        materials: String,
                                        instructions: String,
                                        id: Int32,
                                        userID: Int32,
                                        video: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.lifeHackDescription = lifeHackDescription
        self.materials = materials
        self.id = id
        self.userID = userID
        self.video = video
    }
    
    @discardableResult convenience init?(lifeHacksRepresentation: LifeHacksRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        
        guard let video = lifeHacksRepresentation.video,
            let instructions = lifeHacksRepresentation.instructions,
            let materials = lifeHacksRepresentation.materials,
            let id = lifeHacksRepresentation.id else { return nil }
        
        
        self.init(title: lifeHacksRepresentation.title,
                  lifeHackDescription: lifeHacksRepresentation.lifeHackDescription,
                  materials: materials,
                  instructions: instructions,
                  id: id,
                  userID: lifeHacksRepresentation.userID,
                  video: video)
    }
    
    @discardableResult convenience init(title: String,
                                        lifeHackDescription: String,
                                        materials: String,
                                        instructions: String,
                                        userID: Int32,
                                        video: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.lifeHackDescription = lifeHackDescription
        self.materials = materials
        self.userID = userID
        self.video = video
}
}
