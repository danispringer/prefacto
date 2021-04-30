//
//  CheckResultsViewController.swift
//  Prime
//
//  Created by Daniel Springer on 09/07/2018.
//  Copyright © 2020 Daniel Springer. All rights reserved.
//

import UIKit
import StoreKit


class CheckResultsViewController: UIViewController {


    // MARK: Outlets

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!


    // MARK: Properties

    var number: Int64!
    var isPrime: Bool!
    var isDivisibleBy: Int64!


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let myNumber = number, let myIsDivisibleBy = isDivisibleBy else {
            let alert = self.createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return
        }
        let myNumberFormatted = "\(myNumber)"
        let myIsDivisibleByFormatted = "\(myIsDivisibleBy)"
        if isPrime {
            resultLabel.text = """
            \(myNumberFormatted)
            is prime.
            """
        } else {
            resultLabel.text = """
            \(myNumberFormatted)
            is not prime.
            It is divisible by
            \(myIsDivisibleByFormatted)
            """
        }
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
    }


    // MARK: Helpers

    @IBAction func share() {
        var message = ""
        guard let myNumber = number, let myIsDivisibleBy = isDivisibleBy else {
            DispatchQueue.main.async {
                let alert = self.createAlert(alertReasonParam: .unknown)
                self.present(alert, animated: true)
            }
            return
        }
        localNumber = myNumber
        localIsDivisibleBy = myIsDivisibleBy
        if isPrime {
            message = Const.Messages.isPrimeMessage
        } else {
            message = Const.Messages.isNotPrimeMessage
        }
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


}
