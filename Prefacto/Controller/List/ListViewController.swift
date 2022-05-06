//
//  ListViewController.swift
// Prefacto
//
//  Created by Daniel Springer on 24/06/2018.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI


class ListViewController: UIViewController, UITextFieldDelegate {


    // MARK: Outlets

    @IBOutlet weak var firstTextField: MyTextField!
    @IBOutlet weak var secondTextField: MyTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var actionButton: UIButton!


    // MARK: Properties

    var arrayOfInts = [Int64]()
    var previousButton = UIBarButtonItem()
    var nextButton = UIBarButtonItem()

    let myThemeColor: UIColor = .systemPurple

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setThemeColorTo(myThemeColor: myThemeColor)

        notif.addObserver(self, selector: #selector(showKeyboard), name: .tryShowingKeyboard, object: nil)

    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        arrayOfInts = []

        firstTextField.delegate = self
        secondTextField.delegate = self

        self.title = Const.Title.list
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

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
        if !secondTextField.isFirstResponder {
            firstTextField.becomeFirstResponder()
        }
    }


    @objc func previousTextField() {
        firstTextField.becomeFirstResponder()
    }


    @objc func nextTextField() {
        secondTextField.becomeFirstResponder()
    }


    func textFieldDidBeginEditing(_ textField: UITextField) {
        previousButton.isEnabled = !(textField.tag == 0)
        nextButton.isEnabled = (textField.tag == 0)
    }


    // MARK: TextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case firstTextField:
                secondTextField.becomeFirstResponder()
            case secondTextField:
                secondTextField.resignFirstResponder()
                listTapped()
            default:
                return false
        }
        return true
    }

    @IBAction func listTapped() {

        DispatchQueue.main.async {
            self.enableUI(enabled: false)
        }
        let results = isNumberOrNil()
        guard var firstNumber = results?.0, var secondNumber = results?.1 else {
            return
        }
        guard isNotEdgeCase(firstNum: firstNumber, secondNum: secondNumber) else {
            return
        }
        if firstNumber > secondNumber {
            swap(&firstNumber, &secondNumber)
        }
        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        downloadQueue.async {

            for number in firstNumber...secondNumber {
                if Int64.IsPrime(number: number).isPrime {
                    self.arrayOfInts.append(number)
                }
            }

            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                guard let myNav = self.navigationController, myNav.topViewController == self else {
                    // the view is not currently displayed. abort.
                    return
                }
                let storyboard = UIStoryboard(name: Const.StoryboardID.main, bundle: nil)
                let controller = storyboard.instantiateViewController(
                    withIdentifier: Const.StoryboardID.listResults) as? ListResultsViewController
                controller?.source = self.arrayOfInts

                // below line avoids bug that let old results get added to next ones
                // bug seems to have begun only once Int.isPrime extension was implemented
                self.arrayOfInts = []

                controller?.rangeFrom = firstNumber
                controller?.rangeTo = secondNumber
                controller?.myThemeColor = self.myThemeColor
                if let toPresent = controller {
                    self.present(toPresent, animated: true)
                }
            }
        }
    }


    func isNumberOrNil() -> (Int64, Int64)? {
        guard let firstText = firstTextField.text, let secondText = secondTextField.text else {
            let alert = createAlert(alertReasonParam: .unknown)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return nil
        }
        guard !firstText.isEmpty, !secondText.isEmpty else {
            let alert = firstText.isEmpty ?
            createAlert(alertReasonParam: .textfieldEmptyOne) :
            createAlert(alertReasonParam: .textfieldEmptyTwo)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                if firstText.isEmpty {
                    self.firstTextField.becomeFirstResponder()
                } else {
                    self.secondTextField.becomeFirstResponder()
                }
                self.present(alert, animated: true)
            }
            return nil
        }
        let firstTextTrimmed = firstText.trimmingCharacters(in: .whitespaces)
        let secondTextTrimmed = secondText.trimmingCharacters(in: .whitespaces)
        guard let firstNumber = Int64(firstTextTrimmed), let secondNumber = Int64(secondTextTrimmed) else {
            let alert = createAlert(alertReasonParam: .notNumberOrTooBig)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                if Int64(firstTextTrimmed) == nil {
                    self.firstTextField.becomeFirstResponder()
                } else {
                    self.secondTextField.becomeFirstResponder()
                }

                self.present(alert, animated: true)
            }
            return nil
        }
        return (firstNumber, secondNumber)
    }


    func isNotEdgeCase(firstNum: Int64, secondNum: Int64) -> Bool {
        guard ([firstNum, secondNum].allSatisfy { $0 > 0 }) else {
            let alert = createAlert(alertReasonParam: .higherPlease, higherThann: 0)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                if firstNum <= 0 {
                    self.firstTextField.becomeFirstResponder()
                } else {
                    self.secondTextField.becomeFirstResponder()
                }
                self.present(alert, animated: true)
            }
            return false
        }

        guard !(firstNum == secondNum) else {
            let alert = createAlert(alertReasonParam: .sameTwice, higherThann: -1)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
            }
            return false
        }
        return true
    }


    // MARK: Toggle UI

    func enableUI(enabled: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = !enabled
            self.actionButton.isEnabled = enabled
            self.firstTextField.isEnabled = enabled
            self.secondTextField.isEnabled = enabled
            _ = enabled ? self.activityIndicator.stopAnimating() :
            self.activityIndicator.startAnimating()
            //self.view.endEditing(!enabled)
        }
    }

}
