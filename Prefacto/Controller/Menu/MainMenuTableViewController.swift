//
//  MainMenuTableViewController.swift
// Prefacto
//
//  Created by Daniel Springer on 11/18/19.
//  Copyright © 2024 Daniel Springer. All rights reserved.
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

    let menuCell = "MenuCell"

    let addToSiriController = UIViewController()

    let myThemeColor = UIColor.systemBlue


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if CommandLine.arguments.contains("--prefactoScreenshots") {
            // We are in testing mode, make arrangements if needed
            UIView.setAnimationsEnabled(false)
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setThemeColorTo(myThemeColor: myThemeColor)

        aboutButton.menu = aboutMenu()
        aboutButton.image = UIImage(systemName: "ellipsis.circle")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        myTableView.flashScrollIndicators()
    }


    // MARK: Helpers

    func aboutMenu() -> UIMenu {
        let shareApp = UIAction(title: Const.UX.shareApp, image: UIImage(systemName: "heart"),
                                state: .off) { _ in
            self.shareApp()
        }
        let review = UIAction(title: Const.UX.leaveReview,
                              image: UIImage(systemName: "hand.thumbsup"), state: .off) { _ in
            self.requestReview()
        }

        let addToSiri = UIAction(title: Const.UX.addToSiri,
                                 image: UIImage(systemName: "mic.circle"), state: .off) { _ in
            self.presentAddToSiri()
        }

        let moreApps = UIAction(title: Const.UX.showAppsButtonTitle,
                                image: UIImage(systemName: "apps.iphone"),
                                state: .off) { _ in
            self.showApps()
        }
        let emailAction = UIAction(title: Const.UX.contact,
                                   image: UIImage(systemName: "envelope.badge"),
                                   state: .off) { _ in
            self.sendEmailTapped()
        }
        let version: String? = Bundle.main.infoDictionary![Const.UX.appVersion] as? String
        var myTitle = Const.UX.appName
        if let safeVersion = version {
            myTitle += " \(Const.UX.version) \(safeVersion)"
        }

        let aboutMenu = UIMenu(title: myTitle, options: .displayInline,
                               children: [emailAction, review, shareApp, moreApps, addToSiri])
        return aboutMenu
    }


    func presentAddToSiri() {
        let addToSiriButton = INUIAddVoiceShortcutButton(style: .whiteOutline)
        let activity = NSUserActivity(activityType: Const.UX.bundleAndRandom)
        activity.title = Const.UX.randomize
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(
            Const.UX.bundleAndRandom)
        activity.suggestedInvocationPhrase = Const.UX.randomize
        view.userActivity = activity
        activity.becomeCurrent()

        addToSiriButton.translatesAutoresizingMaskIntoConstraints = false
        addToSiriButton.shortcut = INShortcut(userActivity: activity)
        addToSiriButton.delegate = self
        addToSiriController.view.addSubview(addToSiriButton)
        addToSiriController.view.backgroundColor = UIColor.systemBackground

        let closeSiriButton = UIButton()
        closeSiriButton.configuration = .filled()
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        closeSiriButton.translatesAutoresizingMaskIntoConstraints = false
        closeSiriButton.setAttributedTitle(NSAttributedString(
            string: Const.UX.done,
            attributes: [NSAttributedString.Key.font: font]), for: .normal)
        closeSiriButton.addTarget(self, action: #selector(closeSiriTapped), for: .touchUpInside)
        addToSiriController.view.addSubview(closeSiriButton)

        NSLayoutConstraint.activate([
            addToSiriButton.centerXAnchor.constraint(
                equalTo: addToSiriController.view.centerXAnchor),
            addToSiriButton.centerYAnchor.constraint(
                equalTo: addToSiriController.view.centerYAnchor),
            closeSiriButton.centerXAnchor.constraint(
                equalTo: addToSiriController.view.centerXAnchor),
            closeSiriButton.topAnchor.constraint(
                equalTo: addToSiriButton.bottomAnchor, constant: 64),
            closeSiriButton.widthAnchor.constraint(equalToConstant: 120),
            addToSiriButton.widthAnchor.constraint(equalToConstant: 320),
            addToSiriButton.heightAnchor.constraint(equalToConstant: 64)
        ])

        self.navigationController?.present(addToSiriController, animated: true)

    }


    @objc func closeSiriTapped() {
        addToSiriController.dismiss(animated: true)
    }


    func shareApp() {
        let message = Const.UX.thisAppLink
        let activityController = UIActivityViewController(activityItems: [message],
                                                          applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = aboutButton
        activityController
            .completionWithItemsHandler = { (_, _: Bool, _: [Any]?, error: Error?) in
                guard error == nil else {
                    let alert = self.createAlert(alertReasonParam: .unknown)
                    self.present(alert, animated: true)
                    return
                }
            }
        present(activityController, animated: true)
    }


    func showApps() {

        let myURL = URL(string: Const.UX.appsLink)

        guard let safeURL = myURL else {
            let alert = createAlert(alertReasonParam: .unknown)
            present(alert, animated: true)
            return
        }

        UIApplication.shared.open(safeURL, options: [:], completionHandler: nil)

    }


    // MARK: TableView Delegate

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "By Daniel Springer"
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Const.TitleEnum.allCases.count
    }


    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: menuCell)
        as! MainMenuTableViewCell

        let myIndexRow: Int = (indexPath as NSIndexPath).row
        cell.myLabel.text = Const.titleArrFromEnum[myIndexRow]
        let aConfig = UIImage.SymbolConfiguration(weight: .bold)
        let aImage = UIImage(systemName: Const.myImageSource[(indexPath as NSIndexPath).row],
                             withConfiguration: aConfig)
        cell.newImageView.image = aImage
        cell.newImageView.tintColor = .white
        cell.imageViewContainer.backgroundColor = Const.tintColorsArray[
            (indexPath as NSIndexPath).row]
        cell.imageViewContainer.layer.cornerRadius = 6
        cell.accessoryType = .disclosureIndicator

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: Const.StoryboardID.main, bundle: nil)

        let cell = tableView.cellForRow(at: indexPath) as? MainMenuTableViewCell

        switch cell?.myLabel?.text {
            case Const.TitleEnum.Check.rawValue:
                let controller = storyboard.instantiateViewController(
                    withIdentifier: Const.StoryboardID.check) as? CheckViewController
                if let toPresent = controller {
                    self.navigationController?.pushViewController(toPresent, animated: true)
                }
            case Const.TitleEnum.Factorize.rawValue:
                let controller = storyboard.instantiateViewController(
                    withIdentifier: Const.StoryboardID.factorize) as? FactorizeViewController
                if let toPresent = controller {
                    self.navigationController?.pushViewController(toPresent, animated: true)
                }
            case Const.TitleEnum.List.rawValue:
                let controller = storyboard.instantiateViewController(
                    withIdentifier: Const.StoryboardID.list) as? ListViewController
                if let toPresent = controller {
                    self.navigationController?.pushViewController(toPresent, animated: true)
                }
            case Const.TitleEnum.Randomize.rawValue:
                let controller = storyboard.instantiateViewController(
                    withIdentifier: Const.StoryboardID.random) as? RandomViewController
                if let toPresent = controller {
                    self.navigationController?.pushViewController(toPresent, animated: true)
                }
            case Const.TitleEnum.Next.rawValue:
                let controller = storyboard.instantiateViewController(
                    withIdentifier: Const.StoryboardID.next) as? NextViewController
                if let toPresent = controller {
                    self.navigationController?.pushViewController(toPresent, animated: true)
                }
            case Const.TitleEnum.Previous.rawValue:
                let controller = storyboard.instantiateViewController(
                    withIdentifier: Const.StoryboardID.previous) as? PreviousViewController
                if let toPresent = controller {
                    self.navigationController?.pushViewController(toPresent, animated: true)
                }
            default:
                let alert = createAlert(alertReasonParam: .unknown)
                alert.view.layoutIfNeeded()
                present(alert, animated: true)
        }

        tableView.deselectRow(at: indexPath, animated: true)

    }


}

extension MainMenuTableViewController: MFMailComposeViewControllerDelegate {

    func sendEmailTapped() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }


    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the
        // --mailComposeDelegate-- property, NOT the --delegate-- property

        let recipient = Const.API.key +
        Const.API.password +
        Const.API.code +
        Const.API.user +
        Const.UX.apple

        mailComposerVC.setToRecipients([recipient])
        let version: String? = Bundle.main.infoDictionary![Const.UX.appVersion] as? String
        var myTitle = Const.UX.appName
        if let safeVersion = version {
            myTitle += " \(Const.UX.version) \(safeVersion)"
        }
        mailComposerVC.setSubject(myTitle)
        mailComposerVC.setMessageBody("Hi, I have a question about your app.", isHTML: false)

        return mailComposerVC
    }


    func showSendMailErrorAlert() {
        let alert = createAlert(alertReasonParam: .emailError)
        present(alert, animated: true)
    }


    // MARK: MFMailComposeViewControllerDelegate

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}


extension MainMenuTableViewController {


    // MARK: Helpers

    func requestReview() {
        guard let writeReviewURL = URL(string: Const.UX.appReviewLink)
        else {
            fatalError("Expected a valid URL")
        }
        UIApplication.shared
            .open(writeReviewURL, options:
                    convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]),
                  completionHandler: nil)
    }

}

extension MainMenuTableViewController: INUIAddVoiceShortcutButtonDelegate {

    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController,
                 for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        addVoiceShortcutViewController.delegate = self
        addToSiriController.present(addVoiceShortcutViewController,
                                    animated: true, completion: nil)
    }

    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController,
                 for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        addToSiriController.present(editVoiceShortcutViewController,
                                    animated: true, completion: nil)
    }
}

extension MainMenuTableViewController: INUIAddVoiceShortcutViewControllerDelegate,
                                       INUIEditVoiceShortcutViewControllerDelegate {

    func addVoiceShortcutViewController(
        _ controller: INUIAddVoiceShortcutViewController,
        didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
        }

    func addVoiceShortcutViewControllerDidCancel(
        _ controller: INUIAddVoiceShortcutViewController) {
            controller.dismiss(animated: true, completion: nil)
        }

    func editVoiceShortcutViewController(
        _ controller: INUIEditVoiceShortcutViewController,
        didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
        }

    func editVoiceShortcutViewController(
        _ controller: INUIEditVoiceShortcutViewController,
        didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
            controller.dismiss(animated: true, completion: nil)
        }

    func editVoiceShortcutViewControllerDidCancel(
        _ controller: INUIEditVoiceShortcutViewController) {
            controller.dismiss(animated: true, completion: nil)
        }
}


// Helper function inserted by Swift 4.2 migrator.

private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(
    _ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in
            (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
