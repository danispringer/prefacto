//
//  RandomViewController.swift
// Prefacto
//
//  Created by Daniel Springer on 17/07/2018.
//  Copyright © 2024 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI
import Intents


class RandomViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Outlets

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var randomizeButton: UIButton!
    @IBOutlet weak var myPickerView: UIPickerView!


    // MARK: Properties

    let pickerDataSource = Array(1...20)

    let myThemeColor: UIColor = .systemOrange


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if CommandLine.arguments.contains("--prefactoScreenshots") {
            // We are in testing mode, make arrangements if needed
            UIView.setAnimationsEnabled(false)
        }

        myPickerView.selectRow(2, inComponent: 0, animated: true)

        // donate to siri shortcuts
        let activity = NSUserActivity(activityType: Const.UX.bundleAndRandom)
        activity.title = Const.UX.randomize
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(
            Const.UX.bundleAndRandom)
        activity.suggestedInvocationPhrase = Const.UX.randomize
        view.userActivity = activity
        activity.becomeCurrent()

    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setThemeColorTo(myThemeColor: myThemeColor)
        randomizeButton.setTitleNew(Const.UX.randomize)
        self.title = Const.TitleEnum.Randomize.rawValue
    }


    // MARK: Helpers

    @IBAction func randomTapped() {
        DispatchQueue.main.async {
            self.enableUI(enabled: false)
        }
        self.makeRandom()
    }


    func makeRandomShortcut() {
        let selected = Array(0...9).randomElement()! // cuz highest from datasource don't
        // load well from bg
        DispatchQueue.main.async { [self] in
            enableUI(enabled: false)
            myPickerView?.selectRow(selected, inComponent: 0, animated: true)
        }
        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        downloadQueue.async { [self] in
            let size = pickerDataSource[selected]
            let myRange = getRangeOf(size: size)
            var randInt = UInt64.random(in: myRange)
            while !UInt64.IsPrime(number: randInt).isPrime {
                randInt += 1
            }
            DispatchQueue.main.async {
                self.presentResult(number: randInt, size: size, fromShortcut: true)
            }
        }
    }


    func makeRandom() {
        let selected = myPickerView.selectedRow(inComponent: 0)
        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        downloadQueue.async { [self] in
            let size = pickerDataSource[selected]
            let myRange = getRangeOf(size: size)
            var randInt = UInt64.random(in: myRange)
            while !UInt64.IsPrime(number: randInt).isPrime {
                randInt += 1
            }
            DispatchQueue.main.async {
                self.presentResult(number: randInt, size: size, fromShortcut: false)
            }
        }
    }


    func presentResult(number: UInt64, size: Int, fromShortcut: Bool) {
        guard let myNav = self.navigationController, myNav.topViewController == self else {
            // the view is not currently displayed. abort.
            DispatchQueue.main.async {
                self.enableUI(enabled: true)
            }
            return
        }

        if self.presentedViewController is RandomResultsViewController {
            self.dismiss(animated: false) {
                guard self.presentedViewController == nil else {
                    // something is already being presented. investigate...
                    DispatchQueue.main.async {
                        self.enableUI(enabled: true)
                    }
                    return
                }
            }
        }


        let storyboard = UIStoryboard(name: Const.StoryboardID.main, bundle: nil)
        let controller = storyboard.instantiateViewController(
            withIdentifier: Const.StoryboardID.randomResults) as! RandomResultsViewController
        controller.myNumber = number
        controller.myTitle = "Your \(size)-digit Random Prime"
        DispatchQueue.main.async { [self] in
            dismiss(animated: false, completion: { [self] in
                if fromShortcut {
                    navigationController!.present(controller, animated: !fromShortcut)
                } else {
                    present(controller, animated: !fromShortcut)
                }
            })
            enableUI(enabled: true)
        }
    }


    func enableUI(enabled: Bool) {
        DispatchQueue.main.async { [self] in
            UIApplication.shared.isIdleTimerDisabled = !enabled
            randomizeButton?.isEnabled = enabled
            _ = enabled ? activityIndicator?.stopAnimating() :
            activityIndicator?.startAnimating()
            myPickerView?.isUserInteractionEnabled = enabled
        }
    }


    func getRangeOf(size: Int) -> ClosedRange<UInt64> {

        var firstNumber = "1"
        let toAppend = String(repeating: "0", count: size-1) // -1 cuz leading digit is 1
        firstNumber.append(contentsOf: toAppend)

        if size == 1 {
            firstNumber = "2" // so app doesn't try to use 1 in its range, which might cause
            // issues if randomly chosen
        }

        var lastNumber: UInt64 = 0

        if size == 20 { // just repeating 9s would be too high
            lastNumber = UInt64.max-1_000
        } else if size == 1 {
            lastNumber = 7 // cuz 7 is max 1digit prime, so >7 might go to 2 digits
        } else {
            lastNumber = UInt64("9" + String(repeating: "0", count: size-1))!
        }

        let firstNumberAsUInt64 = UInt64(firstNumber)!

        let myRange: ClosedRange<UInt64> = firstNumberAsUInt64...lastNumber
        return myRange
    }


    // MARK: PickerView Delegate

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        let digitDigits = row == 0 ? "digit" : "digits"
        return "\(pickerDataSource[row]) \(digitDigits)"
    }

    //    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
    // inComponent component: Int) {
    //
    //    }

}
