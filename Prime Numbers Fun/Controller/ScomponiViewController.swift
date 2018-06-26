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
        
        shareButton.isHidden = true
        let resignToolbar = UIToolbar()
        
        let factorButton = UIBarButtonItem(title: "Factor", style: UIBarButtonItemStyle.plain, target: self, action: #selector(checkButtonPressed))
        let cancelButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelAndHideKeyboard))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        resignToolbar.items = [factorButton, space, cancelButton]
        resignToolbar.sizeToFit()
        textfield.inputAccessoryView = resignToolbar
    }

    
    // MARK: Helpers
    
    
    fileprivate func resetResults() {
        DispatchQueue.main.async {
            self.shareButton.isHidden = true
            self.resultLabel.text = ""
            self.arrayOfInts = []
        }
    }
    
    
    @objc func cancelAndHideKeyboard() {
        DispatchQueue.main.async {
            self.resetResults()
            self.textfield.resignFirstResponder()
        }
    }
    
    
    @objc func checkButtonPressed() {
        DispatchQueue.main.async {
            //self.resetResults()
            print("will disable UI")
            self.enableUI(enabled: false)
            
        }
        
        
        guard let text = textfield.text else {
            let alert = createAlert(alertReasonParam: alertReason.unknown.rawValue)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                print("will enable UI")
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                
                
            }
            return
        }
        
        guard !text.isEmpty else {
            let alert = createAlert(alertReasonParam: alertReason.textfieldEmpty.rawValue)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                print("will enable UI")
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1257))
            }
            return
        }
        
        guard var number = Int64(text) else {
            let alert = createAlert(alertReasonParam: alertReason.notNumberOrTooBig.rawValue)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                print("will enable UI")
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
                print("will disable UI")
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return
        }

        guard !(number < 0) else {
            let alert = createAlert(alertReasonParam: alertReason.negative.rawValue)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                print("will enable UI")
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1257))
            }
            return
        }
        
        var index = Int64(2)
        
        guard number != 1 else {
            let alert = createAlert(alertReasonParam: alertReason.one.rawValue)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                print("will enable UI")
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return
        }
        
        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        
        downloadQueue.async {
            while index <= number {
                while number % index == 0 {
                    number = number / index
                    self.arrayOfInts.append(index)
                    DispatchQueue.main.async {
                        self.resultLabel.text = "\(self.arrayOfInts)"
                    }
                }
                index += 1
            }
            DispatchQueue.main.async {
                self.resultLabel.text = "\(self.arrayOfInts)"
                self.shareButton.isHidden = false
                print("will enable UI")
                self.enableUI(enabled: true)
            }
        }
    }
    

    @IBAction func shareButtonPressed(_ sender: Any) {
        guard let text = textfield.text else {
            let alert = createAlert(alertReasonParam: alertReason.unknown.rawValue)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1257))
            }
            return
        }
        guard !text.isEmpty else {
            let alert = createAlert(alertReasonParam: alertReason.textfieldEmpty.rawValue)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1257))
                self.resetResults()
                
            }
            return
        }
        guard var num = Int64(text) else {
            let alert = createAlert(alertReasonParam: alertReason.unknown.rawValue)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
                AudioServicesPlayAlertSound(SystemSoundID(1257))
                self.resetResults()
                
            }
            return
        }
        
        guard arrayOfInts.count > 0 else {
            resetResults()
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
                    self.present(alert, animated: true)
                    AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
                }
                return
            }
        }
        present(activityController, animated: true)
    }
    
    func enableUI(enabled: Bool) {
        DispatchQueue.main.async {
            if enabled {
                print("will stop spinning")
                self.activityIndicator.stopAnimating()
                print("did stop spinning")
                self.textfield.isEnabled = true
                self.view.alpha = 1
            } else {
                self.textfield.resignFirstResponder()
                print("will start spinning")
                self.activityIndicator.startAnimating()
                print("did start spinning")
                self.view.endEditing(true)
                self.resultLabel.text = ""
                self.textfield.isEnabled = false
                self.view.alpha = 0.5
            }
        }
    }
}
