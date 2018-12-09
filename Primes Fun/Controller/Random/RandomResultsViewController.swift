//
//  RandomResultsViewController.swift
//  Primes Fun
//
//  Created by Dani Springer on 17/07/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import UIKit
import AVFoundation

class RandomResultsViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myToolbar: UIToolbar!

    // MARK: Properties

    var number: Int64!

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        myLabel.text = "\(number!)"
    }

    // MARK: Helpers

    @IBAction func share() {
        var message = ""
        guard let myNumber = number else {
            let alert = self.createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                AppData.getSoundEnabledSettings(sound: Sound.negative)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return
        }
        message = """
        Hey, did you know that \(myNumber) is a prime number? I just found out, using this app: \
        https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667
        """
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

    @IBAction func copyPressed(_ sender: Any) {
        if let myNumber = number {
            UIPasteboard.general.string = String(myNumber)
        }
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }

}
