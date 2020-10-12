//
//  MainMenuTableViewController.swift
//  Prime
//
//  Created by Daniel Springer on 11/18/19.
//  Copyright © 2020 Dani Springer. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

class MainMenuTableViewController: UIViewController,
                                   UITableViewDataSource,
                                   UITableViewDelegate,
                                   SKStoreProductViewControllerDelegate {


    // MARK: Outlets

    @IBOutlet var myTableView: UITableView!
    @IBOutlet weak var aboutButton: UIBarButtonItem!


    // MARK: Properties

    let myDataSource = ["Check", "Factorize", "List", "Randomize", "Next", "Previous"]
    let myImageSource = ["checkmark", "divide", "list.dash", "shuffle", "plus", "minus"]

    let menuCell = "MenuCell"


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if let selectedRow = myTableView.indexPathForSelectedRow {
            myTableView.deselectRow(at: selectedRow, animated: true)
        }

        myTableView.rowHeight = UITableView.automaticDimension

    }


    // MARK: Helpers

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


    func showApps() {

        let controller = SKStoreProductViewController()
        controller.delegate = self
        controller.loadProduct(
            withParameters: [SKStoreProductParameterITunesItemIdentifier: Constants.Messages.devID],
            completionBlock: nil)
        present(controller, animated: true)
    }


    // MARK: TableView Delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataSource.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: menuCell) as? MainMenuTableViewCell

        cell?.myLabel.text = myDataSource[(indexPath as NSIndexPath).row]
        cell?.myImage.image = UIImage(systemName: myImageSource[(indexPath as NSIndexPath).row])
        cell?.selectionStyle = .none

        return cell ?? UITableViewCell()
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: Constants.StoryboardID.main, bundle: nil)

        let cell = tableView.cellForRow(at: indexPath) as? MainMenuTableViewCell

        switch cell?.myLabel?.text {
        case myDataSource[0]:
            let controller = storyboard.instantiateViewController(
                withIdentifier: Constants.StoryboardID.check) as? CheckViewController
            if let toPresent = controller {
                self.navigationController?.pushViewController(toPresent, animated: true)
            }
        case myDataSource[1]:
            let controller = storyboard.instantiateViewController(
                withIdentifier: Constants.StoryboardID.factorize) as? FactorizeViewController
            if let toPresent = controller {
                self.navigationController?.pushViewController(toPresent, animated: true)
            }
        case myDataSource[2]:
            let controller = storyboard.instantiateViewController(
                withIdentifier: Constants.StoryboardID.list) as? ListViewController
            if let toPresent = controller {
                self.navigationController?.pushViewController(toPresent, animated: true)
            }
        case myDataSource[3]:
            let controller = storyboard.instantiateViewController(
                withIdentifier: Constants.StoryboardID.random) as? RandomViewController
            if let toPresent = controller {
                self.navigationController?.pushViewController(toPresent, animated: true)
            }
        case myDataSource[4]:
            let controller = storyboard.instantiateViewController(
                withIdentifier: Constants.StoryboardID.next) as? NextViewController
            if let toPresent = controller {
                self.navigationController?.pushViewController(toPresent, animated: true)
            }
        case myDataSource[5]:
            let controller = storyboard.instantiateViewController(
                withIdentifier: Constants.StoryboardID.previous) as? PreviousViewController
            if let toPresent = controller {
                self.navigationController?.pushViewController(toPresent, animated: true)
            }
        default:
            let alert = createAlert(alertReasonParam: AlertReason.unknown)
            alert.view.layoutIfNeeded()
            present(alert, animated: true)
        }
    }


}


extension MainMenuTableViewController: MFMailComposeViewControllerDelegate {


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


extension MainMenuTableViewController {


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
