//
//  CheckerViewController.swift
//  Prime Numbers Fun
//
//  Created by Dani Springer on 19/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CheckerViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var textfield: UITextField!
    
    // MARK: Properties
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resignToolbar = UIToolbar()
        
        let checkButton = UIBarButtonItem(title: "Check", style: UIBarButtonItemStyle.plain, target: self, action: #selector(checkButtonPressed))
        let cancelButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelAndHideKeyboard))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        resignToolbar.items = [checkButton, space, cancelButton]
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
            let shareAction = UIAlertAction(title: "Share", style: .default, handler: {
                action in
                self.share(number: number)
            })
            alert.addAction(shareAction)
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
            let shareAction = UIAlertAction(title: "Share", style: .default, handler: {
                action in
                self.share(number: number)
            })
            alert.addAction(shareAction)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1023))
            }
        }
    }
    
    func share(number: Int64) {
        let message = "Hey, did you know that '\(number)' is a prime number? I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        
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
}


