//
//  NextResultsViewController.swift
// Prefacto
//
//  Created by Daniel Springer on 1/13/20.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit


class NextResultsViewController: UIViewController {


    // MARK: Outlets

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!


    // MARK: Properties

    var originalNumber: UInt64!
    var nextPrime: UInt64!

    let myThemeColor: UIColor = .systemTeal


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if CommandLine.arguments.contains("--prefactoScreenshots") {
            // We are in testing mode, make arrangements if needed
            UIView.setAnimationsEnabled(false)
        }

        setThemeColorTo(myThemeColor: myThemeColor)

        guard let myOriginalNumber = originalNumber, let myNextPrime = nextPrime else {
            let alert = self.createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return
        }
        resultLabel.attributedText = nextPrimeMessage(localOriginalNumber: myOriginalNumber,
                                                      localNextPrime: myNextPrime,
                                                      color: myThemeColor)

        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
    }


    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        notif.post(name: .tryShowingKeyboard, object: nil)
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
        message = nextPrimeMessageShare(localOriginalNumber: myOriginalNumber,
                                        localNextPrime: myNextPrime)
        message += "\n\n" + Const.UX.thisAppLink
        let activityController = UIActivityViewController(activityItems: [message],
                                                          applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = shareBarButtonItem
        activityController
            .completionWithItemsHandler = { (_, _: Bool, _: [Any]?, error: Error?) in
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
            notif.post(name: .tryShowingKeyboard, object: nil, userInfo: nil)
        })
    }

}
