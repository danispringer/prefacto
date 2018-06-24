//
//  CheckerViewController.swift
//  Prime Numbers Fun
//
//  Created by Dani Springer on 19/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AVFoundation

class CheckerViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var historyButton: UIBarButtonItem!
    @IBOutlet weak var photosButton: UIBarButtonItem!
    
    // MARK: Properties

    var dataController: DataController!
    var number: Number!
    var fetchedResultsController:NSFetchedResultsController<Number>!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Checker"
        
        textfield.delegate = self
        
        let resignToolbar = UIToolbar()
        
        let doneButton = UIBarButtonItem(title: "Check", style: UIBarButtonItemStyle.plain, target: self, action: #selector(checkButtonPressed))
        let cancelButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelAndHideKeyboard))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        resignToolbar.items = [doneButton, space, cancelButton]
        resignToolbar.sizeToFit()
        textfield.inputAccessoryView = resignToolbar
    }
    
    
    // MARK: TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    // MARK: Helpers
    
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
    
    
    @objc func cancelAndHideKeyboard() {
        textfield.text = ""
        textfield.resignFirstResponder()
    }
    
    
    @objc func checkButtonPressed() {
        
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
                AudioServicesPlayAlertSound(SystemSoundID(1257))
            }
            return
        }
        
        guard let number = Int64(text) else {
            print("not a number, or too big - 9223372036854775807 is limit")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.notNumberOrTooBig.rawValue)
            DispatchQueue.main.async {
                self.textfield.text = ""
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1257))
            }
            return
        }
        
        guard number != 0 else {
            print("cannot check 0")
            let numberToSave = Number(context: dataController.viewContext)
            numberToSave.creationDate = Date()
            numberToSave.value = number
            numberToSave.primeOr = NumberType.none.rawValue
            try? dataController.viewContext.save()
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.zero.rawValue)
            DispatchQueue.main.async {
                self.textfield.text = ""
                self.present(alert, animated: true)
            }
            return
        }
        
        guard number != 1 else {
            print("cannot check 1")
            let numberToSave = Number(context: dataController.viewContext)
            numberToSave.creationDate = Date()
            numberToSave.value = number
            numberToSave.primeOr = NumberType.none.rawValue
            try? dataController.viewContext.save()
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.one.rawValue)
            DispatchQueue.main.async {
                self.textfield.text = ""
                self.present(alert, animated: true)
            }
            return
        }
        
        guard number != 2 else {
            print("cannot check 2")
            let numberToSave = Number(context: dataController.viewContext)
            numberToSave.creationDate = Date()
            numberToSave.value = number
            numberToSave.primeOr = NumberType.isPrime.rawValue
            try? dataController.viewContext.save()
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.two.rawValue)
            DispatchQueue.main.async {
                self.textfield.text = ""
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1023))
            }
            return
        }
        
        guard !(number < 0) else {
            print("cannot check negative")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.negative.rawValue)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1257))
            }
            return
        }
        
        var isPrimeBool = true
        var isDivisibleBy: Int64 = 0

        let range = 2...(number - 1)
        
        for n in range {
            print(n)
            if number % n == 0 {
                // not prime
                isDivisibleBy = n
                let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.notPrime.rawValue, num: number, divisibleBy: n)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
                isPrimeBool = false
                break
            }
        }
        if isPrimeBool {
            // prime
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.prime.rawValue, num: number)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1023))
            }
        }
        
        let numberToSave = Number(context: dataController.viewContext)
        numberToSave.creationDate = Date()
        numberToSave.value = number
        numberToSave.primeOr = isPrimeBool ? NumberType.isPrime.rawValue : NumberType.isNotPrime.rawValue
        numberToSave.isDivisibleBy = isDivisibleBy
        try? dataController.viewContext.save()
        
    }
    
    @IBAction func historyButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        destinationVC.dataController = dataController
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @IBAction func photosButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    
}


