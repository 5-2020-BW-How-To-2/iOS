//
//  APIController.swift
//  How To
//
//  Created by Chris Dobek on 5/26/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class APIController {
    static let sharedInstance = APIController()
    private let baseURL = URL(string: "https://clhowto.herokuapp.com/")!
    private lazy var signInURL = baseURL.appendingPathComponent("api/auth/login")
    private lazy var signUpURL = baseURL.appendingPathComponent("api/auth/register")
    static var bearer: Bearer?
    static var lifeHacksRep: [LifeHacksRepresentation]?
    static var myLifeHacksRep: [LifeHacksRepresentation]?
    var userID: Int?
    private lazy var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    private lazy var jsonDecoder = JSONDecoder()
    // User logs in
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            let jsonString = String.init(data: jsonData, encoding: .utf8)
            print(jsonString!)
        } catch {
            print("Error encoding user object \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(error)
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            guard let data = data else {
                completion(NSError())
                return
            }
            let decoder = JSONDecoder()
            do {
                APIController.self.bearer = try decoder.decode(Bearer.self, from: data)
                print(APIController.self.bearer!)
            } catch {
                print("Error decoding bearer token \(error)")
                completion(error)
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    //User signs up
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            let jsonString = String.init(data: jsonData, encoding: .utf8)
            print(jsonString!)
        } catch {
            print("Error encoding user object \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                completion(error)
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 || response.statusCode != 201 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
// Send Life Hacks by user
func sendToServer(lifeHacks: LifeHacks, completion: @escaping ((Error?) -> Void) = { _ in }) {

    let requestURL = baseURL.appendingPathComponent("api/posts")
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
    // Delete Life Hacks by user
    func deleteFromServer(lifeHacks: LifeHacks, completion: @escaping ((Error?) -> Void) = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("api/posts/").appendingPathComponent(String(lifeHacks.userID))
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
    // User Creates a Life Hack
    func createLifeHack(title: String,
                        lifeHackDescription: String,
                        materials: String?,
                        instructions: String?,
                        userID: Int32) {
        guard let materials = materials,
            let instructions = instructions else { return }
        let lifeHacks = LifeHacks(title: title,
                                  lifeHackDescription: lifeHackDescription,
                                  materials: materials,
                                  instructions: instructions,
                                  userID: userID)
        sendToServer(lifeHacks: lifeHacks)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Saving new life hack failed")
        }
        NotificationCenter.default.post(name: NSNotification.Name("LifeHackAdded"), object: self)
    }
    // User updates a life hack
    func updateLifeHacks(lifeHacks: LifeHacks,
                         title: String,
                         lifeHackDescription: String,
                         materials: String?,
                         instructions: String) {
        lifeHacks.title = title
        lifeHacks.lifeHackDescription = lifeHackDescription
        lifeHacks.materials = materials
        lifeHacks.instructions = instructions
        sendToServer(lifeHacks: lifeHacks)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Saving edited life hack failed")
        }
        NotificationCenter.default.post(name: NSNotification.Name("LifeHackChanged"), object: self)
    }
// Delete from Core Data
    func delete(lifeHacks: LifeHacks) {
        CoreDataStack.shared.mainContext.delete(lifeHacks)
        do {
            deleteFromServer(lifeHacks: lifeHacks)
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Delete life hack failed")
        }
    }
    // Fetches all Life Hacks
    func fetchLifeHacksFromServer(completion: @escaping ((Error?) -> Void) = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("api/posts")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, _, error in
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
                let lifeHacksRepresentations = try JSONDecoder().decode([LifeHacksRepresentation].self, from: data)
                let jsonString = String.init(data: data, encoding: .utf8)!
                print(jsonString)
                self.updateLifeHacks(with: lifeHacksRepresentations)
                APIController.self.lifeHacksRep = lifeHacksRepresentations
            } catch {
                NSLog("Error decoding JSON data when fetching life hack: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    //Fetch Life Hacks by user id
    func fetchMyLifeHacksFromServer(completion: @escaping ((Error?) -> Void) = { _ in }) {
        guard let userID = userID else { return }
        let requestURL = baseURL.appendingPathComponent("api/posts/").appendingPathExtension(String(userID))
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, _, error in
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
                let lifeHacksRepresentations = try JSONDecoder().decode([LifeHacksRepresentation].self, from: data)
                let jsonString = String.init(data: data, encoding: .utf8)!
                print(jsonString)
                self.updateLifeHacks(with: lifeHacksRepresentations)
                APIController.self.myLifeHacksRep = lifeHacksRepresentations
            } catch {
                NSLog("Error decoding JSON data when fetching life hack: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    private func updateLifeHacks(with representations: [LifeHacksRepresentation]) {
        let identifiersToFetch = representations.compactMap { $0.identifier }
        let representationsById = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var lifeHacksToCreate = representationsById
        let fetchRequest: NSFetchRequest<LifeHacks> = LifeHacks.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", identifiersToFetch)
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.perform {
            do {
                let existingLifeHacks = try context.fetch(fetchRequest)
                for lifeHack in existingLifeHacks {
                    let representation = representationsById[lifeHack.identifier]
                    self.update(lifeHacks: lifeHack, with: representation!)
                    lifeHacksToCreate.removeValue(forKey: lifeHack.identifier)
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
    }
}
