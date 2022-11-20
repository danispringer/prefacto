//
//  NextViewController.swift
// Prefacto
//
//  Created by Daniel Springer on 1/12/20.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI

class NextViewController: UIViewController,
                          UITextFieldDelegate {


    // MARK: Outlets

    @IBOutlet weak var myTextField: MyTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var actionButton: UIButton!


    // MARK: Properties

    let myThemeColor: UIColor = .systemTeal


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if CommandLine.arguments.contains("--prefactoScreenshots") {
            // We are in testing mode, make arrangements if needed
            UIView.setAnimationsEnabled(false)
        }

        notif.addObserver(self, selector: #selector(showKeyboard),
                          name: .tryShowingKeyboard, object: nil)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        myTextField.delegate = self
        setThemeColorTo(myThemeColor: myThemeColor)
        self.title = Const.TitleEnum.Next.rawValue
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showKeyboard()
    }


    // MARK: Helpers

    @objc func showKeyboard() {
        guard self.presentedViewController == nil else {
            // something is already being presented. don't show keyboard to avoid weird bugs.
            // this might be a band-aid. ideally you want to directly handle an alert being
            // presented over another, not simply prevent the keyboard from being presented
            // if an alert is shown, to prevent that one scenario.
            return
        }
        myTextField.becomeFirstResponder()
    }


    @IBAction func nextTapped() {
        DispatchQueue.main.async {
            self.enableUI(enabled: false)
        }
        DispatchQueue.main.async {
            guard let userNumber = self.isNumberOrNil(textfield: self.myTextField) else {
                return
            }
            guard self.isNotEdgeCaseNumber(number: userNumber) else {
                return
            }
            var nextPrime: UInt64 = 0

            let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
            downloadQueue.async {
                var foundNextPrime = false
                var possibleNextPrime = userNumber // we add 1 below

                while !foundNextPrime {
                    if possibleNextPrime == UInt64.max {
                        let alert = self.createAlert(alertReasonParam: .overflow,
                                                     num: userNumber)
                        DispatchQueue.main.async {
                            alert.view.layoutIfNeeded()
                            self.enableUI(enabled: true)
                            self.present(alert, animated: true)
                        }
                        return
                    }
                    possibleNextPrime += 1
                    if UInt64.IsPrime(number: possibleNextPrime).isPrime {
                        foundNextPrime = true
                        nextPrime = possibleNextPrime
                    }
                }

                DispatchQueue.main.async {
                    self.presentResult(originalNumber: userNumber, nextPrime: nextPrime)
                }
            }
        }
    }


    func isNumberOrNil(textfield: UITextField) -> UInt64? {
        guard let myTextFieldText = textfield.text else {
            let alert = self.createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return nil
        }
        guard !myTextFieldText.isEmpty else {
            let alert = self.createAlert(alertReasonParam: .textfieldEmptySingle)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return nil
        }
        let trimmedText = myTextFieldText.trimmingCharacters(in: .whitespaces)
        guard let number = UInt64(trimmedText) else {
            let alert = self.createAlert(alertReasonParam: .notNumberOrTooBig)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return nil
        }
        return number
    }


    func isNotEdgeCaseNumber(number: UInt64) -> Bool {
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


    func presentResult(originalNumber: UInt64, nextPrime: UInt64) {
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
            withIdentifier: Const.StoryboardID.nextResults)
        as? NextResultsViewController
        controller?.originalNumber = originalNumber
        controller?.nextPrime = nextPrime
        DispatchQueue.main.async {
            self.enableUI(enabled: true)
            if let toPresent = controller {
                self.present(toPresent, animated: true)
            }
        }
    }


    func enableUI(enabled: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = !enabled
            self.actionButton.isEnabled = enabled
            self.myTextField.isEnabled = enabled
            _ = enabled ? self.activityIndicator.stopAnimating() :
            self.activityIndicator.startAnimating()
            //self.view.endEditing(!enabled)
        }
    }


    // MARK: TextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextTapped()
        return true
    }

}
