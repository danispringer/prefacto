//
//  FactorizeViewController.swift
//  Prime
//
//  Created by Daniel Springer on 19/06/2018.
//  Copyright © 2019 Daniel Springer. All rights reserved.
//

import UIKit
import AVFoundation
import MessageUI
import StoreKit


class FactorizeViewController: UIViewController, UITextFieldDelegate, SKStoreProductViewControllerDelegate {


    // MARK: Outlets

    @IBOutlet weak var myTextField: MyTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!


    // MARK: Properties

    var arrayOfInts = [Int64]()


    // MARK: Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrayOfInts = []

        let darkMode = UserDefaults.standard.bool(forKey: Constants.UserDef.darkModeEnabled)

        myTextField.delegate = self

        let resignToolbar = UIToolbar()
        let factorButton = UIBarButtonItem(
            title: Constants.Messages.factor,
            style: .plain,
            target: self,
            action: #selector(checkButtonPressed))
        let doneButton = UIBarButtonItem(
            title: Constants.Messages.done,
            style: .plain,
            target: self,
            action: #selector(donePressed))

        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        resignToolbar.items = [doneButton, space, factorButton]
        resignToolbar.sizeToFit()

        resignToolbar.tintColor = darkMode ? Constants.View.goldColor : Constants.View.blueColor

        for toolbar in [myToolbar, resignToolbar] {
            toolbar?.setBackgroundImage(UIImage(),
                                        forToolbarPosition: .any,
                                        barMetrics: .default)
            toolbar?.setShadowImage(UIImage(), forToolbarPosition: .any)
        }

        myTextField.inputAccessoryView = resignToolbar
        myTextField.keyboardAppearance = darkMode ? .dark : .light

        aboutButton.tintColor = darkMode ? Constants.View.goldColor : Constants.View.blueColor
        titleLabel.textColor = darkMode ? .white : .black
        view.backgroundColor = darkMode ? .black : .white
        tabBarController?.tabBar.tintColor = darkMode ?
            Constants.View.goldColor : Constants.View.blueColor
        tabBarController?.tabBar.backgroundColor = darkMode ? .black : .white
        tabBarController?.tabBar.unselectedItemTintColor = darkMode ?
            Constants.View.goldColor : Constants.View.blueColor

        let firstColor: UIColor = darkMode ? .white : .black
        let secondColor: UIColor = darkMode ? .black : .white
        myTextField.backgroundColor = secondColor
        myTextField.textColor = firstColor
        myTextField.tintColor = firstColor
        myTextField.bottomBorder.backgroundColor = firstColor

        activityIndicator.color = darkMode ? .white : .black

    }


    // MARK: Helpers

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
                AppData.getSoundEnabledSettings(sound: Constants.Sound.negative)
            }
            return nil
        }
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        guard let number = Int64(trimmedText) else {
            let alert = createAlert(alertReasonParam: .notNumberOrTooBig)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Constants.Sound.negative)
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
                AppData.getSoundEnabledSettings(sound: Constants.Sound.negative)
            }
            return false
        }
        guard !(number < 0) else {
            let alert = createAlert(alertReasonParam: .negative)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Constants.Sound.negative)
            }
            return false
        }
        guard number != 1 else {
            let alert = self.createAlert(alertReasonParam: .one)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
                AppData.getSoundEnabledSettings(sound: Constants.Sound.negative)
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
            self.titleLabel.text = enabled ? "Factorize" : "Factorizing..."
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


extension FactorizeViewController: MFMailComposeViewControllerDelegate {


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


extension FactorizeViewController {


    // MARK: Helpers

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