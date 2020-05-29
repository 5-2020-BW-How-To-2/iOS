//
//  HowToDetailsViewController.swift
//  How To
//
//  Created by Chris Dobek on 5/25/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

class HowToDetailsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var materialsLabel: UILabel!
    @IBOutlet weak var videoLinkLabel: UILabel!
    @IBOutlet weak var instructionsTextView: UITextView!
    // MARK: - Properties
    var lifeHacks: LifeHacks? {
           didSet {
               updateViews()
           }
       }
       var apiController: APIController? {
           didSet {
               updateViews()
           }
       }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    func updateViews() {
        if let lifeHacks = lifeHacks, isViewLoaded {
            title = lifeHacks.title
            descriptionLabel.text = "Description: \(lifeHacks.lifeHackDescription ?? " ")"
            materialsLabel.text = "Materials: \(lifeHacks.materials ?? " ")"
            videoLinkLabel.text = "Video Link: \(lifeHacks.video ?? " ")"
            instructionsTextView.text = lifeHacks.instructions ?? " "
        }
    }

}
