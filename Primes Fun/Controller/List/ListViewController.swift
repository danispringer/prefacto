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
    @IBOutlet weak var myToolbar: UIToolbar!
    
    
    // MARK: Properties
    
    var arrayOfInts = [Int64]()
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstTextField.delegate = self
        secondTextField.delegate = self
        
        let resignToolbar = UIToolbar()
        
        let listButton = UIBarButtonItem(title: "List", style: UIBarButtonItemStyle.plain, target: self, action: #selector(checkButtonPressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelAndHideKeyboard))
        cancelButton.tintColor = UIColor.red
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        resignToolbar.items = [cancelButton, space, listButton]
        resignToolbar.sizeToFit()
        firstTextField.inputAccessoryView = resignToolbar
        secondTextField.inputAccessoryView = resignToolbar
        
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
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return
        }
        
        guard var firstNumber = Int64(firstText), var secondNumber = Int64(secondText) else {
            let alert = createAlert(alertReasonParam: alertReason.notNumberOrTooBig.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return
        }
        
        guard firstNumber != 0, secondNumber != 0 else {
            let alert = createAlert(alertReasonParam: alertReason.zero.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return
        }
        
        guard !(firstNumber < 0), !(secondNumber < 0) else {
            let alert = createAlert(alertReasonParam: alertReason.negative.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return
        }
        
        guard !(firstNumber == secondNumber) else {
            let alert = createAlert(alertReasonParam: alertReason.sameTwice.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
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
                self.present(controller, animated: false)
            }
        }
    }
    
    
    func isPrime(number: Int64) -> Bool {
        
        guard number != 1 else {
            return true
        }
        
        guard number != 2 else {
            return true
        }
        
        guard number != 3 else {
            return true
        }
        
        guard !(number % 2 == 0) else {
            return false
        }
        
        guard !(number % 3 == 0) else {
            return false
        }
        
        var i: Int64 = 5
        var w: Int64 = 2
        
        while i * i <= number {
            if number % i == 0 {
                return false
            }
            i += w
            w = 6 - w
        }
        return true
    }

    
    
    func enableUI(enabled: Bool) {
        DispatchQueue.main.async {
            self.firstTextField.isEnabled = enabled
            self.secondTextField.isEnabled = enabled
            self.view.alpha = enabled ? 1 : 0.5
            _ = enabled ? self.activityIndicator.stopAnimating() :
                self.activityIndicator.startAnimating()
            self.view.endEditing(!enabled)
        }
    }
    
}

