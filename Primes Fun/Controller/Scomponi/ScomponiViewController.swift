//
//  ScomponiViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 19/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ScomponiViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    
    var arrayOfInts = [Int64]()
    let positiveSound: Int = 1023
    let negativeSound: Int = 1257
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfield.delegate = self
        
        let resignToolbar = UIToolbar()
        
        let factorButton = UIBarButtonItem(title: "Factor", style: UIBarButtonItemStyle.plain, target: self, action: #selector(checkButtonPressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelAndHideKeyboard))
        cancelButton.tintColor = UIColor.red
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        resignToolbar.items = [factorButton, space, cancelButton]
        resignToolbar.sizeToFit()
        textfield.inputAccessoryView = resignToolbar
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
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
            }
            return
        }
        
        guard var number = Int64(text) else {
            let alert = createAlert(alertReasonParam: alertReason.notNumberOrTooBig.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
            }
            return
        }
        
        guard number != 0 else {
            let alert = createAlert(alertReasonParam: alertReason.zero.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
            }
            return
        }
        
        guard !(number < 0) else {
            let alert = createAlert(alertReasonParam: alertReason.negative.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
            }
            return
        }
        
        var index = Int64(2)
        
        guard number != 1 else {
            DispatchQueue.main.async {
                self.arrayOfInts = [1]
                self.enableUI(enabled: true)
                self.presentResults(number: number)
            }
            return
        }
        
        let userNumber = number
        
        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        
        downloadQueue.async {
            self.arrayOfInts = []
            
            while index <= number {
                while number % index == 0 {
                    number = number / index
                    self.arrayOfInts.append(index)
                }
                index += 1
            }
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.presentResults(number: userNumber)
            }
        }
    }
    
    func presentResults(number: Int64) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScomponiResultsViewController") as! ScomponiResultsViewController
        controller.number = number
        controller.source = arrayOfInts
        present(controller, animated: true)
    }

    
    func enableUI(enabled: Bool) {
        
        DispatchQueue.main.async {
            if enabled {
                self.activityIndicator.stopAnimating()
                self.textfield.isEnabled = true
                self.view.alpha = 1
            } else {
                self.activityIndicator.startAnimating()
                self.textfield.isEnabled = false
                self.view.alpha = 0.5
            }
        }
    }
    
}
