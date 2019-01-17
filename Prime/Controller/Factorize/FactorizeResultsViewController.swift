//
//  FactorizeResultsViewController.swift
//  Prime
//
//  Created by Daniel Springer on 09/07/2018.
//  Copyright © 2019 Daniel Springer. All rights reserved.
//

import UIKit
import AVFoundation
import StoreKit


class FactorizeResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    // MARK: Outlets

    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var shareButtonItem: UIBarButtonItem!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var jumpToTopButton: UIButton!
    @IBOutlet weak var jumpToBottomButton: UIButton!


    // MARK: Properties

    var source: [Int64]!
    var number: Int64!
    let factorCell = "FactorCell"


    // MARK: Life Cycle

    override func viewDidLoad() {
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)

        guard let myNumber = number else {
            let alert = createAlert(alertReasonParam: .unknown)
            present(alert, animated: true)
            return
        }
        let showSeparator = UserDefaults.standard.bool(forKey: Constants.UserDef.showSeparator)
        let myNumberFormatted = showSeparator ? separate(number: myNumber) : "\(myNumber)"
        let sourceFirstFormatted = showSeparator ? separate(number: source.first!) : "\(source.first!)"
        let sourceLastFormatted = showSeparator ? separate(number: source.last!) : "\(source.last!)"
        let sourceCountFormatted = showSeparator ?
            separate(number: Int64(source!.count)) : "\(source.count)"

        if source.count == 1 {
            resultsTableView.isHidden = true
            jumpToTopButton.isHidden = true
            jumpToBottomButton.isHidden = true
            resultLabel.text = """
            \(myNumberFormatted)
            is prime, therefore its only factor is itself
            """
        } else if source.count == 2 {
            resultsTableView.isHidden = true
            jumpToTopButton.isHidden = true
            jumpToBottomButton.isHidden = true
            resultLabel.text = """
            The prime factors of
            \(myNumberFormatted)
            are
            \(sourceFirstFormatted)
            and
            \(sourceLastFormatted)
            """
        } else {
            resultLabel.text = """
            \(myNumberFormatted)
            has
            \(sourceCountFormatted)
            prime factors
            """
        }

    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let darkMode = UserDefaults.standard.bool(forKey: Constants.UserDef.darkModeEnabled)

        myToolbar.tintColor = darkMode ? Constants.View.goldColor : Constants.View.blueColor
        resultLabel.textColor = darkMode ? .white : .black
        view.backgroundColor = darkMode ? .black : .white
        resultsTableView.backgroundColor = darkMode ? .black : .white
        for button in [jumpToTopButton, jumpToBottomButton] {
            button?.tintColor = darkMode ? Constants.View.goldColor : Constants.View.blueColor
        }
    }


    // MARK: Helpers

    func separate(number: Int64) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let myNSNumber = NSNumber(value: number)
        return formatter.string(from: myNSNumber)!
    }


    @IBAction func jumpToTopPressed(_ sender: Any) {
        resultsTableView.flashScrollIndicators()
        let indexPath = IndexPath(row: 0, section: 0)
        resultsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }


    @IBAction func jumpToBottomPressed(_ sender: Any) {
        resultsTableView.flashScrollIndicators()
        let indexPath = IndexPath(row: resultsTableView.numberOfRows(inSection: 0) - 1, section: 0)
        resultsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }


    @IBAction func share(_ sender: Any) {
        var message = ""
        guard number != nil, source != nil, let mySourceFirst = source.first, let mySourceLast = source.last else {
            let alert = self.createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                AppData.getSoundEnabledSettings(sound: Constants.Sound.negative)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return
        }
        localNumber = number
        localSource = source
        localSourceFirst = mySourceFirst
        localSourceLast = mySourceLast
        if source.count == 1 {
            message = Constants.Messages.isPrimeMessage
        } else if source.count == 2 {
            message = Constants.Messages.twoPrimeFactorsMessage
        } else {
            localSourceDroppedLastArray = Array(source.dropLast())
            localStringSourceDroppedLast = "\(localSourceDroppedLastArray)"
            localStart = localStringSourceDroppedLast.index(localStringSourceDroppedLast.startIndex, offsetBy: 1)
            localEnd = localStringSourceDroppedLast.index(localStringSourceDroppedLast.endIndex, offsetBy: -1)
            localRange = localStart..<localEnd

            localStringCleanedSourceDroppedLast = String(localStringSourceDroppedLast[localRange])

            message = Constants.Messages.manyPrimeFactorsMessage
        }
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = shareButtonItem
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: .unknown)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                    AppData.getSoundEnabledSettings(sound: Constants.Sound.negative)
                }
                return
            }
        }
        present(activityController, animated: true)
    }


    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        SKStoreReviewController.requestReview()
    }


    // MARK: Delegates

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let darkMode = UserDefaults.standard.bool(forKey: Constants.UserDef.darkModeEnabled)
        let indicator = scrollView.subviews.last as? UIImageView
        indicator?.image = nil
        indicator?.backgroundColor = darkMode ? .white : .black
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let darkMode = UserDefaults.standard.bool(forKey: Constants.UserDef.darkModeEnabled)
        let showSeparator = UserDefaults.standard.bool(forKey: Constants.UserDef.showSeparator)

        let cell = tableView.dequeueReusableCell(withIdentifier: factorCell) as? FactorizeTableViewCell
        cell?.numberLabel?.text = showSeparator ?
            separate(number: source[(indexPath as NSIndexPath).row])
            : "\(source[(indexPath as NSIndexPath).row])"
        cell?.selectionStyle = .none
        cell?.numberLabel?.textColor = darkMode ? .white : .black
        cell?.numberLabel?.font = UIFont.systemFont(ofSize: 30)
        cell?.indexLabel?.text = "\(indexPath.row + 1)."
        cell?.indexLabel?.textColor = darkMode ? .white : .black
        cell?.indexLabel?.font = UIFont.systemFont(ofSize: 20)
        cell?.backgroundColor = darkMode ? .black : .white
        cell?.contentView.backgroundColor = darkMode ? .black : .white
        return cell ?? UITableViewCell()
    }


    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    func tableView(_ tableView: UITableView, canPerformAction action: Selector,
                   forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return action == #selector(copy(_:))
    }


    func tableView(_ tableView: UITableView, performAction action: Selector,
                   forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if action == #selector(copy(_:)) {
            let cell = tableView.cellForRow(at: indexPath) as? FactorizeTableViewCell
            let pasteboard = UIPasteboard.general
            pasteboard.string = cell?.numberLabel?.text
        }
    }


}
