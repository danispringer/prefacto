//
//  HistoryViewController.swift
//  Is It Prime
//
//  Created by Dani Springer on 20/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    
    @IBOutlet weak var tableview: UITableView!
    
    
    
    // MARK: Properties
    
    var dataController: DataController!
    var number: Number!
    
    var fetchedResultsController:NSFetchedResultsController<Number>!
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Number> = Number.fetchRequest()
//        let predicate = NSPredicate(format: "number == %@", number)
//        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "number")
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        
        setupFetchedResultsController()
    }
    
    
    // MARK: Helpers
    
    
    // MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aNumber = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(aNumber)"
        cell.detailTextLabel?.text = aNumber.isPrime ? "Prime" : "Not prime"
        cell.backgroundColor = aNumber.isPrime ? UIColor.green : UIColor.red
        
        return cell
    }
}
