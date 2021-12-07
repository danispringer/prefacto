//
//  FactorizeViewController.swift
//  Prime
//
//  Created by Daniel Springer on 19/06/2018.
//  Copyright © 2021 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI


class FactorizeViewController: UIViewController, UITextFieldDelegate {


    // MARK: Outlets

    @IBOutlet weak var myTextField: MyTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    // MARK: Properties

    var arrayOfInts = [Int64]()
    var myToolbar: UIToolbar! = nil

    let myThemeColor: UIColor = .systemBlue


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setThemeColorTo(myThemeColor: myThemeColor)

        notif.addObserver(self, selector: #selector(showKeyboard), name: .didDisappear, object: nil)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        myToolbar = UIToolbar()

        arrayOfInts = []

        myTextField.delegate = self

        let factorButton = UIBarButtonItem(
            title: Const.Title.factorize,
            style: .plain,
            target: self,
            action: #selector(factorizeButtonPressed))

        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        myToolbar.items = [space, factorButton]
        myToolbar.sizeToFit()
        myToolbar.setBackgroundImage(UIImage(),
                                           forToolbarPosition: .any,
                                           barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)

        myTextField.inputAccessoryView = myToolbar
        myTextField.placeholder = Const.UX.placeholderText
        self.title = Const.Title.factorize
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showKeyboard()
    }


    // MARK: Helpers

    @objc func showKeyboard() {
        myTextField.becomeFirstResponder()
    }


    @objc func factorizeButtonPressed() {
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
            self.arrayOfInts = []
            self.primeFactors(number: number)
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
            let alert = createAlert(alertReasonParam: .textfieldEmpty)
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
        guard number != 0 else {
            let alert = createAlert(alertReasonParam: .zero)
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
                self.present(alert, animated: true)
            }
            return false
        }
        guard !(number < 0) else {
            let alert = createAlert(alertReasonParam: .negative)
            DispatchQueue.main.async {
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


    func presentResults(number: Int64) {
        guard let myNav = self.navigationController, myNav.topViewController == self else {
            // the view is not currently displayed. abort.
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
            self.myTextField.isEnabled = enabled
            _ = enabled ? self.activityIndicator.stopAnimating() :
            self.activityIndicator.startAnimating()
        }
    }


    // MARK: TextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        factorizeButtonPressed()

        return true
    }

}
