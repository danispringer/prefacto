//
//  ScomponiViewController.swift
//  Prime Numbers Fun
//
//  Created by Dani Springer on 19/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ScomponiViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: Properties
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resignToolbar = UIToolbar()
        
        let factorButton = UIBarButtonItem(title: "Factor", style: UIBarButtonItemStyle.plain, target: self, action: #selector(checkButtonPressed))
        let cancelButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelAndHideKeyboard))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        resignToolbar.items = [factorButton, space, cancelButton]
        resignToolbar.sizeToFit()
        textfield.inputAccessoryView = resignToolbar
    }

    
    // MARK: Helpers
    
    
    @objc func cancelAndHideKeyboard() {
        textfield.text = ""
        textfield.resignFirstResponder()
    }
    
    
    @objc func checkButtonPressed() {
        
        enableUI(enabled: false)
        
        guard let text = textfield.text else {
            print("it's nil")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.unknown.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return
        }
        
        guard !text.isEmpty else {
            print("it's empty")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.textfieldEmpty.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1257))
            }
            return
        }
        
        guard var number = Int64(text) else {
            print("not a number, or too big - 9223372036854775807 is limit")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.notNumberOrTooBig.rawValue)
            DispatchQueue.main.async {
                self.textfield.text = ""
                self.enableUI(enabled: true)
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
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1257))
            }
            return
        }
        
        guard !(number < 0) else {
            print("cannot check negative")
            let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.negative.rawValue)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1257))
            }
            return
        }
        
        var factors = [Int64]()
        var index = Int64(2)
        
        guard number != 1 else {
            resultLabel.text = "1"
            return
        }
        
        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        
        downloadQueue.async {
            while index <= number {
                while number % index == 0 {
                    number = number / index
                    factors.append(index)
                    DispatchQueue.main.async {
                        self.resultLabel.text = "\(factors)"
                    }
                }
                index += 1
            }
            DispatchQueue.main.async {
                self.resultLabel.text = "\(factors)"
                self.enableUI(enabled: true)
            }
        }
        
//        let alert = Alert.shared.createAlert(alertReasonParam: Alert.alertReason.prime.rawValue, num: number)
//        let shareAction = UIAlertAction(title: "Share", style: .default, handler: {
//            action in
//            self.share(number: number)
//        })
//        alert.addAction(shareAction)
//        DispatchQueue.main.async {
//            self.present(alert, animated: true)
//
//        }
    }
    
    
    func share(number: Int64, list: [Int64]) {
        let message = "Hey, did you know that the prime factors of '\(number)' are '\(list)'? I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        
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
    
    func enableUI(enabled: Bool) {
        if enabled {
            self.activityIndicator.stopAnimating()
            self.textfield.isEnabled = true
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.view.endEditing(true)
                self.resultLabel.text = ""
                self.textfield.isEnabled = false
            }
        }
    }
}
