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
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: Properties
    
    var arrayOfInts = [Int64]()
    let positiveSound: Int = 1023
    let negativeSound: Int = 1257
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.isEnabled = false
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
        DispatchQueue.main.async {
            self.textfield.resignFirstResponder()
        }
    }
    
    
    fileprivate func getFactors(number: Int64) {
        
        var index = Int64(2)
        var someNumber = number
        
        //let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        
        while index <= someNumber {
            while someNumber % index == 0 {
                someNumber = someNumber / index
                
                self.arrayOfInts.append(index)
                //self.resultLabel.text = "\(self.arrayOfInts)" // TODO: should probably be in main dispatch
            }
            index += 1
        }
    }
    
    @objc func checkButtonPressed() {
        DispatchQueue.main.async {
            self.enableUI(enabled: false)
            self.resultLabel.text = ""
            self.arrayOfInts = []
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
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return
        }

        guard !(number < 0) else {
            let alert = createAlert(alertReasonParam: alertReason.negative.rawValue)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1257))
            }
            return
        }
        
        guard number != 1 else {
            let alert = createAlert(alertReasonParam: alertReason.one.rawValue)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return
        }
        
        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        
        downloadQueue.async {
            self.getFactors(number: number)
            
            DispatchQueue.main.async {
                self.resultLabel.text = "\(self.arrayOfInts)"
                self.enableUI(enabled: true)
            }
        }
    }
    

    @IBAction func shareButtonPressed(_ sender: Any) {
        guard let text = textfield.text else {
            let alert = createAlert(alertReasonParam: alertReason.unknown.rawValue)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1257))
            }
            return
        }
        guard !text.isEmpty else {
            let alert = createAlert(alertReasonParam: alertReason.textfieldEmpty.rawValue)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1257))
            }
            return
        }
        guard var num = Int64(text) else {
            let alert = createAlert(alertReasonParam: alertReason.unknown.rawValue)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1257))
                
            }
            return
        }
        
        guard arrayOfInts.count > 0 else {
            num = Int64(2121)
            let myList: [Int64] = [3, 7, 101]
            share(number: num, list: myList)
            return
        }
        
        share(number: num, list: arrayOfInts)
    }
    
    
    
    func share(number: Int64, list: [Int64]) {
        var message = ""

        if list.count == 1 {
            message = "Hey, did you know that '\(number)' is a prime number? I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        } else {
            message = "Hey, did you know that the prime factors of '\(number)' are '\(list)'? I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        }
        
        
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view // for iPads not to crash
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: alertReason.unknown.rawValue)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.present(alert, animated: true)
                    AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
                }
                return
            }
        }
        self.present(activityController, animated: true)
    }
    
    func enableUI(enabled: Bool) {
        DispatchQueue.main.async {
            if enabled {
                self.activityIndicator.stopAnimating()
                self.textfield.isEnabled = true
                self.view.alpha = 1
                self.shareButton.isEnabled = enabled
            } else {
                self.textfield.resignFirstResponder()
                self.activityIndicator.startAnimating()
                self.view.endEditing(true)
                self.resultLabel.text = ""
                self.textfield.isEnabled = false
                self.view.alpha = 0.5
                self.shareButton.isEnabled = enabled
            }
        }
    }
}
