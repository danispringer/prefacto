//
//  CheckerViewController.swift
//  Is It Prime
//
//  Created by Dani Springer on 19/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CheckerViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    
    
    // MARK: Properties

    var dataController: DataController!
    var number: Number!
    var fetchedResultsController:NSFetchedResultsController<Number>!
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Number> = Number.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "numbers")
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
        
        textfield.delegate = self
        
        let resignToolbar = UIToolbar()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(checkButtonPressed))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(cancelAndHideKeyboard))
        
        resignToolbar.items = [doneButton, cancelButton]
        resignToolbar.sizeToFit()
        textfield.inputAccessoryView = resignToolbar
    }
    
    
    // MARK: TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    // MARK: Helpers
    
    
    @objc func cancelAndHideKeyboard() {
        textfield.text = ""
        textfield.resignFirstResponder()
    }
    
    
    @objc func checkButtonPressed() {
        // edge cases: 0, 1, text, spaces, too big a number
        
        guard let text = textfield.text else {
            print("it's nil")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.unknown.rawValue)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
            return
        }
        
        guard !text.isEmpty else {
            print("it's empty")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.textfieldEmpty.rawValue)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
            return
        }
        
        guard let number = Int64(text) else {
            print("not a number, or too big - 4294967295")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.notNumberOrTooBig.rawValue)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
            return
        }
        
        guard number != 0 else {
            print("cannot check 0")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.zero.rawValue)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
            return
        }
        
        guard number != 1 else {
            print("cannot check 1")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.one.rawValue)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
            return
        }
        
        // check if it's prime
        // if it is, set label to "prime"
        // if not, set label to "notPrime"
        textfield.resignFirstResponder()
        
        var status = true

        let range = 2...(number - 1)
        
        for n in range {
            print(n)
            if number % n == 0 {
                // not prime
                let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.notPrime.rawValue, num: number, divisibleBy: n)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
                status = false
                break
            }
        }
        if status {
            // prime
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.prime.rawValue, num: number)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        }
        
        let numberToSave = Number(context: dataController.viewContext)
        numberToSave.creationDate = Date()
        numberToSave.value = number
        numberToSave.isPrime = status
        try? dataController.viewContext.save()
        
    }
    
    
    
}
