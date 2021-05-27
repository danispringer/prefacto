//
//  ListViewController.swift
//  Prime
//
//  Created by Daniel Springer on 24/06/2018.
//  Copyright © 2020 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI


class ListViewController: UIViewController, UITextFieldDelegate {


    // MARK: Outlets

    @IBOutlet weak var firstTextField: MyTextField!
    @IBOutlet weak var secondTextField: MyTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    // MARK: Properties

    var arrayOfInts = [Int64]()
    var previousButton = UIBarButtonItem()
    var nextButton = UIBarButtonItem()
    var myResignToolbar: UIToolbar! = nil


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        notif.addObserver(self, selector: #selector(showKeyboard), name: .didDisappear, object: nil)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        myResignToolbar = UIToolbar()

        arrayOfInts = []

        firstTextField.delegate = self
        secondTextField.delegate = self

        let listButton = UIBarButtonItem(
            title: Const.Messages.list,
            style: .plain,
            target: self,
            action: #selector(listButtonPressed))

        let doneButton = UIBarButtonItem(
            title: Const.Messages.done,
            style: .plain,
            target: self,
            action: #selector(donePressed))

        previousButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.up"),
            style: .plain,
            target: self,
            action: #selector(previousTextField))

        previousButton.accessibilityLabel = "Go up"

        nextButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.down"),
            style: .plain,
            target: self,
            action: #selector(nextTextField))

        nextButton.accessibilityLabel = "Go down"

        let spaceFlexible = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil)

        let spaceFix = UIBarButtonItem(
            barButtonSystemItem: .fixedSpace,
            target: self,
            action: nil)

        myResignToolbar.items = [
            previousButton, spaceFix, nextButton, spaceFlexible, doneButton, listButton
        ]
        myResignToolbar.sizeToFit()
        myResignToolbar.setBackgroundImage(UIImage(),
                                           forToolbarPosition: .any,
                                           barMetrics: .default)
        myResignToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)

        for textfield in [firstTextField, secondTextField] {
            textfield?.inputAccessoryView = myResignToolbar
            textfield?.placeholder = Const.Messages.placeholderText
        }

        self.title = Const.Title.list
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showKeyboard()
    }


    // MARK: Helpers

    @objc func showKeyboard() {
        let myInt: Int = UDStan.integer(forKey: Const.UserDef.selectedTextField)
        if myInt == 1 {
            secondTextField.becomeFirstResponder()
        } else {
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
        UDStan.setValue(textField.tag, forKey: Const.UserDef.selectedTextField)
    }


    @objc func donePressed() {
        firstTextField.resignFirstResponder()
        secondTextField.resignFirstResponder()
    }


    // MARK: TextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstTextField:
            secondTextField.becomeFirstResponder()
        case secondTextField:
            secondTextField.resignFirstResponder()
            listButtonPressed()
        default:
            fatalError()
        }
        return true
    }


    @objc func listButtonPressed() {

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
            let alert = createAlert(alertReasonParam: .textfieldEmpty)
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
        guard ([firstNum, secondNum].allSatisfy { $0 != 0 }) else {
            let alert = createAlert(alertReasonParam: .zero)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                if firstNum == 0 {
                    self.firstTextField.becomeFirstResponder()
                } else {
                    self.secondTextField.becomeFirstResponder()
                }
                self.present(alert, animated: true)
            }
            return false
        }
        guard ([firstNum, secondNum].allSatisfy { $0 > 0 }) else {
            let alert = createAlert(alertReasonParam: .negative)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                alert.view.layoutIfNeeded()
                if !(firstNum > 0) {
                    self.firstTextField.becomeFirstResponder()
                } else {
                    self.secondTextField.becomeFirstResponder()
                }

                self.present(alert, animated: true)
            }
            return false
        }
        guard !(firstNum == secondNum) else {
            let alert = createAlert(alertReasonParam: .sameTwice)
            let goToCheckAction = UIAlertAction(
                title: "\(Const.Messages.check)",
                style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
                let storyboard = UIStoryboard(name: Const.StoryboardID.main, bundle: nil)
                let checkVC = storyboard.instantiateViewController(
                    withIdentifier: Const.StoryboardID.check) as? CheckViewController
                UDStan.setValue("\(firstNum)", forKey: Const.UserDef.numFromList)
                self.navigationController?.pushViewController(checkVC!, animated: true)

            }
            alert.addAction(goToCheckAction)
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
            self.firstTextField.isEnabled = enabled
            self.secondTextField.isEnabled = enabled
            _ = enabled ? self.activityIndicator.stopAnimating() :
                self.activityIndicator.startAnimating()
            self.view.endEditing(!enabled)
        }
    }

}
