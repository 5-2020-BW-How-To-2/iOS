//
//  LifeHacksController.swift
//  How To
//
//  Created by Chris Dobek on 5/26/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import CoreData

class LifeHacksController{
    
    //MARK: - Properties
    
    let baseURL = URL(string: "https://bwhowto.firebaseio.com/")!
    var token: String?
    var lifeHacksRep: [LifeHacksRepresentation] = []
    var searchedLifeHacks: [LifeHacksRepresentation] = []
    
    init() {
        fetchLifeHacksFromServer()
    }
    
    
    func sendToServer(lifeHacks: LifeHacks, completion: @escaping ((Error?) -> Void) = { _ in }) {
        let id = lifeHacks.id ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(lifeHacks.lifeHacksRepresentation)
        } catch {
            NSLog("Error encoding in put method: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error Putting Life Hack to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteFromServer(lifeHacks: LifeHacks, completion: @escaping ((Error?) -> Void) = { _ in }) {
        guard let id = lifeHacks.id else {
            NSLog("ID is nil when trying to delete Life Hack from server")
            completion(NSError())
            return
        }
        let requestURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting Life Hack from server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func createLifeHack(title: String, reason: String, numberStep: Int16, instructions: String, user: String) {
        
        let lifeHacks = LifeHacks(title: title, reason: reason, numberSteps: numberStep, instructions: instructions, user: user)
        sendToServer(lifeHacks: lifeHacks)
        do {
            try CoreDataStack.shared.mainContext.save()
            
        } catch {
            NSLog("Saving new life hack failed")
        }
        NotificationCenter.default.post(name: NSNotification.Name("LifeHackAdded"), object: self)
    }
    
    func updateLifeHacks(lifeHacks: LifeHacks, title: String, reason: String, numberStep: Int16, instructions: String) {
        lifeHacks.title = title
        lifeHacks.reason = reason
        lifeHacks.numberSteps = numberStep
        lifeHacks.instructions = instructions
        sendToServer(lifeHacks: lifeHacks)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Saving edited life hack failed")
        }
        NotificationCenter.default.post(name: NSNotification.Name("LifeHackChanged"), object: self)
    }
    
    func delete(lifeHacks: LifeHacks) {
        CoreDataStack.shared.mainContext.delete(lifeHacks)
        do {
            deleteFromServer(lifeHacks: lifeHacks)
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Delete life hack failed")
        }
    }
    
    func fetchLifeHacksFromServer(completion: @escaping ((Error?) -> Void) = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")

        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                NSLog("Error fetching entries from server: \(error)")
                completion(error)
                return
            }

            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }

            do {
                self.lifeHacksRep = try JSONDecoder().decode([String: LifeHacksRepresentation].self, from: data).map({$0.value})
                self.updateLifeHacks(with: self.lifeHacksRep)
            } catch {
                NSLog("Error decoding JSON data when fetching life hack: \(error)")
                completion(error)
                return
            }

            completion(nil)

        }.resume()
    }
    
    private func updateLifeHacks(with representations: [LifeHacksRepresentation]){
        let identifiersToFetch = representations.compactMap { $0.user }
        let representationsById = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var lifeHacksToCreate = representationsById

        let fetchRequest: NSFetchRequest<LifeHacks> = LifeHacks.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)

        let context = CoreDataStack.shared.container.newBackgroundContext()

        context.perform {
            do {
                let existingLifeHacks = try context.fetch(fetchRequest)

                for lifeHack in existingLifeHacks {
                    guard let id = lifeHack.id,
                        let representation = representationsById[id] else { continue }
                    self.update(lifeHacks: lifeHack, with: representation)
                    lifeHacksToCreate.removeValue(forKey: id)
                }

                for representation in lifeHacksToCreate.values {
                    LifeHacks(lifeHacksRepresentation: representation, context: context)
                }

                try context.save()
            } catch {
                NSLog("Failed to fetch movies \(identifiersToFetch) with errpr: \(error)")
                return
            }
        }
    }

    private func update(lifeHacks: LifeHacks, with representation: LifeHacksRepresentation) {
        lifeHacks.title = representation.title
        lifeHacks.reason = representation.reason
        lifeHacks.numberSteps = Int16(representation.numberSteps)
        lifeHacks.instructions = representation.instructions
    }
}
