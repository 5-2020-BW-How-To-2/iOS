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
                                       id: Int16(id),
                                       userID: Int16(userID),
                                       video: video)
    }
    
    @discardableResult convenience init(title: String,
                                        lifeHackDescription: String,
                                        materials: String,
                                        instructions: String,
                                        id: Int16,
                                        userID: Int16,
                                        video: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.lifeHackDescription = lifeHackDescription
        self.materials = materials
        self.id = Int16(id)
        self.userID = Int16(userID)
        self.video = video
    }
    
    @discardableResult convenience init?(lifeHacksRepresentation: LifeHacksRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        
        guard let video = lifeHacksRepresentation.video,
            let instructions = lifeHacksRepresentation.instructions,
            let materials = lifeHacksRepresentation.materials else { return nil }
        
        self.init(title: lifeHacksRepresentation.title,
                  lifeHackDescription: lifeHacksRepresentation.lifeHackDescription,
                  materials: materials,
                  instructions: instructions,
                  id: lifeHacksRepresentation.id,
                  userID: lifeHacksRepresentation.userID,
                  video: video)
    }
}
