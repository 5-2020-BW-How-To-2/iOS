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
    var lifeHacksRep: [LifeHacksRepresentation] = []
    var bearer: String?

    init() {
        fetchLifeHacksFromServer()
    }


    func sendToServer(lifeHacks: LifeHacks, completion: @escaping ((Error?) -> Void) = { _ in }) {
        let userID = lifeHacks.userID ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(userID).appendingPathExtension("json")
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
        guard let userID = lifeHacks.userID else {
            NSLog("ID is nil when trying to delete Life Hack from server")
            completion(NSError())
            return
        }
        let requestURL = baseURL.appendingPathComponent(userID).appendingPathExtension("json")
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

    func createLifeHack(title: String, lifeHackDescription: String, materials: String?, instructions: String?, id: Int16, userID: String, video: String?) {

        let lifeHacks = LifeHacks(title: title, lifeHackDescription: lifeHackDescription, materials: materials ?? " ", instructions: instructions ?? " ", id: Int16(id), userID: userID, video: video ?? " ")
        sendToServer(lifeHacks: lifeHacks)
        do {
            try CoreDataStack.shared.mainContext.save()

        } catch {
            NSLog("Saving new life hack failed")
        }
        NotificationCenter.default.post(name: NSNotification.Name("LifeHackAdded"), object: self)
    }

    func updateLifeHacks(lifeHacks: LifeHacks, title: String, lifeHackDescription: String, materials: String?, instructions: String, video: String?) {
        lifeHacks.title = title
        lifeHacks.lifeHackDescription = lifeHackDescription
        lifeHacks.materials = materials
        lifeHacks.instructions = instructions
        lifeHacks.video = video
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
                self.lifeHacksRep = try (JSONDecoder().decode([LifeHacksRepresentation].self, from: data))
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
        let identifiersToFetch = representations.compactMap { $0.userID }
        let representationsById = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var lifeHacksToCreate = representationsById

        let fetchRequest: NSFetchRequest<LifeHacks> = LifeHacks.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)

        let context = CoreDataStack.shared.container.newBackgroundContext()

        context.perform {
            do {
                let existingLifeHacks = try context.fetch(fetchRequest)

                for lifeHack in existingLifeHacks {
                    guard let userID = lifeHack.userID,
                        let representation = representationsById[userID] else { continue }
                    self.update(lifeHacks: lifeHack, with: representation)
                    lifeHacksToCreate.removeValue(forKey: userID)
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
        lifeHacks.lifeHackDescription = representation.lifeHackDescription
        lifeHacks.materials = representation.materials
        lifeHacks.instructions = representation.instructions
        lifeHacks.video = representation.video
    }
}
