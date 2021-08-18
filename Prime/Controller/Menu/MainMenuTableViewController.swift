//
//  MainMenuTableViewController.swift
//  Prime
//
//  Created by Daniel Springer on 11/18/19.
//  Copyright © 2021 Dani Springer. All rights reserved.
//

import UIKit
import MessageUI
import IntentsUI

class MainMenuTableViewController: UIViewController,
                                   UITableViewDataSource,
                                   UITableViewDelegate {


    // MARK: Outlets

    @IBOutlet var myTableView: UITableView!
    @IBOutlet weak var aboutButton: UIBarButtonItem!


    // MARK: Properties

    let myDataSource = ["Check if a given number is prime",
                        "Decompose a given number to its prime factors",
                        "List all prime numbers in a given range",
                        "Generate a random prime number of a given size",
                        "Find the next prime number after a given number",
                        "Find the previous prime number before a given number"]
    let myImageSource = ["checkmark", "divide", "list.dash", "shuffle", "plus", "minus"]

    let menuCell = "MenuCell"

    let addToSiriController = UIViewController()


    // MARK: Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        aboutButton.menu = aboutMenu()
        aboutButton.image = UIImage(systemName: "ellipsis.circle")
    }


    // MARK: Helpers

    func aboutMenu() -> UIMenu {
        let shareApp = UIAction(title: Const.Messages.shareApp, image: UIImage(systemName: "heart"),
                                state: .off) { _ in
            self.shareApp()
        }
        let contact = UIAction(title: Const.Messages.sendFeedback, image: UIImage(systemName: "envelope"),
                               state: .off) { _ in
            self.launchEmail()
        }
        let review = UIAction(title: Const.Messages.leaveReview,
                              image: UIImage(systemName: "hand.thumbsup"), state: .off) { _ in
            self.requestReview()
        }

        let addToSiri = UIAction(title: Const.Messages.addToSiri,
                              image: UIImage(systemName: "mic.circle"), state: .off) { _ in
            self.presentAddToSiri()
        }

        let moreApps = UIAction(title: Const.Messages.showAppsButtonTitle, image: UIImage(systemName: "apps.iphone"),
                                state: .off) { _ in
            self.showApps()
        }
        let version: String? = Bundle.main.infoDictionary![Const.Messages.appVersion] as? String
        var myTitle = Const.Messages.appName
        if let safeVersion = version {
            myTitle += " \(Const.Messages.version) \(safeVersion)"
        }

        let aboutMenu = UIMenu(title: myTitle, options: .displayInline,
                              children: [contact, review, shareApp, moreApps, addToSiri])
        return aboutMenu
    }


    func presentAddToSiri() {
        let addToSiriButton = INUIAddVoiceShortcutButton(style: .white)
        let activity = NSUserActivity(activityType: Const.Messages.bundleAndRandom)
        activity.title = Const.Messages.randomize
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(Const.Messages.bundleAndRandom)
        activity.suggestedInvocationPhrase = Const.Messages.randomize
        view.userActivity = activity
        activity.becomeCurrent()

        addToSiriButton.translatesAutoresizingMaskIntoConstraints = false
        addToSiriButton.shortcut = INShortcut(userActivity: activity)
        addToSiriButton.delegate = self
        addToSiriController.view.addSubview(addToSiriButton)
        addToSiriController.view.backgroundColor = UIColor.systemBackground

        let doneButton = UIButton()
        let font = UIFont.preferredFont(forTextStyle: .body)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setAttributedTitle(NSAttributedString(
                                        string: "Done",
                                        attributes: [NSAttributedString.Key.font: font]), for: .normal)
        doneButton.setTitleColor(UIColor(named: Const.View.specialButtonColor), for: .normal)
        doneButton.addTarget(self, action: #selector(addToSiriDonePressed), for: .touchUpInside)
        addToSiriController.view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            addToSiriButton.centerXAnchor.constraint(equalTo: addToSiriController.view.centerXAnchor),
            addToSiriButton.centerYAnchor.constraint(equalTo: addToSiriController.view.centerYAnchor),
            doneButton.centerXAnchor.constraint(equalTo: addToSiriController.view.centerXAnchor),
            doneButton.bottomAnchor.constraint(equalTo: addToSiriController.view.bottomAnchor, constant: -64),
            doneButton.widthAnchor.constraint(equalToConstant: 120),
            addToSiriButton.widthAnchor.constraint(equalToConstant: 320),
            addToSiriButton.heightAnchor.constraint(equalToConstant: 64)
        ])

        self.navigationController?.present(addToSiriController, animated: true)

    }


    @objc func addToSiriDonePressed() {
        addToSiriController.dismiss(animated: true)
    }


    func shareApp() {
        let message = Const.Messages.shareMessage
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = aboutButton
        activityController.completionWithItemsHandler = { (_, _: Bool, _: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: .unknown)
                self.present(alert, animated: true)
                return
            }
        }
        present(activityController, animated: true)
    }


    func showApps() {

        let myURL = URL(string: Const.Messages.appsLink)

        guard let safeURL = myURL else {
            let alert = createAlert(alertReasonParam: .unknown)
            present(alert, animated: true)
            return
        }

        UIApplication.shared.open(safeURL, options: [:], completionHandler: nil)

    }


    // MARK: TableView Delegate

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil//"Check, List, Factorize"
        } else {
            fatalError()
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataSource.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: menuCell) as! MainMenuTableViewCell

        cell.myLabel.text = myDataSource[(indexPath as NSIndexPath).row]
        cell.myImage.image = UIImage(systemName: myImageSource[(indexPath as NSIndexPath).row])
        //cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: Const.StoryboardID.main, bundle: nil)

        let cell = tableView.cellForRow(at: indexPath) as? MainMenuTableViewCell

        switch cell?.myLabel?.text {
        case myDataSource[0]:
            let controller = storyboard.instantiateViewController(
                withIdentifier: Const.StoryboardID.check) as? CheckViewController
            if let toPresent = controller {
                self.navigationController?.pushViewController(toPresent, animated: true)
            }
        case myDataSource[1]:
            let controller = storyboard.instantiateViewController(
                withIdentifier: Const.StoryboardID.factorize) as? FactorizeViewController
            if let toPresent = controller {
                self.navigationController?.pushViewController(toPresent, animated: true)
            }
        case myDataSource[2]:
            let controller = storyboard.instantiateViewController(
                withIdentifier: Const.StoryboardID.list) as? ListViewController
            if let toPresent = controller {
                self.navigationController?.pushViewController(toPresent, animated: true)
            }
        case myDataSource[3]:
            let controller = storyboard.instantiateViewController(
                withIdentifier: Const.StoryboardID.random) as? RandomViewController
            if let toPresent = controller {
                self.navigationController?.pushViewController(toPresent, animated: true)
            }
        case myDataSource[4]:
            let controller = storyboard.instantiateViewController(
                withIdentifier: Const.StoryboardID.next) as? NextViewController
            if let toPresent = controller {
                self.navigationController?.pushViewController(toPresent, animated: true)
            }
        case myDataSource[5]:
            let controller = storyboard.instantiateViewController(
                withIdentifier: Const.StoryboardID.previous) as? PreviousViewController
            if let toPresent = controller {
                self.navigationController?.pushViewController(toPresent, animated: true)
            }
        default:
            let alert = createAlert(alertReasonParam: AlertReason.unknown)
            alert.view.layoutIfNeeded()
            present(alert, animated: true)
        }

        tableView.deselectRow(at: indexPath, animated: true)

    }


}


extension MainMenuTableViewController: MFMailComposeViewControllerDelegate {


    // MARK: Helpers

    func launchEmail() {
        var emailTitle = Const.Messages.appName
        if let version = Bundle.main.infoDictionary![Const.Messages.appVersion] {
            emailTitle += " \(version)"
        }
        let messageBody = Const.Messages.emailSample
        let toRecipents = [Const.Messages.emailAddress]
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

    func requestReview() {
        guard let writeReviewURL = URL(string: Const.Messages.appReviewLink)
        else {
            fatalError("Expected a valid URL")
        }
        UIApplication.shared.open(writeReviewURL, options:
                                    convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]),
                                  completionHandler: nil)
    }

}

extension MainMenuTableViewController: INUIAddVoiceShortcutButtonDelegate {

    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController,
                 for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        addVoiceShortcutViewController.delegate = self
        addToSiriController.present(addVoiceShortcutViewController, animated: true, completion: nil)
    }

    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController,
                 for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        addToSiriController.present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
}

extension MainMenuTableViewController: INUIAddVoiceShortcutViewControllerDelegate,
                                       INUIEditVoiceShortcutViewControllerDelegate {

    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController,
                                        didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
                                         didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
                                         didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true, completion: nil)
    }

    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}


// Helper function inserted by Swift 4.2 migrator.

private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(
    _ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in
                        (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
