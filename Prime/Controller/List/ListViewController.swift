//
//  ListViewController.swift
//  Prime
//
//  Created by Daniel Springer on 24/06/2018.
//  Copyright © 2019 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit


class ListViewController: UIViewController, UITextFieldDelegate, SKStoreProductViewControllerDelegate {


    // MARK: Outlets

    @IBOutlet weak var firstTextField: MyTextField!
    @IBOutlet weak var secondTextField: MyTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var aboutButton: UIBarButtonItem!


    // MARK: Properties

    var arrayOfInts = [Int64]()
    var previousButton = UIBarButtonItem()
    var nextButton = UIBarButtonItem()
    var myResignToolbar: UIToolbar! = nil


    // MARK: Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        myResignToolbar = UIToolbar()

        arrayOfInts = []

        firstTextField.delegate = self
        secondTextField.delegate = self

        let listButton = UIBarButtonItem(
            title: Constants.Messages.list,
            style: .plain,
            target: self,
            action: #selector(listButtonPressed))

        let doneButton = UIBarButtonItem(
            title: Constants.Messages.done,
            style: .plain,
            target: self,
            action: #selector(donePressed))

        previousButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.up"),
            style: .plain,
            target: self,
            action: #selector(previousTextField))

        previousButton.accessibilityLabel = "Go up"

        nextButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.down"),
            style: .plain,
            target: self,
            action: #selector(nextTextField))

        nextButton.accessibilityLabel = "Go down"

        let spaceFlexible = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil)

        let spaceFix = UIBarButtonItem(
            barButtonSystemItem: .fixedSpace,
            target: self,
            action: nil)

        myResignToolbar.items = [
            previousButton, spaceFix, nextButton, spaceFlexible, doneButton, listButton
        ]
        myResignToolbar.sizeToFit()

        for toolbar in [myToolbar, myResignToolbar] {
            toolbar?.setBackgroundImage(UIImage(),
                                        forToolbarPosition: .any,
                                        barMetrics: .default)
            toolbar?.setShadowImage(UIImage(), forToolbarPosition: .any)
        }

        for textfield in [firstTextField, secondTextField] {
            textfield?.inputAccessoryView = myResignToolbar
            textfield?.placeholder = Constants.Messages.placeholderText
        }

    }


    // MARK: Helpers

    @objc func previousTextField() {
        firstTextField.becomeFirstResponder()
    }


    @objc func nextTextField() {
        secondTextField.becomeFirstResponder()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        previousButton.isEnabled = !(textField.tag == 0)
        nextButton.isEnabled = (textField.tag == 0)
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
        firstTextField.resignFirstResponder()
        secondTextField.resignFirstResponder()
    }


    // MARK: TextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case firstTextField:
                secondTextField.becomeFirstResponder()
            case secondTextField:
                secondTextField.resignFirstResponder()
                listButtonPressed()
            default:
                fatalError()
        }
        return true
    }


    @objc func listButtonPressed() {

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
                if Int64.IsPrime(number: number).isPrime {
                    self.arrayOfInts.append(number)
                }
            }

            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                let storyboard = UIStoryboard(name: Constants.StoryboardID.main, bundle: nil)
                let controller = storyboard.instantiateViewController(
                    withIdentifier: Constants.StoryboardID.listResults) as? ListResultsViewController
                controller?.source = self.arrayOfInts

                // below line avoids bug that let old results get added to next ones
                // bug seems to have begun only once Int.isPrime extension was implemented
                self.arrayOfInts = []

                controller?.rangeFrom = firstNumber
                controller?.rangeTo = secondNumber
                if let toPresent = controller {
                    self.present(toPresent, animated: true)
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
                if firstText.isEmpty {
                    self.firstTextField.becomeFirstResponder()
                } else {
                    self.secondTextField.becomeFirstResponder()
                }
                self.present(alert, animated: true)
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
                if Int64(firstTextTrimmed) == nil {
                    self.firstTextField.becomeFirstResponder()
                } else {
                    self.secondTextField.becomeFirstResponder()
                }

                self.present(alert, animated: true)
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
                if firstNum == 0 {
                    self.firstTextField.becomeFirstResponder()
                } else {
                    self.secondTextField.becomeFirstResponder()
                }
                self.present(alert, animated: true)
            }
            return false
        }
        guard ([firstNum, secondNum].allSatisfy { $0 > 0 }) else {
            let alert = createAlert(alertReasonParam: .negative)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                if !(firstNum > 0) {
                    self.firstTextField.becomeFirstResponder()
                } else {
                    self.secondTextField.becomeFirstResponder()
                }

                self.present(alert, animated: true)
            }
            return false
        }
        guard !(firstNum == secondNum) else {
            let alert = createAlert(alertReasonParam: .sameTwice)
            let goToCheckAction = UIAlertAction(
            title: "\(Constants.Messages.check)",
            style: .default) { _ in
                self.tabBarController?.selectedIndex = 0
            }
            alert.addAction(goToCheckAction)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return false
        }
        return true
    }


    // MARK: Toggle UI

    func enableUI(enabled: Bool) {
        DispatchQueue.main.async {
            self.firstTextField.isEnabled = enabled
            self.secondTextField.isEnabled = enabled
            self.view.alpha = enabled ? 1 : 0.5
            _ = enabled ? self.activityIndicator.stopAnimating() :
                self.activityIndicator.startAnimating()
            self.view.endEditing(!enabled)
            self.aboutButton.isEnabled = enabled
            self.tabBarController?.tabBar.alpha = enabled ? 1 : 0.5
            for item in (self.tabBarController?.tabBar.items)! {
                item.isEnabled = enabled
            }
        }
    }


    // MARK: About Pressed

    @IBAction func aboutPressed(_ sender: Any) {
        let version: String? = Bundle.main.infoDictionary![Constants.Messages.appVersion] as? String
        let infoAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let version = version {
            infoAlert.message = "\(Constants.Messages.version) \(version)"
            infoAlert.title = Constants.Messages.appName
        }
        infoAlert.modalPresentationStyle = .popover
        let cancelAction = UIAlertAction(title: Constants.Messages.cancel, style: .cancel) { _ in
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


extension ListViewController: MFMailComposeViewControllerDelegate {

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


extension ListViewController {


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
