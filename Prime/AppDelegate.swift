//
//  AppDelegate.swift
//  Prime
//
//  Created by Daniel Springer on 19/06/2018.
//  Copyright © 2019 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    // MARK: Properties

    var window: UIWindow?


    // Life Cycle

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [
        UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        UserDefaults.standard.register(defaults: [
            Constants.UserDef.soundEnabled: true,
            Constants.UserDef.darkModeEnabled: true,
            Constants.UserDef.showSeparator: false,
            Constants.UserDef.iconIsDark: true])

        let tabBar = UITabBar.appearance()
        tabBar.backgroundImage = UIImage.from(color: .clear)
        tabBar.shadowImage = UIImage.from(color: .clear)

        UINavigationBar.appearance().isOpaque = false
        UINavigationBar.appearance().isTranslucent = false

        for state: UIControl.State in [.normal, .selected, .highlighted] {
            UIBarButtonItem.appearance().setTitleTextAttributes(
                [
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)
                ], for: state)
        }

        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body),
                NSAttributedString.Key.foregroundColor: Constants.View.grayColor
            ], for: .disabled)

        return true
    }


    // MARK: Shortcuts

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        let tab = window?.rootViewController as? UITabBarController
        let randomVC = tab?.viewControllers?[3] as? RandomViewController
        randomVC?.makeRandomShortcut()


        return true
    }


}
