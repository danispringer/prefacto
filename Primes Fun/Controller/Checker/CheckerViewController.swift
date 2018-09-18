//
//  CheckerViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 19/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit
import AVFoundation

class CheckerViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myToolbar: UIToolbar!
    
    
    // MARK: Properties
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resignToolbar = UIToolbar()
        
        let checkButton = UIBarButtonItem(title: "Check", style: UIBarButtonItem.Style.plain, target: self, action: #selector(checkButtonPressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelAndHideKeyboard))
        cancelButton.tintColor = UIColor.red
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        resignToolbar.items = [cancelButton, space, checkButton]
        resignToolbar.sizeToFit()
        textfield.inputAccessoryView = resignToolbar
        
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)

        
    }
    
    
    // MARK: Helpers
    
    
    @objc func cancelAndHideKeyboard() {
        textfield.resignFirstResponder()
    }
    
    
    @objc func checkButtonPressed() {
        
        DispatchQueue.main.async {
            self.enableUI(enabled: false)
            
            guard let text = self.textfield.text, !text.isEmpty else {
                let alert = self.createAlert(alertReasonParam: .textfieldEmpty)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.enableUI(enabled: true)
                    self.present(alert, animated: true)
                    AppData.getSoundEnabledSettings(sound: Sound.negative)
                }
                return
            }
            
            // remove spaces
            let trimmedText = text.trimmingCharacters(in: .whitespaces)
            
            guard let number = Int64(trimmedText) else {
                let alert = self.createAlert(alertReasonParam: .notNumberOrTooBig)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.enableUI(enabled: true)
                    self.present(alert, animated: true)
                    AppData.getSoundEnabledSettings(sound: Sound.negative)
                }
                return
            }
            
            guard number != 0 else {
                let alert = self.createAlert(alertReasonParam: .zero)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.enableUI(enabled: true)
                    self.present(alert, animated: true)
                }
                return
            }
            
            guard !(number < 0) else {
                let alert = self.createAlert(alertReasonParam: .negative)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.enableUI(enabled: true)
                    self.present(alert, animated: true)
                    AppData.getSoundEnabledSettings(sound: Sound.negative)
                }
                return
            }
            
            guard number != 1 else {
                let alert = self.createAlert(alertReasonParam: .one)
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
                    AppData.getSoundEnabledSettings(sound: Sound.positive)
                    self.presentResult(number: number, isPrime: isPrimeBool, isDivisibleBy: isDivisibleBy)
                }
                return
            }
            
            let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
            
            downloadQueue.async {
                let results = self.isPrime(number: number)
                
                isPrimeBool = results.0
                isDivisibleBy = results.1
                
                if isPrimeBool {
                    AppData.getSoundEnabledSettings(sound: Sound.positive)
                    // prime
                }
                DispatchQueue.main.async {
                    self.presentResult(number: number, isPrime: isPrimeBool, isDivisibleBy: isDivisibleBy)
                }
                
            }
        }
    }
    
    
    func isPrime(number: Int64) -> (Bool, Int64) {
        
        guard number != 1 else {
            return (true, 0)
        }
        
        guard number != 2 else {
            return (true, 0)
        }
        
        guard number != 3 else {
            return (true, 0)
        }
        
        guard !(number % 2 == 0) else {
            return (false, 2)
        }
        
        guard !(number % 3 == 0) else {
            return (false, 3)
        }
        
        var i: Int64 = 5
        var w: Int64 = 2
        
        while i * i <= number {
            if number % i == 0 {
                return (false, i)
            }
            i += w
            w = 6 - w
        }
        return (true, 0)
    }
        
        
    func presentResult(number: Int64, isPrime: Bool, isDivisibleBy: Int64) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CheckerResultsViewController") as! CheckerResultsViewController
        controller.number = number
        controller.isPrime = isPrime
        controller.isDivisibleBy = isDivisibleBy
        
        DispatchQueue.main.async {
            self.enableUI(enabled: true)
            self.present(controller, animated: false)
        }
        
    }
    
    
    func enableUI(enabled: Bool) {
        DispatchQueue.main.async {
            self.textfield.isEnabled = enabled
            self.view.alpha = enabled ? 1 : 0.5
            _ = enabled ? self.activityIndicator.stopAnimating() :
                self.activityIndicator.startAnimating()
            self.view.endEditing(!enabled)
        }
    }
}
