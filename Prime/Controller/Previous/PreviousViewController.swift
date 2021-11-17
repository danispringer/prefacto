//
//  PreviousViewController.swift
//  Prime
//
//  Created by Daniel Springer on 10/8/20.
//  Copyright © 2021 Dani Springer. All rights reserved.
//


import UIKit
import MessageUI


class PreviousViewController: UIViewController,
                              UITextFieldDelegate {


    // MARK: Outlets

    @IBOutlet weak var myTextField: MyTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    // MARK: Properties

    var myResignToolBar: UIToolbar! = nil

    var myThemeColor: UIColor!


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        notif.addObserver(self, selector: #selector(showKeyboard), name: .didDisappear, object: nil)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setThemeColorTo(myThemeColor: myThemeColor)

        myResignToolBar = UIToolbar()

        let previousButton = UIBarButtonItem()

        previousButton.title = Const.Title.previous
        previousButton.style = .plain
        previousButton.target = self
        previousButton.action = #selector(previousButtonPressed)
        let doneButton = UIBarButtonItem(title: Const.UX.done,
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
        myTextField.placeholder = Const.UX.placeholderText

        self.title = Const.Title.previous
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        showKeyboard()
    }


    // MARK: Helpers

    @objc func showKeyboard() {
        myTextField.becomeFirstResponder()
    }


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
                var possiblePreviousPrime = userNumber // we subtract below

                while !foundPreviousPrime {
                    possiblePreviousPrime -= 1
                    if Int64.IsPrime(number: possiblePreviousPrime).isPrime {
                        foundPreviousPrime = true
                        previousPrime = possiblePreviousPrime
                    }

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
        guard let myNav = self.navigationController, myNav.topViewController == self else {
            // the view is not currently displayed. abort.
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
            }
            return
        }
        let storyboard = UIStoryboard(name: Const.StoryboardID.main, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Const.StoryboardID.previousResults)
        as? PreviousResultsViewController
        controller?.originalNumber = originalNumber
        controller?.previousPrime = previousPrime
        controller?.myThemeColor = myThemeColor
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
