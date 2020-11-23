//
//  RandomResultsViewController.swift
//  Prime
//
//  Created by Daniel Springer on 17/07/2018.
//  Copyright © 2020 Daniel Springer. All rights reserved.
//

import UIKit
import StoreKit


class RandomResultsViewController: UIViewController {


    // MARK: Outlets

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var copyButton: UIButton!


    // MARK: Properties

    var myNumber: Int64!
    var myTitle: String!


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        let showSeparator = UserDefaults.standard.bool(forKey: Const.UserDef.showSeparator)
        let myNumberFormatted = showSeparator ? separate(number: myNumber) : "\(myNumber!)"
        resultLabel.text = "\(myNumberFormatted)"
        titleLabel.text = myTitle
    }


    // MARK: Helpers

    func separate(number: Int64) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let myNSNumber = NSNumber(value: number)
        return formatter.string(from: myNSNumber)!
    }


    @IBAction func share() {
        var message = ""
        guard let myNumber = myNumber else {
            let alert = self.createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return
        }
        localNumber = myNumber
        message = Const.Messages.isPrimeMessage
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


    @IBAction func copyPressed(_ sender: Any) {
        if let myNumber = myNumber {
            UIPasteboard.general.string = String(myNumber)
        }
    }


    @IBAction func donePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
