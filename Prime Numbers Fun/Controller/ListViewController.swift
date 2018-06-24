//
//  ListViewController.swift
//  Prime Numbers Fun
//
//  Created by Dani Springer on 24/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ListViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var shareButton: UIButton!
    // MARK: Properties
    
    var arrayOfInts = [Int64]()
    
    let positiveSound: Int = 1023
    let negativeSound: Int = 1257


    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstTextField.delegate = self
        secondTextField.delegate = self
        
        shareButton.isHidden = true
        let resignToolbar = UIToolbar()
        
        let factorButton = UIBarButtonItem(title: "List", style: UIBarButtonItemStyle.plain, target: self, action: #selector(checkButtonPressed))
        let cancelButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelAndHideKeyboard))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        resignToolbar.items = [factorButton, space, cancelButton]
        resignToolbar.sizeToFit()
        firstTextField.inputAccessoryView = resignToolbar
        secondTextField.inputAccessoryView = resignToolbar
    }
    
    
    // MARK: Helpers
    
    
    fileprivate func resetResults() {
        shareButton.isHidden = true
        arrayOfInts = []
        resultTableView.reloadData()
    }
    
    @objc func cancelAndHideKeyboard() {
        resetResults()
        firstTextField.resignFirstResponder()
        secondTextField.resignFirstResponder()
    }
    
    
    @objc func checkButtonPressed() {
        resetResults()
        enableUI(enabled: false)
        
        guard let firstText = firstTextField.text, let secondText = secondTextField.text else {
            print("it's nil")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.unknown.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return
        }
        
        guard !firstText.isEmpty, !secondText.isEmpty else {
            print("it's empty")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.textfieldEmpty.rawValue)
            DispatchQueue.main.async {
                self.resetResults()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
            }
            return
        }
        
        guard var firstNumber = Int64(firstText), var secondNumber = Int64(secondText) else {
            print("not a number, or too big - 9223372036854775807 is limit")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.notNumberOrTooBig.rawValue)
            DispatchQueue.main.async {
                self.resetResults()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
            }
            return
        }
        
        guard firstNumber != 0, secondNumber != 0 else {
            print("cannot make list from 0")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.zero.rawValue)
            DispatchQueue.main.async {
                self.resetResults()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
            }
            return
        }
        
        guard !(firstNumber < 0), !(secondNumber < 0) else {
            print("cannot make list from negative")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.negative.rawValue)
            DispatchQueue.main.async {
                self.resetResults()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
            }
            return
        }
        
        guard !(firstNumber == secondNumber) else {
            print("cannot make list from same number twice")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.sameTwice.rawValue)
            DispatchQueue.main.async {
                self.resetResults()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
            }
            return
        }
        
        if firstNumber > secondNumber {
            swap(&firstNumber, &secondNumber)
        }

        
        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        
        downloadQueue.async {
            for n in firstNumber...secondNumber {
                if self.isPrime(number: n) {
                    self.arrayOfInts.append(n)
                    DispatchQueue.main.async {
                        self.resultTableView.reloadData()
                        // scroll to last cell
                        let myIndexPath = IndexPath(row: self.resultTableView.numberOfRows(inSection: 0) - 1, section: 0)
                        self.resultTableView.scrollToRow(at: myIndexPath, at: UITableViewScrollPosition.bottom, animated: true)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.resultTableView.reloadData()
                
                guard self.arrayOfInts.count > 0 else {
                    // no primes in range
                    let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.noPrimesInRange.rawValue, firstNum: firstNumber, secondNum: secondNumber)
                    self.resetResults()
                    self.enableUI(enabled: true)
                    self.present(alert, animated: true)
                    AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
                    return
                }
                
                self.shareButton.isHidden = false
                let myIndexPath = IndexPath(row: self.resultTableView.numberOfRows(inSection: 0) - 1, section: 0)
                self.resultTableView.scrollToRow(at: myIndexPath, at: UITableViewScrollPosition.bottom, animated: true)
                self.enableUI(enabled: true)
            }
        }
    }
    
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        guard let firstText = firstTextField.text, let secondtext = secondTextField.text else {
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.unknown.rawValue)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
            }
            return
        }
        guard !firstText.isEmpty, !secondtext.isEmpty else {
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.textfieldEmpty.rawValue)
            DispatchQueue.main.async {
                self.resetResults()
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
            }
            return
        }
        guard let firstNumber = Int64(firstText), let secondNumber = Int64(secondtext) else {
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.unknown.rawValue)
            DispatchQueue.main.async {
                self.resetResults()
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
            }
            return
        }
        
        share(firstNumber: firstNumber, secondNumber: secondNumber, list: arrayOfInts)
    }
    
    
    func share(firstNumber: Int64, secondNumber: Int64, list: [Int64]) {
        var message = ""
        if list.count == 0 {
            message = "Hey, did you know that there are no prime numbers between '\(firstNumber)' and '\(secondNumber)'? I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        }
        if list.count == 1 {
            message = "Hey, did you know that the only prime number between '\(firstNumber)' and '\(secondNumber)' is '\(list[0])'? I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        } else {
            message = "Hey, did you know that the prime numbers between '\(firstNumber)' and '\(secondNumber)' are '\(list)'? That's no less than '\(list.count)' numbers! I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        }
        
        
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view // for iPads not to crash
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if error != nil {
                print("Error: \(String(describing: error))")
                print("Returned items: \(String(describing: returnedItems))")
            }
        }
        present(activityController, animated: true)
    }
    
    
    func isPrime(number: Int64) -> Bool {
        
        guard number != 1, number != 2, number != 3 else {
            return true
        }
        
        var isPrimeBool = true
        let range = 2...(number - 1)
        
        for n in range {
            if number % n == 0 {
                // not prime
                isPrimeBool = false
                break
            }
        }
        return isPrimeBool
    }
    
    
    func enableUI(enabled: Bool) {
        if enabled {
            self.activityIndicator.stopAnimating()
            self.firstTextField.isEnabled = enabled
            self.secondTextField.isEnabled = enabled
            self.view.alpha = 1
            self.resultTableView.isScrollEnabled = true
        } else {
            self.activityIndicator.startAnimating()
            self.view.endEditing(true)
            //self.resultLabel.text = ""
            self.firstTextField.isEnabled = false
            self.secondTextField.isEnabled = false
            self.view.alpha = 0.5
            self.resultTableView.isScrollEnabled = false
        }
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if (textField.text?.isEmpty)! {
//            //shareButton.isHidden = true
//            //resultLabel.text = ""
//            arrayOfInts = []
//        }
//    }
    
    // MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfInts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.text = "\(arrayOfInts[(indexPath as NSIndexPath).row])"
        
        return cell
    }
}
