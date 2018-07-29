//
//  FactorizeViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 19/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class FactorizeViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myToolbar: UIToolbar!
    
    
    // MARK: Properties
    
    var arrayOfInts = [Int64]()
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfield.delegate = self
        
        let resignToolbar = UIToolbar()
        
        let factorButton = UIBarButtonItem(title: "Factor", style: UIBarButtonItemStyle.plain, target: self, action: #selector(checkButtonPressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelAndHideKeyboard))
        cancelButton.tintColor = UIColor.red
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        resignToolbar.items = [cancelButton, space, factorButton]
        resignToolbar.sizeToFit()
        textfield.inputAccessoryView = resignToolbar
        
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        arrayOfInts = []
    }
    
    
    // MARK: Helpers
    
    @objc func cancelAndHideKeyboard() {
        textfield.resignFirstResponder()
    }
    
    
    @objc func checkButtonPressed() {
        
        DispatchQueue.main.async {
            self.enableUI(enabled: false)
        }
        
        guard let text = textfield.text else {
            let alert = createAlert(alertReasonParam: alertReason.unknown.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return
        }
        
        guard !text.isEmpty else {
            let alert = createAlert(alertReasonParam: alertReason.textfieldEmpty.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return
        }
        
        guard let number = Int64(text) else {
            let alert = createAlert(alertReasonParam: alertReason.notNumberOrTooBig.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return
        }
        
        guard number != 0 else {
            let alert = createAlert(alertReasonParam: alertReason.zero.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return
        }
        
        guard !(number < 0) else {
            let alert = createAlert(alertReasonParam: alertReason.negative.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return
        }
        
        guard number != 1 else {
            DispatchQueue.main.async {
                self.arrayOfInts = [1]
                self.enableUI(enabled: true)
                self.presentResults(number: number)
            }
            return
        }
        
        let savedUserNumber = number
        
        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        
        downloadQueue.async {
            self.arrayOfInts = []
            self.isPrimeFactorizeVariant(number: number)
            
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.presentResults(number: savedUserNumber)
            }
        }
    }
    
    
    func presentResults(number: Int64) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FactorizeResultsViewController") as! FactorizeResultsViewController
        controller.number = number
        controller.source = arrayOfInts
        present(controller, animated: false)
    }
    
    
    func isPrimeFactorizeVariant(number: Int64) {
        
        var index = Int64(2)
        var localNumber = number
        let halfLocalNumber = localNumber / 2
        
        while index <= halfLocalNumber {
//            while localNumber % index == 0 {
//                localNumber = localNumber / index
//                self.arrayOfInts.append(index)
//            }
            var results: (Bool, Int64)
            results = isPrimeOrDivisibleBy(number: localNumber)
            
            if results.0 {
                self.arrayOfInts.append(localNumber)
                break
            } else {
                arrayOfInts.append(results.1)
                localNumber = localNumber / results.1
            }
            index += 1
        }
    }
    
    
    func isPrimeOrDivisibleBy(number: Int64) -> (Bool, Int64) {
        
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

    
    func enableUI(enabled: Bool) {
        
        DispatchQueue.main.async {
            self.textfield.isEnabled = enabled
            self.view.alpha = enabled ? 1 : 0.5
            _ = enabled ? self.activityIndicator.stopAnimating() :
                self.activityIndicator.startAnimating()
        }
    }
    
}
