//
//  AppDelegate.swift
//  Primes Fun
//
//  Created by Daniel Springer on 19/06/2018.
//  Copyright © 2018 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    // MARK: Properties

    var window: UIWindow?


    // Life Cycle

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.register(defaults: [Constants.UserDefaultsStrings.soundEnabled: true])
        let tabBar = UITabBar.appearance()
        tabBar.backgroundImage = UIImage.from(color: .clear)
        tabBar.shadowImage = UIImage.from(color: .clear)
        tabBar.tintColor = Constants.View.goldColor
        tabBar.unselectedItemTintColor = Constants.View.goldColor
        UIToolbar.appearance().tintColor = Constants.View.goldColor
        UIToolbar.appearance().barTintColor = .black
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().backgroundColor = Constants.View.goldColor
        UINavigationBar.appearance().isOpaque = false
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = Constants.View.goldColor
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: Constants.Font.math, size: 25)!
            ], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: Constants.Font.math, size: 25)!
            ], for: .selected)
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: Constants.Font.math, size: 25)!
            ], for: .highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: Constants.Font.math, size: 25)!,
                NSAttributedString.Key.foregroundColor: Constants.View.grayColor
            ], for: .disabled)
        return true
    }


    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        let viewController = window?.rootViewController as? RandomViewController
        viewController?.makeRandomShortcut()

        let tab = window?.rootViewController as? UITabBarController
        let randomVC = tab?.viewControllers?[3] as? RandomViewController
        randomVC?.makeRandomShortcut()

        return true
    }


}
