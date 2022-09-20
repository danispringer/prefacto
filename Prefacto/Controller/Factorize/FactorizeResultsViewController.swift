//
//  FactorizeResultsViewController.swift
// Prefacto
//
//  Created by Daniel Springer on 09/07/2018.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit


class FactorizeResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    // MARK: Outlets

    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var shareButtonItem: UIBarButtonItem!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var jumpToTopButton: UIButton!
    @IBOutlet weak var jumpToBottomButton: UIButton!


    // MARK: Properties

    var sourceRaw: [UInt64]!
    var number: UInt64!
    var sourceNoDupes: [NSAttributedString]!

    let factorCell = "FactorCell"
    let myThemeColor: UIColor = .systemBlue


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if CommandLine.arguments.contains("--prefactoScreenshots") {
            // We are in testing mode, make arrangements if needed
            UIView.setAnimationsEnabled(false)
        }

        setThemeColorTo(myThemeColor: myThemeColor)

        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)

        guard let myNumber = number else {
            let alert = createAlert(alertReasonParam: .unknown)
            present(alert, animated: true)
            return
        }
        //let myNumberFormatted = "\(myNumber)"
        //let sourceRawCountAsString = "\(sourceRaw.count)"

        sourceNoDupes = mergeDupesOf(array: sourceRaw)

        if sourceRaw.count == 1 {
            resultsTableView.isHidden = true
            jumpToTopButton.isHidden = true
            jumpToBottomButton.isHidden = true
            resultLabel.attributedText = isPrimeMessage(localNumber: myNumber, color: myThemeColor)
        } else {
            resultLabel.text = """
            Value: \(myNumber)
            Count of factors: \(sourceNoDupes.count)
            """
        }
    }


    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        notif.post(name: .tryShowingKeyboard, object: nil)
    }


    // MARK: Helpers

    func mergeDupesOf(array: [UInt64]) -> [NSAttributedString] {

        let fontRegular = UIFont.preferredFont(forTextStyle: .body)
        let fontSuper = UIFont.preferredFont(forTextStyle: .caption2)
        let attrRegular: [NSAttributedString.Key: Any] = [.font: fontRegular]
        let attrSuper: [NSAttributedString.Key: Any] = [.font: fontSuper, .baselineOffset: 10] // TODO: get half height of body font size

        var valuesForNum: [UInt64: UInt64] = [:]
        for number in sourceRaw {
            if valuesForNum.keys.contains(number) {
                valuesForNum[number]! += 1
            } else {
                valuesForNum[number] = 1
            }
        }
        var arrayOfStrings: [NSAttributedString] = []
        for pair in valuesForNum {
            if pair.value == 1 {
                var myAttrString = NSMutableAttributedString(string: "")
                myAttrString.append(NSAttributedString(string: "\(pair.key)", attributes: attrRegular))
                arrayOfStrings.append(myAttrString)
            } else {
                var myAttrString = NSMutableAttributedString(string: "")
                myAttrString.append(NSAttributedString(string: "\(pair.key)", attributes: attrRegular))
                myAttrString.append(NSAttributedString(string: "\(pair.value)", attributes: attrSuper))
                arrayOfStrings.append(myAttrString)
            }

        }
        return arrayOfStrings
    }


    @IBAction func jumpToTopPressed(_ sender: Any) {
        resultsTableView.flashScrollIndicators()
        let indexPath = IndexPath(row: 0, section: 0)
        resultsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }


    @IBAction func jumpToBottomPressed(_ sender: Any) {
        resultsTableView.flashScrollIndicators()
        let indexPath = IndexPath(row: resultsTableView.numberOfRows(inSection: 0) - 1, section: 0)
        resultsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }


    @IBAction func share(_ sender: Any) {
        var message = ""
        guard number != nil, sourceRaw != nil else {
            let alert = self.createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return
        }
        if sourceRaw.count == 1 {
            message = isPrimeMessageShare(localNumber: number)
        } else {
            message = manyPrimeFactorsShare(localNumber: number, localSource: sourceRaw)
        }
        message += "\n\n" + Const.UX.thisAppLink
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = shareButtonItem
        activityController.completionWithItemsHandler = { (_, _: Bool, _: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: .unknown)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
                return
            }
        }
        present(activityController, animated: true)
    }


    @IBAction func donePressed(_ sender: Any) {
        dismiss(animated: true, completion: {
            notif.post(name: .tryShowingKeyboard, object: nil, userInfo: nil)
        })
    }


    // MARK: Delegates

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceNoDupes.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: factorCell) as? FactorizeTableViewCell
        cell?.numberLabel?.attributedText = sourceNoDupes[indexPath.row]
        cell?.selectionStyle = .none
        cell?.indexLabel?.text = "\(indexPath.row + 1)."
        cell?.accessibilityLabel = cell?.numberLabel?.text
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
