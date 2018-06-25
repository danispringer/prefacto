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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    
    let positiveSound: Int = 1023
    let negativeSound: Int = 1257
    
    
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
        DispatchQueue.main.async {
            self.enableUI(enabled: false)
        }
        
        guard let text = textfield.text else {
            let alert = createAlert(alertReasonParam: alertReason.unknown.rawValue)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return
        }
        
        guard !text.isEmpty else {
            let alert = createAlert(alertReasonParam: alertReason.textfieldEmpty.rawValue)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1257))
            }
            return
        }
        
        guard let number = Int64(text) else {
            let alert = createAlert(alertReasonParam: alertReason.notNumberOrTooBig.rawValue)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1257))
            }
            return
        }
        
        guard number != 0 else {
            let alert = createAlert(alertReasonParam: alertReason.zero.rawValue)
            DispatchQueue.main.async {
                self.textfield.text = ""
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return
        }
        
        guard number != 1 else {
            let alert = createAlert(alertReasonParam: alertReason.one.rawValue)
            DispatchQueue.main.async {
                self.textfield.text = ""
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return
        }
        
        guard number != 2 else {
            let alert = createAlert(alertReasonParam: alertReason.two.rawValue)
            let shareAction = UIAlertAction(title: "Share", style: .default, handler: {
                action in
                self.share(number: number, isPrime: true)
            })
            alert.addAction(shareAction)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1023))
            }
            return
        }
        
        guard !(number < 0) else {
            let alert = createAlert(alertReasonParam: alertReason.negative.rawValue)
            DispatchQueue.main.async {
                self.textfield.text = ""
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1257))
            }
            return
        }
        
        var isPrimeBool = true
        var isDivisibleBy: Int64 = 0

        let range = 2...(number - 1)
        
        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        
        downloadQueue.async {
            for n in range {
                if number % n == 0 {
                    // not prime
                    isDivisibleBy = n
                    let alert = self.createAlert(alertReasonParam: alertReason.notPrime.rawValue, num: number, divisibleBy: n)
                    let shareAction = UIAlertAction(title: "Share", style: .default, handler: {
                        action in
                        self.share(number: number, isPrime: isPrimeBool, isDivisibleBy: isDivisibleBy)
                    })
                    alert.addAction(shareAction)
                    DispatchQueue.main.async {
                        alert.view.layoutIfNeeded()
                        self.enableUI(enabled: true)
                        self.present(alert, animated: true)
                    }
                    isPrimeBool = false
                    break
                }
            }
            
            if isPrimeBool {
                // prime
                let alert = self.createAlert(alertReasonParam: alertReason.prime.rawValue, num: number)
                let shareAction = UIAlertAction(title: "Share", style: .default, handler: {
                    action in
                    self.share(number: number, isPrime: isPrimeBool)
                })
                alert.addAction(shareAction)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.enableUI(enabled: true)
                    self.present(alert, animated: true)
                    AudioServicesPlayAlertSound(SystemSoundID(1023))
                }
            }
        }
    }
    
    func share(number: Int64, isPrime: Bool, isDivisibleBy: Int64 = 0) {
        var message = ""
        
        if isPrime {
            message = "Hey, did you know that '\(number)' is a prime number? I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        } else {
            message = "Hey, did you know that '\(number)' is not prime, because it's divisible by '\(isDivisibleBy)'? I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        }
        
        
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view // for iPads not to crash
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: alertReason.unknown.rawValue)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                    AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
                }
                return
            }
        }
        DispatchQueue.main.async {
            self.present(activityController, animated: true)
        }
        
    }
    
    func enableUI(enabled: Bool) {
        if enabled {
            self.activityIndicator.stopAnimating()
            self.textfield.isEnabled = enabled
            self.view.alpha = 1
        } else {
            self.activityIndicator.startAnimating()
            self.view.endEditing(true)
            //self.resultLabel.text = ""
            self.textfield.isEnabled = false
            self.view.alpha = 0.5
        }
    }
}


