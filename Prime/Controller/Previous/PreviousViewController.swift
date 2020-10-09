//
//  PreviousViewController.swift
//  Prime
//
//  Created by Daniel Springer on 10/8/20.
//  Copyright © 2020 Dani Springer. All rights reserved.
//


import UIKit
import MessageUI
import StoreKit

class PreviousViewController: UIViewController, SKStoreProductViewControllerDelegate,
UITextFieldDelegate {


    // MARK: Outlets

    @IBOutlet weak var myTextField: MyTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    // MARK: Properties

    var myResignToolBar: UIToolbar! = nil


    // MARK: Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        myResignToolBar = UIToolbar()

        let previousButton = UIBarButtonItem()

        previousButton.title = Constants.Messages.previous
        previousButton.style = .plain
        previousButton.target = self
        previousButton.action = #selector(previousButtonPressed)
        let doneButton = UIBarButtonItem(title: Constants.Messages.done,
                                           style: .plain,
                                           target: self,
                                           action: #selector(donePressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        myResignToolBar.items = [doneButton, space, previousButton]
        myResignToolBar.sizeToFit()
        myResignToolBar.setBackgroundImage(UIImage(),
                                             forToolbarPosition: .any,
                                             barMetrics: .default)
        myResignToolBar.setShadowImage(UIImage(), forToolbarPosition: .any)

        myTextField.inputAccessoryView = myResignToolBar
        myTextField.placeholder = Constants.Messages.placeholderText
    }


    // MARK: Helpers

    @objc func donePressed() {
        myTextField.resignFirstResponder()
    }


    @objc func previousButtonPressed() {
        DispatchQueue.main.async {
            self.enableUI(enabled: false)
        }
        DispatchQueue.main.async {
            guard let userNumber = self.isNumberOrNil(textfield: self.myTextField) else {
                return
            }
            guard self.isNotEdgeCaseNumberForPrevious(number: userNumber) else {
                return
            }
            var previousPrime: Int64 = 0

            let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
            downloadQueue.async {
                var foundPreviousPrime = false
                var possiblePreviousPrime = userNumber - 1

                while !foundPreviousPrime {
                    if Int64.IsPrime(number: possiblePreviousPrime).isPrime {
                        foundPreviousPrime = true
                        previousPrime = possiblePreviousPrime
                    }
                    possiblePreviousPrime -= 1
                }

                DispatchQueue.main.async {
                    self.presentResult(originalNumber: userNumber, previousPrime: previousPrime)
                }
            }
        }
    }


    func isNumberOrNil(textfield: UITextField) -> Int64? {
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
            let alert = self.createAlert(alertReasonParam: .textfieldEmpty)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return nil
        }
        let trimmedText = myTextFieldText.trimmingCharacters(in: .whitespaces)
        guard let number = Int64(trimmedText) else {
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


    func isNotEdgeCaseNumberForPrevious(number: Int64) -> Bool {
        guard number != 0 else {
            let alert = self.createAlert(alertReasonParam: .zero)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return false
        }
        guard !(number < 0) else {
            let alert = self.createAlert(alertReasonParam: .negative)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return false
        }
        guard number != 1 else {
            let alert = self.createAlert(alertReasonParam: .one)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return false
        }
        guard number != 2 else {
            let alert = self.createAlert(alertReasonParam: .two)
            DispatchQueue.main.async {
                alert.view.layoutIfNeeded()
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return false
        }
        return true
    }


    func presentResult(originalNumber: Int64, previousPrime: Int64) {
        let storyboard = UIStoryboard(name: Constants.StoryboardID.main, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardID.previousResults)
            as? PreviousResultsViewController
        controller?.originalNumber = originalNumber
        controller?.previousPrime = previousPrime
        DispatchQueue.main.async {
            self.enableUI(enabled: true)
            if let toPresent = controller {
                self.present(toPresent, animated: true)
            }
        }
    }


    func enableUI(enabled: Bool) {
        DispatchQueue.main.async {
            self.myTextField.isEnabled = enabled
            _ = enabled ? self.activityIndicator.stopAnimating() :
                self.activityIndicator.startAnimating()
            self.view.endEditing(!enabled)
        }
    }


    // MARK: TextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        previousButtonPressed()

        return true
    }


}
