//
//  AboutViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 08/07/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import AVFoundation

class AboutViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var versionButtonLabel: UILabel!
    @IBOutlet weak var thanksLabel: UILabel!
    
    
    // MARK: Properties
    
    let positiveSound: Int = 1023
    let negativeSound: Int = 1257
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thanksLabel.isHidden = true
        
        if let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] {
            versionButtonLabel.text = "Version \(version)"
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        thanksLabel.alpha = 0.0
        thanksLabel.font = UIFont.systemFont(ofSize: 5.0)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        thanksLabel.alpha = 0.0
        thanksLabel.font = UIFont.systemFont(ofSize: 5.0)
    }
    
    
    // MARK: Helpers
    
    @IBAction func shareButtonPressed() {
        let message = "Check this app out: Primes Fun lets you check if a number is prime, list primes in a range, factorize, and more! https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667"
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view // for iPads not to crash
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: alertReason.unknown.rawValue)
                self.present(alert, animated: true)
                return
            }
        }
        present(activityController, animated: true)
    }
}

extension AboutViewController: MFMailComposeViewControllerDelegate {
    
    @IBAction func launchEmail(sender: AnyObject) {
        
        var emailTitle = "Primes Fun"
        if let version = versionButtonLabel.text {
            emailTitle += " \(version)"
        }
        let messageBody = "Hi. I have a question..."
        let toRecipents = ["***REMOVED***"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.present(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var alert = UIAlertController()
        
        dismiss(animated: true, completion: {
            switch result {
            case MFMailComposeResult.failed:
                alert = self.createAlert(alertReasonParam: alertReason.messageFailed.rawValue)
            case MFMailComposeResult.saved:
                alert = self.createAlert(alertReasonParam: alertReason.messageSaved.rawValue)
            case MFMailComposeResult.sent:
                alert = self.createAlert(alertReasonParam: alertReason.messageSent.rawValue)
            case MFMailComposeResult.cancelled:
                alert = self.createAlert(alertReasonParam: alertReason.messageCanceled.rawValue)
            }
            self.present(alert, animated: true)
        })
    }
}

extension AboutViewController {
    
    @IBAction func requestReviewManually() {
        // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
        //       You can find the App Store ID in your app's product URL
        
        sayThanks { error in
            
            if error != nil {
                print("error is not nil")
            }
            
            guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id1402417667?action=write-review")
                else {
                    fatalError("Expected a valid URL")
            }
            
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        }
        
        
        
    }
    
    func sayThanks(completionHandler: @escaping (_ errorReason: String?) -> Void) {

        AudioServicesPlayAlertSound(SystemSoundID(self.positiveSound))
        UIView.animate(withDuration: 2.0, animations: {
            self.thanksLabel.font = UIFont.systemFont(ofSize: 50.0)
        }, completion: { (finished: Bool) in
            if finished {
                UIView.animate(withDuration: 2.0, animations: {
                    self.thanksLabel.alpha = 0.0
                    self.thanksLabel.isHidden = true
                }, completion: { (finished: Bool) in
                    completionHandler(nil)
                })
            }
        })
        completionHandler("error")
    }
    
}
