//
//  CheckerViewController.swift
//  Is It Prime
//
//  Created by Dani Springer on 19/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CheckerViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    // MARK: Properties
    
    enum result: String {
        case prime = "prime"
        case notPrime = "notPrime"
        case invalid = "invalid"
        case error = "error"
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfield.delegate = self
        
        let resignToolbar = UIToolbar()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(checkButtonPressed))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(cancelAndHideKeyboard))
        
        resignToolbar.items = [doneButton, cancelButton]
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
        // check if it's prime
        // if it is, set label to "prime"
        // if not, set label to "notPrime"
        textfield.resignFirstResponder()
        
        var status = true
        let num = Int(textfield.text!)
        let range = 2...(num! - 1)
        for n in range {
            print(n)
            if num! % n == 0 {
                // not prime
                resultLabel.text = result.notPrime.rawValue + " " + "\(String(describing: num)) is divisible by \(n)."
                status = false
                break
            }
        }
        if status {
            resultLabel.text = result.prime.rawValue
        }
    }
    
    
    
}
