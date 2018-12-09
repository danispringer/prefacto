//
//  CheckerResultsViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 09/07/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit
import AVFoundation


class CheckerResultsViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var myToolbar: UIToolbar!



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
                AppData.getSoundEnabledSettings(sound: Sound.negative)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return
        }

        if isPrime {
            resultLabel.text = "\(myNumber): prime."
        } else {
            resultLabel.text = "\(myNumber): not prime.\nDivisible by: \(myIsDivisibleBy)."

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

        if isPrime {
            message = """
            Hey, did you know that \(myNumber) is a prime number? I just found out, using this \
            app: https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        } else {
            message = """
            Hey, did you know that \(myNumber) is not prime, because it is divisible by \
            \(myIsDivisibleBy)? I just found out, using this app: \
            https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
            """
        }


        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view // for iPads not to crash
        activityController.completionWithItemsHandler = {
            (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: .unknown)
                DispatchQueue.main.async {
                    alert.view.layoutIfNeeded()
                    self.present(alert, animated: true)
                    AppData.getSoundEnabledSettings(sound: Sound.negative)
                }
                return
            }
        }
        self.present(activityController, animated: true)
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
