//
//  FactorizeViewController.swift
// Prefacto
//
//  Created by Daniel Springer on 19/06/2018.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI


class FactorizeViewController: UIViewController, UITextFieldDelegate {


    // MARK: Outlets

    @IBOutlet weak var myTextField: MyTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var actionButton: UIButton!


    // MARK: Properties

    var arrayOfInts = [Int64]()

    let myThemeColor: UIColor = .systemBlue


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setThemeColorTo(myThemeColor: myThemeColor)

        notif.addObserver(self, selector: #selector(showKeyboard), name: .tryShowingKeyboard, object: nil)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        arrayOfInts = []

        myTextField.delegate = self


        self.title = Const.Title.factorize
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showKeyboard()
    }


    // MARK: Helpers

    @objc func showKeyboard() {
        guard self.presentedViewController == nil else {
            // something is already being presented. don't show keyboard to avoid weird bugs.
            // this might be a band-aid. ideally you want to directly handle an alert being presented over another, not
            // simply prevent the keyboard from being presented if an alert is shown, to prevent that one scenario.
            return
        }
        myTextField.becomeFirstResponder()
    }

    @IBAction func factorizeTapped() {
        DispatchQueue.main.async {
            self.enableUI(enabled: false)
        }
        guard let number = isNumberOrNil() else {
            return
        }
        guard isNotEdgeCase(number: number) else {
            return
        }
        let savedUserNumber = number
        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        downloadQueue.async {
            if number == 1 {
                self.arrayOfInts = [1]
            } else {
                self.arrayOfInts = []
                self.primeFactors(number: number)
            }
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.presentResults(number: savedUserNumber)
            }
        }
    }


    func isNumberOrNil() -> Int64? {
        guard let text = myTextField.text else {
            let alert = createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return nil
        }
        guard !text.isEmpty else {
            let alert = createAlert(alertReasonParam: .textfieldEmptySingle)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return nil
        }
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        guard let number = Int64(trimmedText) else {
            let alert = createAlert(alertReasonParam: .notNumberOrTooBig)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return nil
        }
        return number
    }


    func isNotEdgeCase(number: Int64) -> Bool {
        guard number > 0 else {
            let alert = self.createAlert(alertReasonParam: .higherThanZero)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return false
        }
        return true
    }


    func presentResults(number: Int64) {
        guard let myNav = self.navigationController, myNav.topViewController == self else {
            // the view is not currently displayed. abort.
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
            }
            return
        }
        guard self.presentedViewController == nil else {
            // something is already being presented. investigate...
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
            }
            return
        }
        let storyboard = UIStoryboard(name: Const.StoryboardID.main, bundle: nil)
        let controller = storyboard.instantiateViewController(
            withIdentifier: Const.StoryboardID.factorizeResults) as? FactorizeResultsViewController
        controller?.number = number
        controller?.source = arrayOfInts
        if let toPresent = controller {
            present(toPresent, animated: true)
        }
    }


    func primeFactors(number: Int64) {
        var localNumber = number
        var divisor: Int64 = 2
        while divisor * divisor <= localNumber {
            while localNumber % divisor == 0 {
                arrayOfInts.append(divisor)
                localNumber /= divisor
            }
            divisor += divisor == 2 ? 1 : 2
        }
        if localNumber > 1 {
            arrayOfInts.append(localNumber)
        }
    }


    func enableUI(enabled: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = !enabled
            self.actionButton.isEnabled = enabled
            self.myTextField.isEnabled = enabled
            _ = enabled ? self.activityIndicator.stopAnimating() :
            self.activityIndicator.startAnimating()
        }
    }


    // MARK: TextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        factorizeTapped()
        return true
    }

}
