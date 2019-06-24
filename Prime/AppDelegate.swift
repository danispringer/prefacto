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
            Constants.UserDef.showSeparator: false,
            Constants.UserDef.iconIsDark: true])

        let tabBar = UITabBar.appearance()
        tabBar.clipsToBounds = true
        tabBar.unselectedItemTintColor = UIColor.systemBlue

        UINavigationBar.appearance().isOpaque = false
        UINavigationBar.appearance().isTranslucent = false

        for state: UIControl.State in [.normal, .selected, .highlighted, .disabled] {
            UIBarButtonItem.appearance().setTitleTextAttributes(
                [
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)
                ], for: state)
        }

        return true
    }


    // MARK: Shortcuts

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        let tab = window?.rootViewController as? UITabBarController

        // TODO: make cleaer
        let randomVC = tab?.viewControllers?[3] as? RandomViewController
        randomVC?.makeRandomShortcut()


        return true
    }


}
