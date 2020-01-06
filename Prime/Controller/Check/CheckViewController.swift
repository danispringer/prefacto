//
//  CheckViewController.swift
//  Prime
//
//  Created by Daniel Springer on 19/06/2018.
//  Copyright © 2020 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

class CheckViewController: UIViewController, SKStoreProductViewControllerDelegate,
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

        let checkButton = UIBarButtonItem()

        checkButton.title = Constants.Messages.check
        checkButton.style = .plain
        checkButton.target = self
        checkButton.action = #selector(checkButtonPressed)
        let doneButton = UIBarButtonItem(title: Constants.Messages.done,
                                           style: .plain,
                                           target: self,
                                           action: #selector(donePressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        myResignToolBar.items = [doneButton, space, checkButton]
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


    @objc func checkButtonPressed() {
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
            var isPrimeBool = true
            var isDivisibleBy: Int64 = 0
            guard userNumber != 2 else {
                DispatchQueue.main.async {
                    self.enableUI(enabled: true)
                    self.presentResult(number: userNumber, isPrime: isPrimeBool, isDivisibleBy: isDivisibleBy)
                }
                return
            }
            let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
            downloadQueue.async {
                let results = Int64.IsPrime(number: userNumber)
                isPrimeBool = results.isPrime
                isDivisibleBy = results.divisor
                DispatchQueue.main.async {
                    self.presentResult(number: userNumber, isPrime: isPrimeBool, isDivisibleBy: isDivisibleBy)
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


    func isNotEdgeCaseNumber(number: Int64) -> Bool {
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
        return true
    }


    func presentResult(number: Int64, isPrime: Bool, isDivisibleBy: Int64) {
        let storyboard = UIStoryboard(name: Constants.StoryboardID.main, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardID.checkResults)
            as? CheckResultsViewController
        controller?.number = number
        controller?.isPrime = isPrime
        controller?.isDivisibleBy = isDivisibleBy
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
        checkButtonPressed()

        return true
    }


}
