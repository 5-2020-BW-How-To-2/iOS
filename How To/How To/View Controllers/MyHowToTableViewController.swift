//
//  MyHowToTableViewController.swift
//  How To
//
//  Created by Chris Dobek on 5/25/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit
import CoreData

class MyHowToTableViewController: UITableViewController {

    var apiController = APIController()
    override func viewDidLoad() {
        super.viewDidLoad()
        apiController.fetchMyLifeHacksFromServer()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiController.myLifeHacksRep?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyHowToCell", for: indexPath)
        cell.textLabel?.text = apiController.myLifeHacksRep?[indexPath.row].title
        cell.detailTextLabel?.text = apiController.myLifeHacksRep?[indexPath.row].lifeHackDescription
        return cell
    }
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let lifeHackFR = apiController.myLifeHacksRep?[indexPath.row] else { return }
            guard let materials = lifeHackFR.materials,
                let instructions = lifeHackFR.instructions,
                let video = lifeHackFR.video else { return }
            let lifeHack =
                LifeHacks(title: lifeHackFR.title,
                                     lifeHackDescription: lifeHackFR.lifeHackDescription,
                                     materials: materials,
                                     instructions: instructions,
                                     userID: lifeHackFR.userID,
                                     video: video)
            apiController.delete(lifeHacks: lifeHack)
            apiController.deleteFromServer(lifeHacks: lifeHack)
            let alert = UIAlertController(title: "Success", message: "Life Hack is deleted", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true)
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "CreateHowToSegue":
            guard let createVC = segue.destination as? CreateHowToViewController else {return}
            createVC.apiController = apiController
        default:
            break
        }
    }

}
