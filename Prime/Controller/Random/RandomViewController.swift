//
//  RandomViewController.swift
//  Prime
//
//  Created by Daniel Springer on 17/07/2018.
//  Copyright © 2020 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit
import Intents


class RandomViewController: UIViewController, SKStoreProductViewControllerDelegate {


    // MARK: Outlets

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var randomizeButton: UIButton!


    // MARK: Properties

    enum SizeOptions: String {
        case xSmall = "Extra-Small"
        case small = "Small"
        case medium = "Medium"
        case large = "Large"
        case xLarge = "Extra-Large"
    }

    // MARK: Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        randomizeButton.setTitle(Const.Messages.randomize, for: .normal)
        self.title = Const.Title.random
    }


    // MARK: Helpers

    @IBAction func randomizeButtonPressed(_ sender: Any) {
        let activity = NSUserActivity(activityType: Const.Messages.bundleAndRandom)
        activity.title = "Get random prime"
        activity.isEligibleForSearch = true

        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(Const.Messages.bundleAndRandom)
        activity.suggestedInvocationPhrase = "Show me a Random Prime"
        view.userActivity = activity
        activity.becomeCurrent()

        showOptions()
    }


    func makeRandomShortcut() {

        var limit = Int64.max / 10 * 9
        limit /= power(coeff: 10, exp: 12)
        var randInt = Int64.random(in: 1...limit)
        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        downloadQueue.async {

            while !Int64.IsPrime(number: randInt).isPrime {
                randInt += 1
            }
            DispatchQueue.main.async {
                self.presentResult(number: randInt, size: SizeOptions.medium, fromShortcut: true)
            }
        }
    }


    func makeRandom(size: SizeOptions) {

        let downloadQueue = DispatchQueue(label: "download", qos: .userInitiated)
        downloadQueue.async {
            var limit = Int64.max / 10 * 9
            switch size {
            case .xSmall:
                limit /= self.power(coeff: 10, exp: 16)
            case .small:
                limit /= self.power(coeff: 10, exp: 15)
            case .medium:
                limit /= self.power(coeff: 10, exp: 12)
            case .large:
                limit /= self.power(coeff: 10, exp: 7)
            case .xLarge:
                break
            }
            var randInt = Int64.random(in: 1...limit)

            while !Int64.IsPrime(number: randInt).isPrime {
                randInt += 1
            }
            DispatchQueue.main.async {
                self.presentResult(number: randInt, size: size, fromShortcut: false)
            }
        }
    }


    func power(coeff: Int64, exp: Int64) -> Int64 {
        var initialValue = coeff
        for _ in 1...exp {
            initialValue *= coeff
        }
        return initialValue
    }


    func showOptions() {
        var userChoice = SizeOptions.xSmall
        let alert = UIAlertController(title: "Choose Size",
                                      message: "Choose your random prime's size",
                                      preferredStyle: .actionSheet)
        alert.modalPresentationStyle = .popover
        let cancelAction = UIAlertAction(title: Const.Messages.cancel, style: .cancel)
        let xSmallAction = UIAlertAction(title: SizeOptions.xSmall.rawValue, style: .default) { _ in
            userChoice = .xSmall
            DispatchQueue.main.async {
                self.enableUI(enabled: false)
            }
            self.makeRandom(size: userChoice)
        }
        let smallAction = UIAlertAction(title: SizeOptions.small.rawValue, style: .default) { _ in
            userChoice = .small
            DispatchQueue.main.async {
                self.enableUI(enabled: false)
            }
            self.makeRandom(size: userChoice)
        }
        let mediumAction = UIAlertAction(title: SizeOptions.medium.rawValue, style: .default) { _ in
            userChoice = .medium
            DispatchQueue.main.async {
                self.enableUI(enabled: false)
            }
            self.makeRandom(size: userChoice)
        }
        let largeAction = UIAlertAction(title: SizeOptions.large.rawValue, style: .default) { _ in
            userChoice = .large
            DispatchQueue.main.async {
                self.enableUI(enabled: false)
            }
            self.makeRandom(size: userChoice)
        }
        let xLargeAction = UIAlertAction(title: SizeOptions.xLarge.rawValue, style: .default) { _ in
            userChoice = .xLarge
            DispatchQueue.main.async {
                self.enableUI(enabled: false)
            }
            self.makeRandom(size: userChoice)
        }
        for action in [cancelAction, xSmallAction, smallAction, mediumAction, largeAction, xLargeAction] {
            alert.addAction(action)
        }
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            presenter.permittedArrowDirections = []
        }
        present(alert, animated: true)

    }


    func presentResult(number: Int64, size: SizeOptions, fromShortcut: Bool) {
        let storyboard = UIStoryboard(name: Const.StoryboardID.main, bundle: nil)
        let randomResultsVC = storyboard.instantiateViewController(
            withIdentifier: Const.StoryboardID.randomResults) as? RandomResultsViewController
        randomResultsVC?.myNumber = number
        randomResultsVC?.myTitle = "Your Random \(size.rawValue) Prime"
        DispatchQueue.main.async {
            if !fromShortcut {
                self.enableUI(enabled: true)
            }
            if let toPresent = randomResultsVC {
                self.dismiss(animated: false, completion: {
                    self.present(toPresent, animated: !fromShortcut)
                })
            }
        }
    }


    func enableUI(enabled: Bool) {
        DispatchQueue.main.async {
            self.randomizeButton.isHidden = !enabled
            self.randomizeButton.isEnabled = enabled
            _ = enabled ? self.activityIndicator.stopAnimating() :
                self.activityIndicator.startAnimating()
            self.view.endEditing(!enabled)
        }
    }

}
