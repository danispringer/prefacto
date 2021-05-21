//
//  NextResultsViewController.swift
//  Prime
//
//  Created by Daniel Springer on 1/13/20.
//  Copyright © 2020 Dani Springer. All rights reserved.
//

import UIKit
import StoreKit


class NextResultsViewController: UIViewController {


    // MARK: Outlets

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!


    // MARK: Properties

    var originalNumber: Int64!
    var nextPrime: Int64!


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let myOriginalNumber = originalNumber, let myNextPrime = nextPrime else {
            let alert = self.createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return
        }
        let myOriginalNumberFormatted = "\(myOriginalNumber)"
        let myNextPrimeFormatted = "\(myNextPrime)"
        resultLabel.text = """
        The next prime after
        \(myOriginalNumberFormatted)
        is
        \(myNextPrimeFormatted)
        """

        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
    }


    // MARK: Helpers

    @IBAction func share() {
        var message = ""
        guard let myOriginalNumber = originalNumber, let myNextPrime = nextPrime else {
            DispatchQueue.main.async {
                let alert = self.createAlert(alertReasonParam: .unknown)
                self.present(alert, animated: true)
            }
            return
        }
        localOriginalNumber = myOriginalNumber
        localNextPrime = myNextPrime
        message = Const.Messages.nextPrimeMessage
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
