//
//  HistoryViewController.swift
//  Prime Numbers Fun
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

    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "History"
        
        tableview.delegate = self
        
        setupFetchedResultsController()
    }
    
    
    // MARK: Helpers
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Number> = Number.fetchRequest()
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
    
    
    // MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aNumber = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(aNumber.value)"
        let isDivisibleBy = aNumber.isDivisibleBy
        var detailText = aNumber.primeOr
        var color = UIColor.white
        
        switch detailText {
        case NumberType.isPrime.rawValue:
            detailText = "Prime"
            color = UIColor.green
        case NumberType.isNotPrime.rawValue:
            detailText = "Not prime: divisible by \(isDivisibleBy)"
            color = UIColor.red
        case NumberType.none.rawValue:
            detailText = "Is N prime? Who knows?"
            color = UIColor.blue
        default:
            print("default called in tableview!")
            detailText = "Error. Please let the developer know."
        }
        
        cell.detailTextLabel?.text = detailText
        cell.backgroundColor = color
        cell.selectionStyle = .none
        
        return cell
    }
}
