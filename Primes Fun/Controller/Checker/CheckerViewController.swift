//
//  CheckerViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 19/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit
import AVFoundation
import MessageUI
import StoreKit


class CheckerViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var aboutButton: UIBarButtonItem!


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let resignToolbar = UIToolbar()

        let checkButton = UIBarButtonItem()
        checkButton.title = Constants.Messages.check
        checkButton.style = .plain
        checkButton.target = self
        checkButton.action = #selector(checkButtonPressed)

        let cancelButton = UIBarButtonItem()
        cancelButton.title = Constants.Messages.cancel
        cancelButton.style = .plain
        cancelButton.target = self
        cancelButton.action = #selector(cancelAndHideKeyboard)
        cancelButton.tintColor = UIColor.red
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

        resignToolbar.items = [cancelButton, space, checkButton]
        resignToolbar.sizeToFit()
        textfield.inputAccessoryView = resignToolbar

        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)


    }


    // MARK: Helpers

    @objc func cancelAndHideKeyboard() {
        textfield.resignFirstResponder()
    }


    @objc func checkButtonPressed() {

        DispatchQueue.main.async {
            self.enableUI(enabled: false)

            guard let text = self.textfield.text, !text.isEmpty else {
                let alert = self.createAlert(alertReasonParam: .textfieldEmpty)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.enableUI(enabled: true)
                    self.present(alert, animated: true)
                    AppData.getSoundEnabledSettings(sound: Sound.negative)
                }
                return
            }

            let trimmedText = text.trimmingCharacters(in: .whitespaces)

            guard let number = Int64(trimmedText) else {
                let alert = self.createAlert(alertReasonParam: .notNumberOrTooBig)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.enableUI(enabled: true)
                    self.present(alert, animated: true)
                    AppData.getSoundEnabledSettings(sound: Sound.negative)
                }
                return
            }

            guard number != 0 else {
                let alert = self.createAlert(alertReasonParam: .zero)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.enableUI(enabled: true)
                    self.present(alert, animated: true)
                }
                return
            }

            guard !(number < 0) else {
                let alert = self.createAlert(alertReasonParam: .negative)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.enableUI(enabled: true)
                    self.present(alert, animated: true)
                    AppData.getSoundEnabledSettings(sound: Sound.negative)
                }
                return
            }

            guard number != 1 else {
                let alert = self.createAlert(alertReasonParam: .one)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.enableUI(enabled: true)
                    self.present(alert, animated: true)
                }
                return
            }

            var isPrimeBool = true
            var isDivisibleBy: Int64 = 0

            guard number != 2 else {

                DispatchQueue.main.async {
                    self.enableUI(enabled: true)
                    AppData.getSoundEnabledSettings(sound: Sound.positive)
                    self.presentResult(number: number, isPrime: isPrimeBool, isDivisibleBy: isDivisibleBy)
                }
                return
            }

            let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)

            downloadQueue.async {
                let results = self.isPrime(number: number)

                isPrimeBool = results.0
                isDivisibleBy = results.1

                if isPrimeBool {
                    AppData.getSoundEnabledSettings(sound: Sound.positive)
                    // prime
                }
                DispatchQueue.main.async {
                    self.presentResult(number: number, isPrime: isPrimeBool, isDivisibleBy: isDivisibleBy)
                }

            }
        }
    }


    func isPrime(number: Int64) -> (Bool, Int64) {

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


    func presentResult(number: Int64, isPrime: Bool, isDivisibleBy: Int64) {
        let storyboard = UIStoryboard(name: Constants.StoryboardID.main, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardID.checkerResults)
            as? CheckerResultsViewController
        controller?.number = number
        controller?.isPrime = isPrime
        controller?.isDivisibleBy = isDivisibleBy

        DispatchQueue.main.async {
            self.enableUI(enabled: true)
            if let toPresent = controller {
                self.present(toPresent, animated: false)
            }

        }

    }


    func enableUI(enabled: Bool) {
        DispatchQueue.main.async {
            self.textfield.isEnabled = enabled
            self.view.alpha = enabled ? 1 : 0.5
            _ = enabled ? self.activityIndicator.stopAnimating() :
                self.activityIndicator.startAnimating()
            self.view.endEditing(!enabled)
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


extension CheckerViewController: MFMailComposeViewControllerDelegate {

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

extension CheckerViewController {

    func requestReviewManually() {
        // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
        //       You can find the App Store ID in your app's product URL

        guard let writeReviewURL = URL(string: Constants.Messages.appReviewLink)
            else {
                fatalError("Expected a valid URL")
        }

        UIApplication.shared.open(writeReviewURL, options:
            convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]),
                                  completionHandler: nil)

    }

}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(
    _ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in
        (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
