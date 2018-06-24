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
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.zero.rawValue)
            DispatchQueue.main.async {
                self.textfield.text = ""
                self.present(alert, animated: true)
            }
            return
        }
        
        guard number != 1 else {
            print("cannot check 1")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.one.rawValue)
            DispatchQueue.main.async {
                self.textfield.text = ""
                self.present(alert, animated: true)
            }
            return
        }
        
        guard number != 2 else {
            print("cannot check 2")
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

        let range = 2...(number - 1)
        
        for n in range {
            print(n)
            if number % n == 0 {
                // not prime
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
    }
}


