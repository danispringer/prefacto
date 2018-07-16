//
//  CheckerViewController.swift
//  Primes Fun
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
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelAndHideKeyboard))
        cancelButton.tintColor = UIColor.red
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        resignToolbar.items = [checkButton, space, cancelButton]
        resignToolbar.sizeToFit()
        textfield.inputAccessoryView = resignToolbar
    }
    
    
    // MARK: Helpers
    
    
    @objc func cancelAndHideKeyboard() {
        textfield.resignFirstResponder()
    }
    
    
    @objc func checkButtonPressed() {
        
        DispatchQueue.main.async {
            self.enableUI(enabled: false)
            
            guard let text = self.textfield.text, !text.isEmpty else {
                let alert = self.createAlert(alertReasonParam: alertReason.textfieldEmpty.rawValue)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.enableUI(enabled: true)
                    self.present(alert, animated: true)
                    AudioServicesPlayAlertSound(SystemSoundID(1257))
                }
                return
            }
            
            guard let number = Int64(text) else {
                let alert = self.createAlert(alertReasonParam: alertReason.notNumberOrTooBig.rawValue)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.enableUI(enabled: true)
                    self.present(alert, animated: true)
                    AudioServicesPlayAlertSound(SystemSoundID(1257))
                }
                return
            }
            
            guard number != 0 else {
                let alert = self.createAlert(alertReasonParam: alertReason.zero.rawValue)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.enableUI(enabled: true)
                    self.present(alert, animated: true)
                }
                return
            }
            
            guard !(number < 0) else {
                let alert = self.createAlert(alertReasonParam: alertReason.negative.rawValue)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.enableUI(enabled: true)
                    self.present(alert, animated: true)
                    AudioServicesPlayAlertSound(SystemSoundID(1257))
                }
                return
            }
            
            guard number != 1 else {
                let alert = self.createAlert(alertReasonParam: alertReason.one.rawValue)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.enableUI(enabled: true)
                    self.present(alert, animated: true)
                }
                return
            }
            
            var isPrimeBool = true
            var isDivisibleBy: Int64 = 0
            
            guard number != 2 else {
                
                DispatchQueue.main.async {
                    self.enableUI(enabled: true)
                    AudioServicesPlayAlertSound(SystemSoundID(1023))
                    self.presentResult(number: number, isPrime: isPrimeBool, isDivisibleBy: isDivisibleBy)
                }
                return
            }
            
            let range = 2...(number - 1)
            
            let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
            
            downloadQueue.async {
                for n in range {
                    if number % n == 0 {
                        // not prime
                        isDivisibleBy = n
                        isPrimeBool = false
                        break
                    }
                }
                
                if isPrimeBool {
                    AudioServicesPlayAlertSound(SystemSoundID(1023))
                    // prime
                }
                DispatchQueue.main.async {
                    self.presentResult(number: number, isPrime: isPrimeBool, isDivisibleBy: isDivisibleBy)
                }
                
            }
        }
    }
        
        
    func presentResult(number: Int64, isPrime: Bool, isDivisibleBy: Int64) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CheckerResultsViewController") as! CheckerResultsViewController
        controller.number = number
        controller.isPrime = isPrime
        controller.isDivisibleBy = isDivisibleBy
        
        DispatchQueue.main.async {
            self.enableUI(enabled: true)
            self.present(controller, animated: true)
        }
        
    }
    
    
    func enableUI(enabled: Bool) {
        DispatchQueue.main.async {
            if enabled {
                self.activityIndicator.stopAnimating()
                self.textfield.isEnabled = enabled
                self.view.alpha = 1
            } else {
                self.activityIndicator.startAnimating()
                self.view.endEditing(true)
                self.textfield.isEnabled = false
                self.view.alpha = 0.5
            }
        }
    }
}
