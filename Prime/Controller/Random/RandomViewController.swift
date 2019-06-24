//
//  RandomViewController.swift
//  Prime
//
//  Created by Daniel Springer on 17/07/2018.
//  Copyright © 2019 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit
import Intents


class RandomViewController: UIViewController, SKStoreProductViewControllerDelegate {


    // MARK: Outlets

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var randomizeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var aboutButton: UIBarButtonItem!


    // MARK: Properties

    enum SizeOptions: String {
        case xSmall = "Extra-Small"
        case small = "Small"
        case medium = "Medium"
        case large = "Large"
        case xLarge = "Extra-Large"
    }


    // MARK: Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)

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


    @IBAction func randomizeButtonPressed(_ sender: Any) {
        let activity = NSUserActivity(activityType: Constants.Messages.bundleAndRandom)
        activity.title = "Get random prime"
        activity.isEligibleForSearch = true

        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(Constants.Messages.bundleAndRandom)
        activity.suggestedInvocationPhrase = "Show me a Random Prime"
        view.userActivity = activity
        activity.becomeCurrent()

        showOptions()
    }


    func makeRandomShortcut() {
        DispatchQueue.main.async {
            self.enableUI(enabled: false)
        }
        var limit = Int64.max / 10 * 9
        limit /= power(coeff: 10, exp: 12)
        var randInt = Int64.random(in: 1...limit)
        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        downloadQueue.async {
            while !self.isPrime(number: randInt) {
                randInt += 1
            }
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.presentResult(number: randInt, size: SizeOptions.medium)
            }
        }
    }


    func makeRandom(size: SizeOptions) {

        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        downloadQueue.async {
            var limit = Int64.max / 10 * 9
            switch size {
            case .xSmall:
                limit /= self.power(coeff: 10, exp: 16)
            case .small:
                limit /= self.power(coeff: 10, exp: 15)
            case .medium:
                limit /= self.power(coeff: 10, exp: 12)
            case .large:
                limit /= self.power(coeff: 10, exp: 7)
            case .xLarge:
                break
            }
            var randInt = Int64.random(in: 1...limit)

            while !self.isPrime(number: randInt) {
                randInt += 1
            }
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.presentResult(number: randInt, size: size)
            }
        }
    }


    func power(coeff: Int64, exp: Int64) -> Int64 {
        var initialValue = coeff
        for _ in 1...exp {
            initialValue *= coeff
        }
        return initialValue
    }


    func showOptions() {
        var userChoice = SizeOptions.xSmall
        let alert = UIAlertController(title: "Choose size",
                                      message: "Choose your random prime's size",
                                      preferredStyle: .actionSheet)
        alert.modalPresentationStyle = .popover
        let cancelAction = UIAlertAction(title: Constants.Messages.done, style: .cancel)
        let xSmallAction = UIAlertAction(title: SizeOptions.xSmall.rawValue, style: .default) { _ in
            userChoice = .xSmall
            DispatchQueue.main.async {
                self.enableUI(enabled: false)
            }
            self.makeRandom(size: userChoice)
        }
        let smallAction = UIAlertAction(title: SizeOptions.small.rawValue, style: .default) { _ in
            userChoice = .small
            DispatchQueue.main.async {
                self.enableUI(enabled: false)
            }
            self.makeRandom(size: userChoice)
        }
        let mediumAction = UIAlertAction(title: SizeOptions.medium.rawValue, style: .default) { _ in
            userChoice = .medium
            DispatchQueue.main.async {
                self.enableUI(enabled: false)
            }
            self.makeRandom(size: userChoice)
        }
        let largeAction = UIAlertAction(title: SizeOptions.large.rawValue, style: .default) { _ in
            userChoice = .large
            DispatchQueue.main.async {
                self.enableUI(enabled: false)
            }
            self.makeRandom(size: userChoice)
        }
        let xLargeAction = UIAlertAction(title: SizeOptions.xLarge.rawValue, style: .default) { _ in
            userChoice = .xLarge
            DispatchQueue.main.async {
                self.enableUI(enabled: false)
            }
            self.makeRandom(size: userChoice)
        }
        for action in [cancelAction, xSmallAction, smallAction, mediumAction, largeAction, xLargeAction] {
            alert.addAction(action)
        }
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            presenter.permittedArrowDirections = []
        }
        present(alert, animated: true)

    }


    func presentResult(number: Int64, size: SizeOptions) {
        let storyboard = UIStoryboard(name: Constants.StoryboardID.main, bundle: nil)
        let controller = storyboard.instantiateViewController(
            withIdentifier: Constants.StoryboardID.randomResults) as? RandomResultsViewController
        controller?.myNumber = number
        controller?.myTitle = "Your Random \(size.rawValue) Prime"
        DispatchQueue.main.async {
            self.enableUI(enabled: true)
            if let toPresent = controller {
                self.present(toPresent, animated: true)
            }
        }
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
            self.randomizeButton?.isHidden = !enabled
            self.randomizeButton?.isEnabled = enabled
            self.titleLabel?.text = enabled ? "Randomize" : "Randomizing..."
            self.view.alpha = enabled ? 1 : 0.5
            _ = enabled ? self.activityIndicator.stopAnimating() :
                self.activityIndicator.startAnimating()
            self.view.endEditing(!enabled)
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


extension RandomViewController: MFMailComposeViewControllerDelegate {


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


extension RandomViewController {


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
