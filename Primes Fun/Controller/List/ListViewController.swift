//
//  ListViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 24/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ListViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: Properties
    
    var arrayOfInts = [Int64]()
    
    let positiveSound: Int = 1023
    let negativeSound: Int = 1257
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstTextField.delegate = self
        secondTextField.delegate = self
        
        let resignToolbar = UIToolbar()
        
        let factorButton = UIBarButtonItem(title: "List", style: UIBarButtonItemStyle.plain, target: self, action: #selector(checkButtonPressed))
        let cancelButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelAndHideKeyboard))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        resignToolbar.items = [factorButton, space, cancelButton]
        resignToolbar.sizeToFit()
        firstTextField.inputAccessoryView = resignToolbar
        secondTextField.inputAccessoryView = resignToolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        arrayOfInts = []
    }
    
    
    // MARK: Helpers
    
    @objc func cancelAndHideKeyboard() {
        firstTextField.resignFirstResponder()
        secondTextField.resignFirstResponder()
    }
    
    @objc func checkButtonPressed() {
        DispatchQueue.main.async {
            self.enableUI(enabled: false)
        }
        
        guard let firstText = firstTextField.text, let secondText = secondTextField.text else {
            let alert = createAlert(alertReasonParam: alertReason.unknown.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return
        }
        
        guard !firstText.isEmpty, !secondText.isEmpty else {
            let alert = createAlert(alertReasonParam: alertReason.textfieldEmpty.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
            }
            return
        }
        
        guard var firstNumber = Int64(firstText), var secondNumber = Int64(secondText) else {
            let alert = createAlert(alertReasonParam: alertReason.notNumberOrTooBig.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
            }
            return
        }
        
        guard firstNumber != 0, secondNumber != 0 else {
            let alert = createAlert(alertReasonParam: alertReason.zero.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
            }
            return
        }
        
        guard !(firstNumber < 0), !(secondNumber < 0) else {
            let alert = createAlert(alertReasonParam: alertReason.negative.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
            }
            return
        }
        
        guard !(firstNumber == secondNumber) else {
            let alert = createAlert(alertReasonParam: alertReason.sameTwice.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
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
                }
            }
            
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                // present list results VC with array of ints
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ListResultsViewController") as! ListResultsViewController
                controller.source = self.arrayOfInts
                controller.from = firstNumber
                controller.to = secondNumber
                self.present(controller, animated: true)
            }
        }
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
        DispatchQueue.main.async {
            if enabled {
                self.activityIndicator.stopAnimating()
                self.firstTextField.isEnabled = enabled
                self.secondTextField.isEnabled = enabled
                self.view.alpha = 1
            } else {
                self.activityIndicator.startAnimating()
                self.view.endEditing(true)
                self.firstTextField.isEnabled = false
                self.secondTextField.isEnabled = false
                self.view.alpha = 0.5
            }
        }
    }
    
}
