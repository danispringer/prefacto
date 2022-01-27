//
//  FactorizeResultsViewController.swift
// Prefacto
//
//  Created by Daniel Springer on 09/07/2018.
//  Copyright © 2021 Daniel Springer. All rights reserved.
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

    var source: [Int64]!
    var number: Int64!
    let factorCell = "FactorCell"

    let myThemeColor: UIColor = .systemBlue


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

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
        let myNumberFormatted = "\(myNumber)"
        let sourceCountFormatted = "\(source.count)"

        if source.count == 1 {
            resultsTableView.isHidden = true
            jumpToTopButton.isHidden = true
            jumpToBottomButton.isHidden = true
            resultLabel.text = """
            \(myNumberFormatted)
            is prime, therefore its only factor is itself
            """
        } else {
            resultLabel.text = """
            Value: \(myNumberFormatted)
            Count of factors: \(sourceCountFormatted)
            """
        }

    }


    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        notif.post(name: .tryShowingKeyboard, object: nil)
    }


    // MARK: Helpers

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
        guard number != nil, source != nil else {
            let alert = self.createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return
        }
        localNumber = number
        localSource = source
        if source.count == 1 {
            message = Const.UX.isPrimeMessage
        } else {
            message = Const.UX.manyPrimeFactors
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
        return source.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: factorCell) as? FactorizeTableViewCell
        cell?.numberLabel?.text = "\(source[(indexPath as NSIndexPath).row])"
        cell?.selectionStyle = .none
        cell?.indexLabel?.text = "\(indexPath.row + 1)."
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
