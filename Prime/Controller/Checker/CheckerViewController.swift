//
//  CheckerViewController.swift
//  Prime
//
//  Created by Daniel Springer on 19/06/2018.
//  Copyright © 2019 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

class CheckerViewController: UIViewController, SKStoreProductViewControllerDelegate {


    // MARK: Outlets

    @IBOutlet weak var myTextField: MyTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!


    // MARK: Properties

    var myResignToolBar: UIToolbar! = nil

    // MARK: Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        myResignToolBar = UIToolbar()

        setTheme()

        let checkButton = UIBarButtonItem()

        checkButton.title = Constants.Messages.check
        checkButton.style = .plain
        checkButton.target = self
        checkButton.action = #selector(checkButtonPressed)
        let doneButton = UIBarButtonItem(title: Constants.Messages.done,
                                           style: .plain,
                                           target: self,
                                           action: #selector(donePressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        myResignToolBar.items = [doneButton, space, checkButton]
        myResignToolBar.sizeToFit()

        for toolbar in [myToolbar, myResignToolBar] {
            toolbar?.setBackgroundImage(UIImage(),
                                             forToolbarPosition: .any,
                                             barMetrics: .default)
            toolbar?.setShadowImage(UIImage(), forToolbarPosition: .any)
        }

        myTextField.inputAccessoryView = myResignToolBar
    }


    // MARK: Helpers

    func setTheme() {

        let darkMode = traitCollection.userInterfaceStyle == .dark

        let firstColor: UIColor = darkMode ? .white : .black
        let secondColor: UIColor = darkMode ? .black : .white

        aboutButton.tintColor = darkMode ? Constants.View.goldColor : Constants.View.blueColor
        titleLabel.textColor = firstColor
        view.backgroundColor = secondColor
        tabBarController?.tabBar.tintColor = darkMode ?
            Constants.View.goldColor : Constants.View.blueColor
        tabBarController?.tabBar.unselectedItemTintColor = darkMode ?
            Constants.View.goldColor : Constants.View.blueColor


        myTextField.backgroundColor = secondColor
        myTextField.textColor = firstColor
        myTextField.tintColor = firstColor
        myTextField.bottomBorder.backgroundColor = firstColor

        activityIndicator.color = firstColor

        myResignToolBar.tintColor = darkMode ? Constants.View.goldColor : Constants.View.blueColor
        myTextField.keyboardAppearance = darkMode ? .dark : .light

        tabBarController?.tabBar.barTintColor = secondColor
        tabBarController?.tabBar.backgroundColor = secondColor
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        setTheme()
    }


    func showApps() {

        let controller = SKStoreProductViewController()
        controller.delegate = self
        controller.loadProduct(
            withParameters: [SKStoreProductParameterITunesItemIdentifier: Constants.Messages.devID],
            completionBlock: nil)
        present(controller, animated: true)
    }


    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        dismiss(animated: true, completion: nil)
    }


    @objc func donePressed() {
        myTextField.resignFirstResponder()
    }


    @objc func checkButtonPressed() {
        DispatchQueue.main.async {
            self.enableUI(enabled: false)
        }
        DispatchQueue.main.async {
            guard let userNumber = self.isNumberOrNil(textfield: self.myTextField) else {
                return
            }
            guard self.isNotEdgeCaseNumber(number: userNumber) else {
                return
            }
            var isPrimeBool = true
            var isDivisibleBy: Int64 = 0
            guard userNumber != 2 else {
                DispatchQueue.main.async {
                    self.enableUI(enabled: true)
                    self.presentResult(number: userNumber, isPrime: isPrimeBool, isDivisibleBy: isDivisibleBy)
                }
                return
            }
            let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
            downloadQueue.async {
                let results = self.isPrime(number: userNumber)
                isPrimeBool = results.0
                isDivisibleBy = results.1
                DispatchQueue.main.async {
                    self.presentResult(number: userNumber, isPrime: isPrimeBool, isDivisibleBy: isDivisibleBy)
                }
            }
        }
    }


    func isNumberOrNil(textfield: UITextField) -> Int64? {
        guard let myTextFieldText = textfield.text else {
            let alert = self.createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return nil
        }
        guard !myTextFieldText.isEmpty else {
            let alert = self.createAlert(alertReasonParam: .textfieldEmpty)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return nil
        }
        let trimmedText = myTextFieldText.trimmingCharacters(in: .whitespaces)
        guard let number = Int64(trimmedText) else {
            let alert = self.createAlert(alertReasonParam: .notNumberOrTooBig)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return nil
        }
        return number
    }


    func isNotEdgeCaseNumber(number: Int64) -> Bool {
        guard number != 0 else {
            let alert = self.createAlert(alertReasonParam: .zero)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return false
        }
        guard !(number < 0) else {
            let alert = self.createAlert(alertReasonParam: .negative)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return false
        }
        guard number != 1 else {
            let alert = self.createAlert(alertReasonParam: .one)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return false
        }
        return true
    }


    func isPrime(number: Int64) -> (Bool, Int64) {
        guard !(1...3).contains(number) else {
            return (true, 0)
        }
        for intruder: Int64 in [2, 3] where number % intruder == 0 {
            return (false, intruder)
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
            self.myTextField.isEnabled = enabled
            self.view.alpha = enabled ? 1 : 0.5
            _ = enabled ? self.activityIndicator.stopAnimating() :
                self.activityIndicator.startAnimating()
            self.view.endEditing(!enabled)
            self.titleLabel.text = enabled ? "Is It Prime?" : "Checking..."
            self.aboutButton.isEnabled = enabled
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
        let cancelAction = UIAlertAction(title: Constants.Messages.done, style: .cancel) { _ in
            self.dismiss(animated: true)
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
        let settingsAction = UIAlertAction(title: Constants.Messages.settings, style: .default) { _ in
            let storyboard = UIStoryboard(name: Constants.StoryboardID.main, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardID.settings)
            self.present(controller, animated: true)
        }
        let showAppsAction = UIAlertAction(title: Constants.Messages.showAppsButtonTitle, style: .default) { _ in
            self.showApps()
        }
        for action in [settingsAction, mailAction, reviewAction,
                       shareAppAction, showAppsAction, cancelAction] {
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


extension CheckerViewController: MFMailComposeViewControllerDelegate {


    // MARK: Helpers

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


    // MARK: Helpers

    func requestReviewManually() {
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
