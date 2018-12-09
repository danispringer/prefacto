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

    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var aboutButton: UIBarButtonItem!


    // MARK: Properties

    var arrayOfInts = [Int64]()


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        myTextField.delegate = self

        let resignToolbar = UIToolbar()

        let factorButton = UIBarButtonItem()
        factorButton.title = Constants.Messages.factor
        factorButton.style = .plain
        factorButton.target = self
        factorButton.action = #selector(checkButtonPressed)

        let cancelButton = UIBarButtonItem()
        cancelButton.title = Constants.Messages.cancel
        cancelButton.style = .plain
        cancelButton.target = self
        cancelButton.action = #selector(cancelAndHideKeyboard)
        cancelButton.tintColor = UIColor.red
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

        resignToolbar.items = [cancelButton, space, factorButton]
        resignToolbar.sizeToFit()
        myTextField.inputAccessoryView = resignToolbar

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
        myTextField.resignFirstResponder()
    }


    @objc func checkButtonPressed() {

        DispatchQueue.main.async {
            self.enableUI(enabled: false)
        }

        guard let number = isNumberOrNil() else {
            return
        }

        guard isNotEdgeCase(number: number) else {
            return
        }

        let savedUserNumber = number

        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)

        downloadQueue.async {
            self.arrayOfInts = []
            self.primeFactors(number: number)

            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.presentResults(number: savedUserNumber)
            }
        }
    }


    func isNumberOrNil() -> Int64? {

        guard let text = myTextField.text else {
            let alert = createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return nil
        }

        guard !text.isEmpty else {
            let alert = createAlert(alertReasonParam: .textfieldEmpty)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return nil
        }

        let trimmedText = text.trimmingCharacters(in: .whitespaces)

        guard let number = Int64(trimmedText) else {
            let alert = createAlert(alertReasonParam: .notNumberOrTooBig)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return nil
        }

        return number
    }


    func isNotEdgeCase(number: Int64) -> Bool {
        guard number != 0 else {
            let alert = createAlert(alertReasonParam: .zero)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return false
        }

        guard !(number < 0) else {
            let alert = createAlert(alertReasonParam: .negative)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Sound.negative)
            }
            return false
        }

        guard number != 1 else {
            DispatchQueue.main.async {
                self.arrayOfInts = [1]
                self.enableUI(enabled: true)
                self.presentResults(number: number)
            }
            return false
        }

        return true
    }


    func presentResults(number: Int64) {
        let storyboard = UIStoryboard(name: Constants.StoryboardID.main, bundle: nil)
        let controller = storyboard.instantiateViewController(
            withIdentifier: Constants.StoryboardID.factorizeResults) as? FactorizeResultsViewController
        controller?.number = number
        controller?.source = arrayOfInts
        if let toPresent = controller {
            present(toPresent, animated: false)
        }

    }


//    func isPrimeFactorizeVariant(number: Int64) {
//
//        var index = Int64(2)
//        var localNumber = number
//        let halfLocalNumber = localNumber / 2
//
//        while index <= halfLocalNumber {
//            var results: (Bool, Int64)
//            results = isPrimeOrDivisibleBy(number: localNumber)
//
//            if results.0 {
//                self.arrayOfInts.append(localNumber)
//                break
//            } else {
//                arrayOfInts.append(results.1)
//                localNumber /= results.1
//            }
//            index += 1
//        }
//    }

    func primeFactors(number: Int64) {
        var localNumber = number

        var divisor: Int64 = 2
        while divisor * divisor <= localNumber {
            while localNumber % divisor == 0 {
                arrayOfInts.append(divisor)
                localNumber /= divisor
            }
            divisor += divisor == 2 ? 1 : 2
        }
        if localNumber > 1 {
            arrayOfInts.append(localNumber)
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

        var divisor: Int64 = 5
        var lever: Int64 = 2

        while divisor * divisor <= number {
            if number % divisor == 0 {
                return (false, divisor)
            }
            divisor += lever
            lever = 6 - lever
        }
        return (true, 0)
    }


    func enableUI(enabled: Bool) {

        DispatchQueue.main.async {
            self.myTextField.isEnabled = enabled
            self.view.alpha = enabled ? 1 : 0.5
            _ = enabled ? self.activityIndicator.stopAnimating() :
                self.activityIndicator.startAnimating()
        }
    }


    @IBAction func aboutPressed(_ sender: Any) {

        let version: String? = Bundle.main.infoDictionary![Constants.Messages.appVersion] as? String
        let infoAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let version = version {
            infoAlert.message = "\(Constants.Messages.version) \(version)"
            infoAlert.title = Constants.Messages.appName
        }

        infoAlert.modalPresentationStyle = .popover

        let cancelAction = UIAlertAction(title: Constants.Messages.cancel, style: .cancel) { _ in
            self.dismiss(animated: true, completion: {
                SKStoreReviewController.requestReview()
            })
        }

        let shareAppAction = UIAlertAction(title: Constants.Messages.shareApp, style: .default) { _ in
            self.shareApp()
        }

        let mailAction = UIAlertAction(title: Constants.Messages.sendFeedback, style: .default) { _ in
            self.launchEmail()
        }

        let reviewAction = UIAlertAction(title: Constants.Messages.leaveReview, style: .default) { _ in
            self.requestReviewManually()
        }

        let tutorialAction = UIAlertAction(title: Constants.Messages.tutorial, style: .default) { _ in
            let storyboard = UIStoryboard(name: Constants.StoryboardID.main, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardID.tutorial)
            self.present(controller, animated: true)
        }

        let settingsAction = UIAlertAction(title: Constants.Messages.settings, style: .default) { _ in
            let storyboard = UIStoryboard(name: Constants.StoryboardID.main, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardID.settings)
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
        let message = Constants.Messages.shareMessage
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

        var emailTitle = Constants.Messages.appName
        if let version = Bundle.main.infoDictionary![Constants.Messages.appVersion] {
            emailTitle += " \(version)"
        }

        let messageBody = Constants.Messages.emailSample
        let toRecipents = [Constants.Messages.emailAddress]
        let mailComposer: MFMailComposeViewController = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(emailTitle)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        mailComposer.setToRecipients(toRecipents)

        self.present(mailComposer, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
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
            if alert.title != nil {
                self.present(alert, animated: true)
            }
        })
    }
}

extension FactorizeViewController {

    func requestReviewManually() {
        // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
        //       You can find the App Store ID in your app's product URL

        guard let writeReviewURL = URL(string: Constants.Messages.appReviewLink)
            else {
                fatalError("Expected a valid URL")
        }

        UIApplication.shared.open(writeReviewURL, options:
            convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)


    }

}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(
    _ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in
        (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
