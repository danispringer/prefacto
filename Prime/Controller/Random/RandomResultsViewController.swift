//
//  RandomResultsViewController.swift
//  Prime
//
//  Created by Daniel Springer on 17/07/2018.
//  Copyright © 2021 Daniel Springer. All rights reserved.
//

import UIKit


class RandomResultsViewController: UIViewController {


    // MARK: Outlets

    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!


    // MARK: Properties

    var myNumber: Int64!

    var myThemeColor: UIColor!

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setThemeColorTo(myThemeColor: myThemeColor)

        myToolbar.setBackgroundImage(UIImage(),
                                     forToolbarPosition: .any,
                                     barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        let myNumberFormatted = "\(myNumber!)"
        resultButton.setTitle(myNumberFormatted, for: .normal)
        resultButton.showsMenuAsPrimaryAction = true
        resultButton.menu = UIMenu(
            title: "", options: .displayInline,
            children: [UIAction(title: NSLocalizedString("Copy", comment: ""),
                                image: UIImage(systemName: "doc.on.doc"),
                                state: .off) { _ in
                                    if let myNumber = self.myNumber {
                                        UIPasteboard.general.string = String(myNumber)
                                    }
                                }])

    }


    // MARK: Helpers

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
        message = Const.UX.isPrimeMessage
        message += "\n\n" + Const.UX.thisAppLink
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
