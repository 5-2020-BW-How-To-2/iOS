//
//  LifeHacksController.swift
//  How To
//
//  Created by Chris Dobek on 5/26/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation

class LifeHacksController{
    
    let baseURL = URL(string: "https://bwhowto.firebaseio.com/")!
    
    var token: String?
    
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
                NSLog("Error Putting student to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteFromServer(lifeHacks: LifeHacks, completion: @escaping ((Error?) -> Void) = { _ in }) {
        guard let id = lifeHacks.id else {
            NSLog("ID is nil when trying to delete student from server")
            completion(NSError())
            return
        }
        let requestURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting student from server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func createLifeHack(title: String, reason: String, numberStep: Int16, instructions: String) {
        
        let lifeHacks = LifeHacks(title: title, reason: reason, numberSteps: numberStep, instructions: instructions)
        sendToServer(lifeHacks: lifeHacks)
        do {
            try CoreDataStack.shared.mainContext.save()
            
        } catch {
            NSLog("Saving new life hack failed")
        }
        NotificationCenter.default.post(name: NSNotification.Name("LifeHackAdded"), object: self)
    }
    
    func updateLifeHack(lifeHacks: LifeHacks, title: String, reason: String, numberStep: Int16, instructions: String) {
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
    
}
