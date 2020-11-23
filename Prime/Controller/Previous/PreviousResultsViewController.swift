//
//  PreviousResultsViewController.swift
//  Prime
//
//  Created by Daniel Springer on 10/8/20.
//  Copyright © 2020 Dani Springer. All rights reserved.
//


import UIKit
import StoreKit


class PreviousResultsViewController: UIViewController {


    // MARK: Outlets

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!


    // MARK: Properties

    var originalNumber: Int64!
    var previousPrime: Int64!


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let myOriginalNumber = originalNumber, let myPreviousPrime = previousPrime else {
            let alert = self.createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return
        }
        let showSeparator = UserDefaults.standard.bool(forKey: Const.UserDef.showSeparator)
        let myOriginalNumberFormatted = showSeparator ? separate(number: myOriginalNumber) : "\(myOriginalNumber)"
        let myPreviousPrimeFormatted = showSeparator ?
            separate(number: myPreviousPrime)
            : "\(myPreviousPrime)"
        resultLabel.text = """
        The previous prime before
        \(myOriginalNumberFormatted)
        is
        \(myPreviousPrimeFormatted)
        """

        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
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
        guard let myOriginalNumber = originalNumber, let myPreviousPrime = previousPrime else {
            DispatchQueue.main.async {
                let alert = self.createAlert(alertReasonParam: .unknown)
                self.present(alert, animated: true)
            }
            return
        }
        localOriginalNumber = myOriginalNumber
        localPreviousPrime = myPreviousPrime
        message = Const.Messages.previousPrimeMessage
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
        dismiss(animated: true, completion: nil)
    }


}
