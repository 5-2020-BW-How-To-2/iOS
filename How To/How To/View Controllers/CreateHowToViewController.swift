//
//  CreateHowToViewController.swift
//  How To
//
//  Created by Chris Dobek on 5/25/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

class CreateHowToViewController: UIViewController {
    
    
    //MARK: Properties
    
    var apiController: APIController?
    var userID: String?
    
    //MARK: Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var materialsTextField: UITextField!
    @IBOutlet weak var videoLinkTextField: UITextField!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var instructionsTextView: UITextView!
    
    override func viewDidLoad() {

    }

    @IBAction func cancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text,
            !title.isEmpty,
            let description = descriptionTextField.text,
            !description.isEmpty,
            let materials = materialsTextField.text,
            !materials.isEmpty,
            let video = videoLinkTextField.text,
            !video.isEmpty,
            let instructions = instructionsTextView.text,
            !instructions.isEmpty else { return }
        
        apiController?.createLifeHack(title: title, lifeHackDescription: description, materials: materials, instructions: instructions, id: Int16(id) ?? " ", userID: userID ?? " ", video: video)
    }
    
    
}
