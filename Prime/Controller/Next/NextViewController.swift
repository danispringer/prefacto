//
//  NextViewController.swift
//  Prime
//
//  Created by Daniel Springer on 1/12/20.
//  Copyright © 2020 Dani Springer. All rights reserved.
//

import UIKit
import MessageUI

class NextViewController: UIViewController,
                          UITextFieldDelegate {


    // MARK: Outlets

    @IBOutlet weak var myTextField: MyTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    // MARK: Properties

    var myResignToolBar: UIToolbar! = nil


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        notif.addObserver(self, selector: #selector(showKeyboard), name: .didDisappear, object: nil)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        myResignToolBar = UIToolbar()

        let nextButton = UIBarButtonItem()

        nextButton.title = Const.Messages.next
        nextButton.style = .plain
        nextButton.target = self
        nextButton.action = #selector(nextButtonPressed)
        let doneButton = UIBarButtonItem(title: Const.Messages.done,
                                         style: .plain,
                                         target: self,
                                         action: #selector(donePressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        myResignToolBar.items = [doneButton, space, nextButton]
        myResignToolBar.sizeToFit()
        myResignToolBar.setBackgroundImage(UIImage(),
                                           forToolbarPosition: .any,
                                           barMetrics: .default)
        myResignToolBar.setShadowImage(UIImage(), forToolbarPosition: .any)

        myTextField.inputAccessoryView = myResignToolBar
        myTextField.placeholder = Const.Messages.placeholderText
        self.title = Const.Title.next
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showKeyboard()
    }


    // MARK: Helpers

    @objc func showKeyboard() {
        myTextField.becomeFirstResponder()
    }


    @objc func donePressed() {
        myTextField.resignFirstResponder()
    }


    @objc func nextButtonPressed() {
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
            var nextPrime: Int64 = 0

            let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
            downloadQueue.async {
                var foundNextPrime = false
                var possibleNextPrime = userNumber // we add 1 below

                while !foundNextPrime {
                    if possibleNextPrime == Int.max {
                        let alert = self.createAlert(alertReasonParam: .overflow, num: userNumber)
                        DispatchQueue.main.async {
                            alert.view.layoutIfNeeded()
                            self.enableUI(enabled: true)
                            self.present(alert, animated: true)
                        }
                        return
                    }
                    possibleNextPrime += 1
                    if Int64.IsPrime(number: possibleNextPrime).isPrime {
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


    func presentResult(originalNumber: Int64, nextPrime: Int64) {
        guard let myNav = self.navigationController, myNav.topViewController == self else {
            // the view is not currently displayed. abort.
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
            }
            return
        }
        let storyboard = UIStoryboard(name: Const.StoryboardID.main, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Const.StoryboardID.nextResults)
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
            self.myTextField.isEnabled = enabled
            _ = enabled ? self.activityIndicator.stopAnimating() :
                self.activityIndicator.startAnimating()
            self.view.endEditing(!enabled)
        }
    }


    // MARK: TextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextButtonPressed()

        return true
    }


}
