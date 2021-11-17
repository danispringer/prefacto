//
//  ListResultsViewController.swift
//  Prime
//
//  Created by Daniel Springer on 08/07/2018.
//  Copyright © 2021 Daniel Springer. All rights reserved.
//

import UIKit


class ListResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    // MARK: Outlets

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var jumpToTopButton: UIButton!
    @IBOutlet weak var jumpToBottomButton: UIButton!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!


    // MARK: Properties

    var source: [Int64]!
    var rangeFrom: Int64!
    var rangeTo: Int64!
    let listCell = "ListCell"

    var myThemeColor: UIColor!


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setThemeColorTo(myThemeColor: myThemeColor)

        guard let myFrom = rangeFrom, let myTo = rangeTo else {
            let alert = self.createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return
        }
        let myFromFormatted = "\(myFrom)"
        let myToFormatted = "\(myTo)"
        localSource = source
        if source.count == 0 {
            resultsTableView.isHidden = true
            jumpToTopButton.isHidden = true
            jumpToBottomButton.isHidden = true
            resultLabel.text = """
            There are no primes between
            \(myFromFormatted)
            and
            \(myToFormatted)
            """
        } else if source.count == 1 {
            let sourceFormatted = "\(source[0])"
            resultsTableView.isHidden = true
            jumpToTopButton.isHidden = true
            jumpToBottomButton.isHidden = true
            resultLabel.text = """
            The only prime between
            \(myFromFormatted)
            and
            \(myToFormatted)
            is
            \(sourceFormatted)
            """
        } else if source.count == 2 {
            let sourceFirstFormatted = "\(source.first!)"
            let sourceLastFormatted = "\(source.last!)"
            resultsTableView.isHidden = true
            jumpToTopButton.isHidden = true
            jumpToBottomButton.isHidden = true
            resultLabel.text = """
            The primes between
            \(myFromFormatted)
            and
            \(myToFormatted)
            are
            \(sourceFirstFormatted)
            and
            \(sourceLastFormatted)
            """
        } else {
            let sourceCountFormatted = "\(source.count)"
            resultLabel.text = """
            There are
            \(sourceCountFormatted)
            primes between
            \(myFromFormatted)
            and
            \(myToFormatted)
            """
        }
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
    }


    // MARK: Helpers

    func jumpToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        resultsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }


    @IBAction func jumpToTopPressed(_ sender: Any) {
        resultsTableView.flashScrollIndicators()
        jumpToTop()
    }


    @IBAction func jumpToBottomPressed(_ sender: Any) {
        resultsTableView.flashScrollIndicators()
        let indexPath = IndexPath(row: resultsTableView.numberOfRows(inSection: 0) - 1, section: 0)
        resultsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }


    @IBAction func share(_ sender: Any) {
        var message = ""
        guard rangeFrom != nil, rangeTo != nil else {
            let alert = createAlert(alertReasonParam: .unknown)
            present(alert, animated: true)
            return
        }
        localFrom = rangeFrom
        localTo = rangeTo
        guard source.count != 0 else {
            message = Const.UX.manyPrimesInRange
            presentShareController(message: message)
            return
        }
        guard let mySource = source else {
            let alert = createAlert(alertReasonParam: .unknown)
            present(alert, animated: true)
            return
        }
        localSource = mySource
        message = Const.UX.manyPrimesInRange
        message += "\n\n" + Const.UX.thisAppLink

        presentShareController(message: message)
    }


    func presentShareController(message: String) {
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = shareBarButtonItem
        activityController.completionWithItemsHandler = { (_, _: Bool, _: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: .unknown)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.present(alert, animated: true)
                }
                return
            }
        }
        self.present(activityController, animated: true)
    }


    @IBAction func donePressed(_ sender: Any) {
        dismiss(animated: true, completion: {
            notif.post(name: .didDisappear, object: nil, userInfo: nil)
        })
    }


    // MARK: Delegates

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: listCell) as? ListTableViewCell

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
            let cell = tableView.cellForRow(at: indexPath) as? ListTableViewCell
            let pasteboard = UIPasteboard.general
            pasteboard.string = cell?.numberLabel?.text
        }
    }

}
