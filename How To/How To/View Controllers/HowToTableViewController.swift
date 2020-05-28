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
    var fetchedResultsController: NSFetchedResultsController<LifeHacks>?

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
        
        APIController.bearer = APIController.bearer
        apiController.fetchLifeHacksFromServer() { error in
            guard error == nil else { return }
            DispatchQueue.main.async {
                
                self.fetchedResultsController = {
                    let fetchRequest: NSFetchRequest<LifeHacks> = LifeHacks.fetchRequest()
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                    fetchRequest.predicate = NSPredicate(format:"user == %@", bearer! as! CVarArg)
                    let context = CoreDataStack.shared.mainContext
                    let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                         managedObjectContext: context,
                                                         sectionNameKeyPath: nil,
                                                         cacheName: nil)
                    frc.delegate = self
                    do {
                        try frc.performFetch()
                    } catch {
                        NSLog("Error doing frc fetch")
                    }
                    return frc
                } ()
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HowToCell", for: indexPath)
        cell.textLabel?.text = fetchedResultsController?.fetchedObjects?[indexPath.row].title
     //   cell.detailTextLabel?.text = fetchedResultsController?.fetchedObjects?[indexPath.row].
        return cell
    }

    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "ShowLifeHackSegue":
            guard let showLifeHackVC = segue.destination as? HowToDetailsViewController,
                let index = tableView.indexPathForSelectedRow else {return}
            showLifeHackVC.lifeHacksController = lifeHacksController
            showLifeHackVC.title = fetchedResultsController?.fetchedObjects?[index.row]
            case "LoginModalSegue":
                guard let loginVC = segue.destination as? LoginViewController else {return}
                loginVC.apiController = apiController
            default:
                break
        }
    }
  

}
extension HowToTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

