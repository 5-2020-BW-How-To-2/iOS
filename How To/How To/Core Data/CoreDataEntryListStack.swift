//
//  CoreDataEntryListStack.swift
//  How To
//
//  Created by Chris Dobek on 5/25/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import CoreData

class CoreDataEntryListStack {
    static let shared = CoreDataEntryListStack()

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EntryList")

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }

}
