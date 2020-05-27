//
//  APIController.swift
//  How To
//
//  Created by Chris Dobek on 5/26/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import UIKit

class APIController{
    
    private let baseURL = URL(string: "http://clhowto.herokuapp.com/")!
    var bearer: String?
    
    // Create a function for Sign In
    func signIn(with user: User, completion: @escaping (String?, Error?) -> Void) {
        
        let signInURL = baseURL.appendingPathComponent("/api/auth/login")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        let signInRep = ["username": "\(user.userRepresentation!.username)",
            "password": "\(user.userRepresentation!.password)"]
        do {
            let jsonData = try jsonEncoder.encode(signInRep)
            request.httpBody = jsonData
        } catch {
            NSLog("Encode error in sign in")
            completion(nil, error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                NSLog("Response: \(response)")
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "Data not found", code: 99, userInfo: nil))
                return
            }
            do {
                let result = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = result.token
                DispatchQueue.main.async {
                    completion(result.token, nil)
                }
                
            } catch {
                NSLog("Error sign in")
            }
        }.resume()
    }
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        let signUpURL = baseURL.appendingPathComponent("/api/register")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        let signUpRep = ["username": "\(user.userRepresentation!.username)",
            "password": "\(user.userRepresentation!.password)"]
        
        do {
            let jsonData = try jsonEncoder.encode(signUpRep)
            request.httpBody = jsonData
        } catch {
            NSLog("Encode error in sign up")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                NSLog("Response: \(response)")
                completion(nil)
                return
            }
            
            completion(nil)
        }.resume()
        
    }
    
}
