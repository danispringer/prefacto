//
//  RandomViewController.swift
// Prefacto
//
//  Created by Daniel Springer on 17/07/2018.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI
import Intents


class RandomViewController: UIViewController {


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

    let myThemeColor: UIColor = .systemOrange


    // MARK: Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setThemeColorTo(myThemeColor: myThemeColor)

        randomizeButton.setTitle(Const.UX.randomize, for: .normal)
        self.title = Const.Title.random
        randomizeButton.menu = randomMenu()
        randomizeButton.showsMenuAsPrimaryAction = true
    }


    // MARK: Helpers

    func randomMenu() -> UIMenu {

        var userChoice = SizeOptions.xSmall
        let xSmallAction = UIAction(title: SizeOptions.xSmall.rawValue, state: .off) { _ in
            userChoice = .xSmall
            DispatchQueue.main.async {
                self.enableUI(enabled: false)
            }
            self.makeRandom(size: userChoice)
        }
        let smallAction = UIAction(title: SizeOptions.small.rawValue, state: .off) { _ in
            userChoice = .small
            DispatchQueue.main.async {
                self.enableUI(enabled: false)
            }
            self.makeRandom(size: userChoice)
        }
        let mediumAction = UIAction(title: SizeOptions.medium.rawValue, state: .off) { _ in
            userChoice = .medium
            DispatchQueue.main.async {
                self.enableUI(enabled: false)
            }
            self.makeRandom(size: userChoice)
        }
        let largeAction = UIAction(title: SizeOptions.large.rawValue, state: .off) { _ in
            userChoice = .large
            DispatchQueue.main.async {
                self.enableUI(enabled: false)
            }
            self.makeRandom(size: userChoice)
        }
        let xLargeAction = UIAction(title: SizeOptions.xLarge.rawValue, state: .off) { _ in
            userChoice = .xLarge
            DispatchQueue.main.async {
                self.enableUI(enabled: false)
            }
            self.makeRandom(size: userChoice)
        }

        let randomMenu = UIMenu(title: "Choose Size", image: nil, identifier: .none,
                                options: .displayInline,
                                children: [xSmallAction, smallAction, mediumAction, largeAction, xLargeAction])
        return randomMenu
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
        // donate to siri shortcuts
        let activity = NSUserActivity(activityType: Const.UX.bundleAndRandom)
        activity.title = Const.UX.randomize
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(Const.UX.bundleAndRandom)
        activity.suggestedInvocationPhrase = Const.UX.randomize
        view.userActivity = activity
        activity.becomeCurrent()

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


    func presentResult(number: Int64, size: SizeOptions, fromShortcut: Bool) {
        guard let myNav = self.navigationController, myNav.topViewController == self else {
            // the view is not currently displayed. abort.
            DispatchQueue.main.async {
                if !fromShortcut {
                    self.enableUI(enabled: true)
                }
            }
            return
        }

        if self.presentedViewController is RandomResultsViewController {
            self.dismiss(animated: false) {
                guard self.presentedViewController == nil else {
                    // something is already being presented. investigate...
                    DispatchQueue.main.async {
                        if !fromShortcut {
                            self.enableUI(enabled: true)
                        }
                    }
                    return
                }
            }
        }

        
        let storyboard = UIStoryboard(name: Const.StoryboardID.main, bundle: nil)
        let controller = storyboard.instantiateViewController(
            withIdentifier: Const.StoryboardID.randomResults) as! RandomResultsViewController
        controller.myNumber = number
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: {
                if fromShortcut {
                    self.navigationController!.present(controller, animated: !fromShortcut)
                } else {
                    self.present(controller, animated: !fromShortcut)
                }
            })
            if !fromShortcut {
                self.enableUI(enabled: true)
            }
        }
    }


    func enableUI(enabled: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = !enabled
            self.randomizeButton.isEnabled = enabled
            _ = enabled ? self.activityIndicator.stopAnimating() :
            self.activityIndicator.startAnimating()
            //self.view.endEditing(!enabled)
        }
    }

}
