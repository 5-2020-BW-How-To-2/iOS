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
    var fetchedResultsController: NSFetchedResultsController<LifeHacks>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiController.fetchMyLifeHacksFromServer()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        APIController.bearer = APIController.bearer
            apiController.fetchMyLifeHacksFromServer() { error in
                guard error == nil else { return }
                DispatchQueue.main.async {
                    
                    self.fetchedResultsController = {
                        let fetchRequest: NSFetchRequest<LifeHacks> = LifeHacks.fetchRequest()
                        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                        fetchRequest.predicate = NSPredicate(format:"user == %@", APIController.bearer! as! CVarArg)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyHowToCell", for: indexPath)
        cell.textLabel?.text = fetchedResultsController?.fetchedObjects?[indexPath.row].title
        cell.detailTextLabel?.text = fetchedResultsController?.fetchedObjects?[indexPath.row].lifeHackDescription
        return cell
    }
   

   

  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let lifeHackFR = fetchedResultsController?.fetchedObjects?[indexPath.row]
            
            apiController.delete(lifeHacks: lifeHackFR!)
            apiController.deleteFromServer(lifeHacks: lifeHackFR!)
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
extension MyHowToTableViewController: NSFetchedResultsControllerDelegate {
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


