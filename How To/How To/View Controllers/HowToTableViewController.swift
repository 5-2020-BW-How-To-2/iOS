//
//  HowToTableViewController.swift
//  How To
//
//  Created by Chris Dobek on 5/25/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit
import CoreData

class HowToTableViewController: UITableViewController {
    var apiController = APIController()

    override func viewDidLoad() {
        super.viewDidLoad()
       apiController.fetchLifeHacksFromServer()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // transition to login view if conditions require
        let bearer = APIController.bearer
        guard bearer != nil else {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
            return
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiController.lifeHacksRep?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HowToCell", for: indexPath)
        cell.textLabel?.text = apiController.lifeHacksRep?[indexPath.row].title
        cell.detailTextLabel?.text = apiController.lifeHacksRep?[indexPath.row].lifeHackDescription
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowLifeHackSegue":
            guard let showLifeHackVC = segue.destination as? HowToDetailsViewController,
                let index = tableView.indexPathForSelectedRow else {return}
            showLifeHackVC.apiController = apiController
            showLifeHackVC.title = apiController.lifeHacksRep?[index.row].title
        case "LoginModalSegue":
            guard let loginVC = segue.destination as? LoginViewController else {return}
            loginVC.apiController = apiController
        default:
            break
        }
    }
}
