//
//  ListViewController.swift
//  Primes Fun
//
//  Created by Daniel Springer on 24/06/2018.
//  Copyright © 2018 Daniel Springer. All rights reserved.
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
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: Properties

    var arrayOfInts = [Int64]()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        firstTextField.delegate = self
        secondTextField.delegate = self
        let resignToolbar = UIToolbar()
        let listButton = UIBarButtonItem()
        listButton.title = Constants.Messages.list
        listButton.style = .plain
        listButton.target = self
        listButton.action = #selector(checkButtonPressed)
        let cancelButton = UIBarButtonItem()
        cancelButton.title = Constants.Messages.cancel
        cancelButton.style = .plain
        cancelButton.target = self
        cancelButton.action = #selector(cancelAndHideKeyboard)
        cancelButton.tintColor = UIColor.white
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
        let results = isNumberOrNil()
        guard var firstNumber = results?.0, var secondNumber = results?.1 else {
            return
        }
        guard isNotEdgeCase(firstNum: firstNumber, secondNum: secondNumber) else {
            return
        }
        if firstNumber > secondNumber {
            swap(&firstNumber, &secondNumber)
        }
        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        downloadQueue.async {
            for number in firstNumber...secondNumber {
                if self.isPrime(number: number) {
                    self.arrayOfInts.append(number)
                }
            }
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                let storyboard = UIStoryboard(name: Constants.StoryboardID.main, bundle: nil)
                let controller = storyboard.instantiateViewController(
                    withIdentifier: Constants.StoryboardID.listResults) as? ListResultsViewController
                controller?.source = self.arrayOfInts
                controller?.rangeFrom = firstNumber
                controller?.rangeTo = secondNumber
                if let toPresent = controller {
                    self.present(toPresent, animated: false)
                }
            }
        }
    }

    func isNumberOrNil() -> (Int64, Int64)? {
        guard let firstText = firstTextField.text, let secondText = secondTextField.text else {
            let alert = createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return nil
        }
        guard !firstText.isEmpty, !secondText.isEmpty else {
            let alert = createAlert(alertReasonParam: .textfieldEmpty)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Constants.Sound.negative)
            }
            return nil
        }
        let firstTextTrimmed = firstText.trimmingCharacters(in: .whitespaces)
        let secondTextTrimmed = secondText.trimmingCharacters(in: .whitespaces)
        guard let firstNumber = Int64(firstTextTrimmed), let secondNumber = Int64(secondTextTrimmed) else {
            let alert = createAlert(alertReasonParam: .notNumberOrTooBig)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Constants.Sound.negative)
            }
            return nil
        }
        return (firstNumber, secondNumber)
    }

    func isNotEdgeCase(firstNum: Int64, secondNum: Int64) -> Bool {
        guard ([firstNum, secondNum].allSatisfy { $0 != 0 }) else {
            let alert = createAlert(alertReasonParam: .zero)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Constants.Sound.negative)
            }
            return false
        }
        guard ([firstNum, secondNum].allSatisfy { $0 > 0 }) else {
            let alert = createAlert(alertReasonParam: .negative)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Constants.Sound.negative)
            }
            return false
        }
        guard !(firstNum == secondNum) else {
            let alert = createAlert(alertReasonParam: .sameTwice)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Constants.Sound.negative)
            }
            return false
        }
        return true
    }

    func isPrime(number: Int64) -> Bool {
        guard !(1...3).contains(number) else {
            return true
        }
        for intruder: Int64 in [2, 3] where number % intruder == 0 {
            return false
        }
        var divisor: Int64 = 5
        var lever: Int64 = 2
        while divisor * divisor <= number {
            if number % divisor == 0 {
                return false
            }
            divisor += lever
            lever = 6 - lever
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
            self.titleLabel.text = enabled ? "The Prime List" : "Listing..."
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
        activityController.popoverPresentationController?.barButtonItem = aboutButton
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

extension ListViewController {

    func requestReviewManually() {
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
