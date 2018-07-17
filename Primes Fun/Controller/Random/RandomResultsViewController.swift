//
//  RandomResultsViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 17/07/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class RandomResultsViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var randomNumberLabel: UILabel!
    
    
    // MARK: Properties
    
    var number: Int!
    
    let positiveSound: Int = 1023
    let negativeSound: Int = 1257
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let myNumber = number else {
            let alert = self.createAlert(alertReasonParam: alertReason.unknown.rawValue)
            DispatchQueue.main.async {
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return
        }
        
        randomNumberLabel.text = "\(myNumber)"
        
        
    }

    
    
    // MARK: Helpers
    
    @IBAction func share() {
        
        var message = ""
        
        guard let myNumber = number else {
            let alert = self.createAlert(alertReasonParam: alertReason.unknown.rawValue)
            DispatchQueue.main.async {
                AudioServicesPlayAlertSound(SystemSoundID(self.negativeSound))
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return
        }
        
        message = "Hey, did you know that \(myNumber) is a prime number? I just found out, using this app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667 - it's really cool!"
        
        
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
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
