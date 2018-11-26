//
//  FactorizeViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 19/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit
import AVFoundation
import MessageUI
import StoreKit


class FactorizeViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    
    
    // MARK: Properties
    
    var arrayOfInts = [Int64]()
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfield.delegate = self
        
        let resignToolbar = UIToolbar()
        
        let factorButton = UIBarButtonItem(title: Constants.messages.factor, style: UIBarButtonItem.Style.plain, target: self, action: #selector(checkButtonPressed))
        let cancelButton = UIBarButtonItem(title: Constants.messages.cancel, style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelAndHideKeyboard))
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
            let alert = createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return
        }
        
        guard !text.isEmpty else {
            let alert = createAlert(alertReasonParam: .textfieldEmpty)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return
        }
        
        guard let number = Int64(text) else {
            let alert = createAlert(alertReasonParam: .notNumberOrTooBig)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return
        }
        
        guard number != 0 else {
            let alert = createAlert(alertReasonParam: .zero)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return
        }
        
        guard !(number < 0) else {
            let alert = createAlert(alertReasonParam: .negative)
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
        let storyboard = UIStoryboard(name: Constants.storyboardID.main, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Constants.storyboardID.factorizeResults) as! FactorizeResultsViewController
        controller.number = number
        controller.source = arrayOfInts
        present(controller, animated: false)
    }
    
    
    func isPrimeFactorizeVariant(number: Int64) {
        
        var index = Int64(2)
        var localNumber = number
        let halfLocalNumber = localNumber / 2
        
        while index <= halfLocalNumber {
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
    
    
    @IBAction func aboutPressed(_ sender: Any) {
        
        let version: String? = Bundle.main.infoDictionary![Constants.messages.appVersion] as? String
        let infoAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let version = version {
            infoAlert.message = "\(Constants.messages.version) \(version)"
            infoAlert.title = Constants.messages.appName
        }
        
        infoAlert.modalPresentationStyle = .popover
        
        let cancelAction = UIAlertAction(title: Constants.messages.cancel, style: .cancel) {
            _ in
            self.dismiss(animated: true, completion: {
                SKStoreReviewController.requestReview()
            })
        }
        
        let shareAppAction = UIAlertAction(title: Constants.messages.shareApp, style: .default) {
            _ in
            self.shareApp()
        }
        
        let mailAction = UIAlertAction(title: Constants.messages.sendFeedback, style: .default) {
            _ in
            self.launchEmail()
        }
        
        let reviewAction = UIAlertAction(title: Constants.messages.leaveReview, style: .default) {
            _ in
            self.requestReviewManually()
        }
        
        let tutorialAction = UIAlertAction(title: Constants.messages.tutorial, style: .default) {
            _ in
            let storyboard = UIStoryboard(name: Constants.storyboardID.main, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: Constants.storyboardID.tutorial)
            self.present(controller, animated: true)
        }
        
        let settingsAction = UIAlertAction(title: Constants.messages.settings, style: .default) {
            _ in
            let storyboard = UIStoryboard(name: Constants.storyboardID.main, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: Constants.storyboardID.settings)
            self.present(controller, animated: true)
        }
        
        for action in [tutorialAction, settingsAction, mailAction, reviewAction, shareAppAction, cancelAction] {
            infoAlert.addAction(action)
        }
        
        if let presenter = infoAlert.popoverPresentationController {
            presenter.barButtonItem = aboutButton
        }
        
        present(infoAlert, animated: true)
    }
    
    func shareApp() {
        let message = Constants.messages.shareMessage
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: .unknown)
                self.present(alert, animated: true)
                return
            }
        }
        present(activityController, animated: true)
    }
    
}


extension FactorizeViewController: MFMailComposeViewControllerDelegate {
    
    func launchEmail() {
        
        var emailTitle = Constants.messages.appName
        if let version = Bundle.main.infoDictionary![Constants.messages.appVersion] {
            emailTitle += " \(version)"
        }
        
        let messageBody = Constants.messages.emailSample
        let toRecipents = [Constants.messages.emailAddress]
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
                alert = self.createAlert(alertReasonParam: .messageFailed)
            case MFMailComposeResult.saved:
                alert = self.createAlert(alertReasonParam: .messageSaved)
            case MFMailComposeResult.sent:
                alert = self.createAlert(alertReasonParam: .messageSent)
            default:
                break
            }
            if let _ = alert.title {
                self.present(alert, animated: true)
            }
        })
    }
}

extension FactorizeViewController {
    
    func requestReviewManually() {
        // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
        //       You can find the App Store ID in your app's product URL
        
        guard let writeReviewURL = URL(string: Constants.messages.appReviewLink)
            else {
                fatalError("Expected a valid URL")
        }
        
        UIApplication.shared.open(writeReviewURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        
        
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
