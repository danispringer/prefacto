//
//  ListViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 24/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit
import AVFoundation
import MessageUI
import StoreKit


class ListViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    
    
    // MARK: Properties
    
    var arrayOfInts = [Int64]()
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstTextField.delegate = self
        secondTextField.delegate = self
        
        let resignToolbar = UIToolbar()
        
        let listButton = UIBarButtonItem(title: Constants.messages.list, style: UIBarButtonItem.Style.plain, target: self, action: #selector(checkButtonPressed))
        let cancelButton = UIBarButtonItem(title: Constants.messages.cancel, style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelAndHideKeyboard))
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
            let alert = createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return
        }
        
        guard !firstText.isEmpty, !secondText.isEmpty else {
            let alert = createAlert(alertReasonParam: .textfieldEmpty)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return
        }
        
        guard var firstNumber = Int64(firstText), var secondNumber = Int64(secondText) else {
            let alert = createAlert(alertReasonParam: .notNumberOrTooBig)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return
        }
        
        guard firstNumber != 0, secondNumber != 0 else {
            let alert = createAlert(alertReasonParam: .zero)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return
        }
        
        guard !(firstNumber < 0), !(secondNumber < 0) else {
            let alert = createAlert(alertReasonParam: .negative)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return
        }
        
        guard !(firstNumber == secondNumber) else {
            let alert = createAlert(alertReasonParam: .sameTwice)
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
                
                let storyboard = UIStoryboard(name: Constants.storyboardID.main, bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: Constants.storyboardID.listResults) as! ListResultsViewController
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


extension ListViewController: MFMailComposeViewControllerDelegate {
    
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

extension ListViewController {
    
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
