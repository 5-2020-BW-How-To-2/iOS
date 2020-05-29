//
//  EditHowToViewController.swift
//  How To
//
//  Created by Chris Dobek on 5/25/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

class EditHowToViewController: UIViewController {
    // MARK: Properties
    var lifeHacks: LifeHacks?
    var apiController: APIController?
    var wasEdited = false
    // MARK: Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var materialsTextField: UITextField!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var instructionsTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited {
            guard let title = titleTextField.text,
                !title.isEmpty,
                let description = descriptionTextField.text,
                !description.isEmpty,
                let materials = materialsTextField.text,
                !materials.isEmpty,
                let instructions = instructionsTextView.text,
                !instructions.isEmpty,
                let lifeHacks = lifeHacks else {
                    return
            }
            lifeHacks.title = title
            lifeHacks.lifeHackDescription = description
            lifeHacks.materials = materials
            lifeHacks.instructions = instructions
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    // MARK: Editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing { wasEdited = true }
        titleTextField.isUserInteractionEnabled = editing
        descriptionTextField.isUserInteractionEnabled = editing
        materialsTextField.isUserInteractionEnabled = editing
        instructionsTextView.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
    }
    // MARK: Actions
    private func updateViews() {
        if isViewLoaded {
            titleTextField.text = lifeHacks?.title
            titleTextField.isUserInteractionEnabled = isEditing
            descriptionTextField.text = lifeHacks?.lifeHackDescription
            descriptionTextField.isUserInteractionEnabled = isEditing
            materialsTextField.text = lifeHacks?.materials
            materialsTextField.isUserInteractionEnabled = isEditing
            instructionsTextView.text = lifeHacks?.instructions
            instructionsTextView.isUserInteractionEnabled = isEditing
            navigationItem.rightBarButtonItem = editButtonItem
        }
    }
}
