//
//  LoginViewController.swift
//  How To
//
//  Created by Chris Dobek on 5/25/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

enum LoginType: String {
    case signIn = "Sign In"
    case signUp = "Sign Up"
}

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Properties
    var loginType: LoginType?
    var lifeHacksController = LifeHacksController()
    var apiController = APIController()

    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        loginType = .signIn
        submitButton.tintColor = .white
        submitButton.layer.cornerRadius = 8.0
        submitButton.setTitle("Sign In", for: .normal)
    }
    
    @IBAction func loginTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            loginType = .signUp
            submitButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            submitButton.setTitle("Sign In", for: .normal)
        }
    }
    

    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
    }

}
